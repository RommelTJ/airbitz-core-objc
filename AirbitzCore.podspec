#
#  Be sure to run `pod spec lint AirbitzCore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "AirbitzCore"
  s.version      = "1.1.1"
  s.summary      = "Bitcoin and Edge Security Library"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
AirbitzCore is an SDK providing Bitcoin transaction functionality with simple handling of HD wallets. AirbitzCore also allows
developers to secure arbitrary data which provides automatic client-side encryption, auto backup, and auto device-to-device synchronization.
                   DESC

  s.homepage     = "https://airbitz.co"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "BSD modified"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Paul Puey" => "paul@airbitz.co" }
  # Or just: s.author    = "Paul Puey"
  # s.authors            = { "Paul Puey" => "paul@airbitz.co" }
  s.social_media_url   = "http://twitter.com/Airbitz"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

# s.platform     = :ios
# s.platform     = :ios, "8.0"

  #  When using multiple platforms
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #
  #s.source = { :git => 'https://github.com/Airbitz/airbitz-core-objc.git', :tag => '0.10.3' }
  s.source = { :http => "https://developer.airbitz.co/download/airbitz-core-objc-1.1.1.tgz" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.public_header_files = "Classes/Public/*.{h,m}"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  s.resources = "Resources/api.cer", "Resources/ca-certificates.crt"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

#  s.library   = "AirbitzCore"
  s.libraries = "iconv", "c++"

  s.osx.vendored_libraries =
    "LibrariesOSX/libabc.a",
    "LibrariesOSX/libbitcoin.a",
    "LibrariesOSX/libboost_atomic.a",
    "LibrariesOSX/libboost_chrono.a",
    "LibrariesOSX/libboost_date_time.a",
    "LibrariesOSX/libboost_filesystem.a",
    "LibrariesOSX/libboost_program_options.a",
    "LibrariesOSX/libboost_regex.a",
    "LibrariesOSX/libboost_system.a",
    "LibrariesOSX/libboost_thread.a",
    "LibrariesOSX/libcrypto.a",
    "LibrariesOSX/libcsv.a",
    "LibrariesOSX/libcurl.a",
    "LibrariesOSX/libgit2.a",
    "LibrariesOSX/libjansson.a",
    "LibrariesOSX/libprotobuf-lite.a",
    "LibrariesOSX/libqrencode.a",
    "LibrariesOSX/libsecp256k1.a",
    "LibrariesOSX/libsodium.a",
    "LibrariesOSX/libssl.a",
    "LibrariesOSX/libz.a",
    "LibrariesOSX/libzmq.a"

  s.ios.vendored_libraries =
    "Libraries/libabc.a",
    "Libraries/libbitcoin.a",
    "Libraries/libboost_atomic.a",
    "Libraries/libboost_chrono.a",
    "Libraries/libboost_date_time.a",
    "Libraries/libboost_filesystem.a",
    "Libraries/libboost_program_options.a",
    "Libraries/libboost_regex.a",
    "Libraries/libboost_system.a",
    "Libraries/libboost_thread.a",
    "Libraries/libcrypto.a",
    "Libraries/libcsv.a",
    "Libraries/libcurl.a",
    "Libraries/libgit2.a",
    "Libraries/libjansson.a",
    "Libraries/libprotobuf-lite.a",
    "Libraries/libqrencode.a",
    "Libraries/libsecp256k1.a",
    "Libraries/libsodium.a",
    "Libraries/libssl.a",
    "Libraries/libz.a",
    "Libraries/libzmq.a"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
