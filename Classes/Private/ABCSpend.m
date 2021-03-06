//
//  ABCSpend.m
//  AirBitz
//

#import "ABCSpend+Internal.h"
#import "ABCContext+Internal.h"

@interface ABCPaymentRequest ()
@property                           tABC_PaymentRequest     *pPaymentRequest;
@end

@interface ABCSpend ()
{
    ABCMetaData             *_metaData;
    ABCSpendFeeLevel        _feeLevel;
    uint64_t                _customFeeSatoshis;
}

@property (nonatomic)               void                    *pSpend;
@property (nonatomic, strong)       ABCWallet               *wallet;
@end

@interface ABCUnsentTx ()
@property                           ABCSpend                *spend;
@end


@implementation ABCPaymentRequest
- (void)dealloc;
{
    if (self.pPaymentRequest)
        ABC_FreePaymentRequest(self.pPaymentRequest);
}
@end

@implementation ABCUnsentTx

- (ABCError *)broadcastTx;
{
    tABC_Error error;
    ABC_SpendBroadcastTx(self.spend.pSpend, (char *)[self.base16 UTF8String], &error);

    ABCError *lnserror = [ABCError makeNSError:error];
    if (lnserror)
    {
        ABCLog(1, @"*** ERROR broadcastTx: %@ // %@", lnserror.userInfo[NSLocalizedDescriptionKey], lnserror.userInfo[NSLocalizedFailureReasonErrorKey]);
    }

    return lnserror;
}

- (ABCTransaction *)saveTx:(ABCError **)nserror;
{
    tABC_Error error;
    char *szTxId = NULL;
    ABCError *lnserror = nil;
    ABCTransaction *transaction = nil;
    
    ABC_SpendSaveTx(self.spend.pSpend, (char *)[self.base16 UTF8String], &szTxId, &error);
    lnserror = [ABCError makeNSError:error];
    if (!lnserror)
    {
        transaction = [self.spend.wallet getTransaction:[NSString stringWithUTF8String:szTxId]];
    }
    else
    {
        ABCLog(1, @"*** ERROR saveTx: %@ // %@", lnserror.userInfo[NSLocalizedDescriptionKey], lnserror.userInfo[NSLocalizedFailureReasonErrorKey]);
    }
    if (nserror) *nserror = lnserror;
    return transaction;
}

@end


@implementation ABCSpend

- (id)init:(id)wallet;
{
    self = [super init];
    if (self) {
        self.pSpend = NULL;
        self.metaData = [ABCMetaData alloc];
        self.metaData.bizId = 0;
        self.wallet = wallet;
    }
    return self;
}

- (void)dealloc
{
    if (self.pSpend != NULL) {
        ABC_SpendFree(self.pSpend);
        self.pSpend = NULL;
    }
}

- (ABCError *)addPaymentRequest:(ABCPaymentRequest *)paymentRequest;
{
    tABC_Error error;
    
    if (!paymentRequest || !paymentRequest.pPaymentRequest)
    {
        error.code = ABC_CC_NULLPtr;
        return [ABCError makeNSError:error];
    }
    ABC_SpendAddPaymentRequest(self.pSpend, paymentRequest.pPaymentRequest, &error);
    return [ABCError makeNSError:error];
}

- (ABCError *)addTransfer:(ABCWallet *)destWallet amount:(uint64_t)amountSatoshi destMeta:(ABCMetaData *)destMeta;
{
    tABC_Error error;
    tABC_TxDetails txDetails;
    
    if (!destWallet || !destWallet.uuid)
    {
        error.code = ABC_CC_NULLPtr;
        return [ABCError makeNSError:error];
    }
    
    if (destMeta)
    {
        txDetails.szName            = (char *) [destMeta.payeeName UTF8String];
        txDetails.szCategory        = (char *) [destMeta.category UTF8String];
        txDetails.szNotes           = (char *) [destMeta.notes UTF8String];
        txDetails.amountCurrency    = destMeta.amountFiat;
        txDetails.bizId             = destMeta.bizId;
    }
    ABC_SpendAddTransfer(self.pSpend, [destWallet.uuid UTF8String], amountSatoshi, &txDetails, &error);
    return  [ABCError makeNSError:error];
}

- (ABCError *)addAddress:(NSString *)address amount:(uint64_t)amount;
{
    tABC_Error error;
    if (!address)
    {
        error.code = ABC_CC_NULLPtr;
        return [ABCError makeNSError:error];
    }

    ABC_SpendAddAddress(self.pSpend, [address UTF8String], amount, &error);
    return [ABCError makeNSError:error];
}

- (ABCMetaData *)metaData
{
    return _metaData;
}

