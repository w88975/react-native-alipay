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

  # 阿里百川电商套件依赖
  s.dependency "Masonry"
  s.dependency "FMDB"
  s.dependency "Reachability"
  s.dependency "SocketRocket"
  s.dependency "SSZipArchive"
  s.dependency "SDWebImage"

  s.resource = ['ios/bundle/*', 'ios/resource/*', 'ios/AlipaySDK.bundle']
  # s.resource = 'ios/resource'
  # s.resource = 'ios/AlipaySDK.bundle'
  # s.vendored_libraries = "libAlipaySDK.a"
  # s.source_files  = "AlipaySDKiOS/AlipaySDK.framework/**/*"
  
  # 阿里百川sdk
  require 'find'
  frameworks_root = 'ios/framework/'
  frameworks = []

  Find.find(frameworks_root) do |path|
    frameworks.push(path) if path.end_with?('.framework')
  end

  frameworks.push('ios/AlipaySDK.framework')

  s.vendored_frameworks = frameworks
  
  # s.vendored_frameworks = [
  #   'ios/AliAuthSDK/AlibabaAuthEntrance.framework',
  #   'ios/AliAuthSDK/AlibabaAuthExt.framework',
  #   'ios/AliAuthSDK/AlibabaAuthSDK.framework',
  #   'ios/AlibcTradeUltimateSDK/AlibcTradeBaseContainer.framework',
  #   'ios/AlibcTradeUltimateSDK/AlibcTradeCommonSDK.framework',
  #   'ios/AlibcTradeUltimateSDK/AlibcTradeContainer.framework',
  #   'ios/AlibcTradeUltimateSDK/AlibcTradeUltimateBizSDK.framework',
  #   'ios/AlibcTradeUltimateSDK/AlibcTradeUltimateSDK.framework',
  #   'ios/AlibcTradeUltimateSDK/AlibcTradeWebViewContainer.framework',
  #   'ios/AlibcTradeUltimateSDK/AlibcTrademiniAppContainer.framework',
  #   'ios/AlibcTradeUltimateSDK/MunionBcAdSDK.framework',
  #   'ios/Ariver/AriverApi.framework',
  #   'ios/Ariver/AriverApp.framework',
  #   'ios/Ariver/AriverAuth.framework',
  #   'ios/Ariver/AriverConfig.framework',
  #   'ios/Ariver/AriverDevice.framework',
  #   'ios/Ariver/AriverDeviceCore.framework',
  #   'ios/Ariver/AriverFileManager.framework',
  #   'ios/Ariver/AriverKernel.framework',
  #   'ios/Ariver/AriverLogger.framework',
  #   'ios/Ariver/AriverResource.framework',
  #   'ios/Ariver/AriverRuntime.framework',
  #   'ios/Ariver/AriverSecurity.framework',
  #   'ios/Ariver/AriverWebSocket.framework',
  #   'ios/BCUserTrack/UT.framework',
  #   'ios/BCUserTrack/UT_AppMonitor.framework',
  #   'ios/BCUserTrack/UT_Common.framework',
  #   'ios/BCUserTrack/UT_Core.framework',
  #   'ios/DWInteractiveSDK/AliHADeviceEvaluation.framework',
  #   'ios/DWInteractiveSDK/AliReachability.framework',
  #   'ios/MunionBcAdSDK/MunionBcAdSDK.framework',
  #   'ios/Triver/TriverAPI.framework',
  #   'ios/Triver/TriverAppContainer.framework',
  #   'ios/Triver/TriverCapability.framework',
  #   'ios/Triver/TriverDebugTool.framework',
  #   'ios/Triver/TriverLocalDebug.framework',
  #   'ios/Triver/TriverRuntime.framework',
  #   'ios/Triver/TriverVideo.framework',
  #   'ios/UTDID/UTDID.framework',
  #   'ios/WindMix/AliRemoteDebugInterface.framework',
  #   'ios/WindMix/RiverLogger.framework',
  #   'ios/WindMix/WindMix.framework',
  #   'ios/WindVane/WindVane.framework',
  #   'ios/WindVane/WindVaneBasic.framework',
  #   'ios/WindVane/WindVaneCore.framework',
  #   'ios/Windmill/WindmillTRiverKit.framework',
  #   'ios/Windmill/WindmillWeaver.framework',
  #   'ios/applink/AlibcLinkPartnerSDK.framework',
  #   'ios/miniAppMediaSDK/AliWindmillImage.framework',
  #   'ios/mtopSDK/MtopSDK.framework',
  #   'ios/mtopSDK/mtopcoreopen.framework',
  #   'ios/mtopSDK/mtopext.framework',
  #   'ios/securityGuard/SGIndieKit.framework',
  #   'ios/securityGuard/SGMain.framework',
  #   'ios/securityGuard/SGMiddleTier.framework',
  #   'ios/securityGuard/SGNoCaptcha.framework',
  #   'ios/securityGuard/SGSecurityBody.framework',
  #   'ios/securityGuard/SecurityGuardSDK.framework'
  # ]
  # 添加系统库依赖
  s.library = "c++", "z", "icucore", "resolv"
  # ...
  # s.dependency "..."

end

