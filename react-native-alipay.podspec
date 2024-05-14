require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-alipay"
  # s.name         = "RNAlipay"
  # s.name         = "React-Alipay"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                      Alipay SDK for React Native
                   DESC
  s.homepage     = package['repository']['url']
  # brief license entry:
  s.license      = package["license"]
  s.author       = { package["author"]["name"] => package["author"]["email"] }
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/uiwjs/react-native-alipay.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  # s.source_files = "**/*.{h,m}"
  s.requires_arc = true

  s.frameworks = "UIKit",
  s.frameworks = "Foundation",
  s.frameworks = "CFNetwork",
  s.frameworks = "SystemConfiguration",
  s.frameworks = "QuartzCore",
  s.frameworks = "CoreGraphics",
  s.frameworks = "CoreMotion",
  s.frameworks = "CoreTelephony",
  s.frameworks = "CoreText",
  s.frameworks = "WebKit"

  # s.dependency "React"
  s.dependency "React-Core"
  s.resource = 'ios/bundle'
  s.resource = 'ios/AlipaySDK.bundle'
  # s.vendored_libraries = "libAlipaySDK.a"
  # s.source_files  = "AlipaySDKiOS/AlipaySDK.framework/**/*"
  
  # 阿里百川sdk
  s.vendored_frameworks = [
  'ios/framework/AlibcLinkPartnerSDK.framework',
  'ios/framework/AlibcTradeSDK/AlibcTradeSDK.framework',
  'ios/framework/mtopSDK/mtopcoreopen.framework',
  'ios/framework/mtopSDK/mtopext.framework',
  'ios/framework/mtopSDK/MtopSDK.framework',
  'ios/framework/AlibcTradeSDK/AlibcTradeBiz.framework',
  'ios/framework/securityGuard/SGMain.framework',
  'ios/framework/securityGuard/SGMiddleTier.framework',
  'ios/framework/securityGuard/SGSecurityBody.framework',
  'ios/framework/securityGuard/SGIndieKit.framework',
  'ios/framework/securityGuard/SecurityGuardSDK.framework',
  'ios/framework/securityGuard/SGNoCaptcha.framework',
  'ios/framework/UTMini.framework',
  'ios/framework/WindVane/WindVane.framework',
  'ios/framework/WindVane/WindVaneBasic.framework',
  'ios/framework/WindVane/WindVaneCore.framework',
  'ios/framework/AliAuthSDK/AlibabaAuthExt.framework',
  'ios/framework/AliAuthSDK/AlibabaAuthSDK.framework',
  'ios/framework/AliAuthSDK/AlibabaAuthEntrance.framework',
  'ios/AlipaySDK.framework'
]
  s.library = "c++", "z"
  # ...
  # s.dependency "..."

end