- (void)setMetaData:(ABCMetaData *)metaData;
{
    if (metaData)
    {
        _metaData = metaData;
        tABC_Error error;
        tABC_TxDetails details;
        
        details.amountCurrency  = metaData.amountFiat;
        details.szName          = (char *)[metaData.payeeName UTF8String];
        details.szCategory      = (char *)[metaData.category UTF8String];
        details.szNotes         = (char *)[metaData.notes UTF8String];
        details.bizId           = metaData.bizId;
        ABC_SpendSetMetadata(self.pSpend, &details, &error);
    }
}

- (uint64_t)getFees;
{
    return [self getFees:nil];
}

- (uint64_t)getFees:(ABCError **)nserror;
{
    tABC_Error error;
    ABCError *lnserror = nil;
    
    uint64_t fee = 0;
    ABC_SpendGetFee(self.pSpend, &fee, &error);
    lnserror = [ABCError makeNSError:error];
    if (nserror) *nserror = lnserror;
    
    return fee;
}

- (void)getFees:(void(^)(uint64_t fees))completionHandler
          error:(void(^)(ABCError *error)) errorHandler;
{
    [self.wallet.account postToMiscQueue:^{
        uint64_t fees;
        ABCError *error;
        
        fees = [self getFees:&error];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (!error) {
                if (completionHandler) completionHandler(fees);
            } else {
                if (errorHandler) errorHandler(error);
            }
        });
    }];
    
}

- (uint64_t)getMaxSpendable:(ABCError **)nserror;
{
    tABC_Error error;
    ABCError *lnserror = nil;
    uint64_t max = 0;
    
    ABC_SpendGetMax(self.pSpend, &max, &error);
    lnserror = [ABCError makeNSError:error];
    
    if (nserror) *nserror = lnserror;
    
    return max;
}
- (uint64_t)getMaxSpendable;
{
    return [self getMaxSpendable:nil];
}

- (void)getMaxSpendable:(void(^)(uint64_t amountSpendable))completionHandler
                  error:(void(^)(ABCError *error)) errorHandler;
{
    [self.wallet.account postToMiscQueue:^{
        uint64_t max;
        ABCError *error;
        
        max = [self getMaxSpendable:&error];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (!error) {
                if (completionHandler) completionHandler(max);
            } else {
                if (errorHandler) errorHandler(error);
            }
        });
    }];
    
}

- (void) setFeeLevel:(ABCSpendFeeLevel)feeLevel;
{
    tABC_Error error;

    _feeLevel = feeLevel;
    ABC_SpendSetFee(self.pSpend, (tABC_SpendFeeLevel) feeLevel, self.customFeeSatoshis, &error);
}

- (ABCSpendFeeLevel) feeLevel;
{
    return _feeLevel;
}

- (ABCUnsentTx *)signTx:(ABCError **)nserror;
{
    tABC_Error error;
    ABCError *lnserror = nil;
    char *pszRawTx = NULL;
    ABCUnsentTx *unsentTx = nil;
    
    ABC_SpendSignTx(self.pSpend, &pszRawTx, &error);
    lnserror = [ABCError makeNSError:error];
    if (!lnserror)
    {
        unsentTx = [ABCUnsentTx alloc];
        unsentTx.spend = self;
        unsentTx.base16 = [NSString stringWithUTF8String:pszRawTx];
    }
    if (nserror) *nserror = lnserror;
    if (pszRawTx) free(pszRawTx);
    return unsentTx;
}

- (void)signTx:(void(^)(ABCUnsentTx *unsentTx))completionHandler
         error:(void(^)(ABCError *error)) errorHandler;
{
    [self.wallet.account postToMiscQueue:^{
        ABCError *error;

        ABCUnsentTx *unsentTx = [self signTx:&error];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (!error) {
                if (completionHandler) completionHandler(unsentTx);
            } else {
                if (errorHandler) errorHandler(error);
            }
        });
    }];
    
}



- (void)signBroadcastAndSave:(void(^)(ABCTransaction *transaction))completionHandler
                       error:(void(^)(ABCError *error)) errorHandler;
{
    [self.wallet.account postToMiscQueue:^{
        ABCTransaction *transaction;
        ABCError *error;
        
        transaction = [self signBroadcastAndSave:&error];
        
        dispatch_async(dispatch_get_main_queue(),^{
            if (!error) {
                if (completionHandler) completionHandler(transaction);
            } else {
                if (errorHandler) errorHandler(error);
            }
        });
    }];
}

- (ABCTransaction *)signBroadcastAndSave:(ABCError **)nserror;
{
    ABCError *lnserror = nil;
    ABCTransaction *transaction = nil;
    
    ABCUnsentTx *unsentTx = [self signTx:&lnserror];
    if (!lnserror && unsentTx)
    {
        lnserror = [unsentTx broadcastTx];
        if (!lnserror)
        {
            transaction = [unsentTx saveTx:&lnserror];
        }
    }
    if (nserror) *nserror = lnserror;
    return transaction;
}




@end
