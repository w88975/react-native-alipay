#import "RNAlipay.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AlibcTradeUltimateSDK/AlibcTradeUltimateSDK.h>
#import <WVURLProtocolService.h>


@interface RNAlipay ()
@property (nonatomic, copy) RCTPromiseResolveBlock payOrderResolve;

@end
@implementation RNAlipay
{
    NSString *alipayScheme;
}
RCT_EXPORT_MODULE()

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"RCTOpenURLNotification" object:nil];
        // 反注释下面代码，可以输出支付宝 SDK 调试信息，便于诊断问题
        // [AlipaySDK startLogWithBlock:^(NSString* log){
        //      NSLog(@"%@", log);
        // }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)handleOpenURL:(NSNotification *)aNotification
{
    NSString * aURLString =  [aNotification userInfo][@"url"];
    NSURL * aURL = [NSURL URLWithString:aURLString];
    if ([aURL.host isEqualToString:@"safepay"]) {
        __weak __typeof__(self) weakSelf = self;
        /**
         *  处理支付宝app支付后跳回商户app携带的支付结果Url
         *
         *  @param resultUrl        支付宝app返回的支付结果url
         *  @param completionBlock  支付结果回调 为nil时默认使用支付接口的completionBlock
         */
        [[AlipaySDK defaultService] processOrderWithPaymentResult:aURL standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result-->1 = %@", resultDic);
            if (weakSelf.payOrderResolve) {
                weakSelf.payOrderResolve(resultDic);
                weakSelf.payOrderResolve = nil;
            }
        }];
        
        /**
         *  处理支付宝app授权后跳回商户app携带的授权结果Url
         *
         *  @param aURL        支付宝app返回的授权结果url
         *  @param completionBlock  授权结果回调,用于处理跳转支付宝授权过程中商户APP被系统终止的情况
         */
        [[AlipaySDK defaultService] processAuth_V2Result:aURL standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result-->2 = %@", resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
                // 返回结果回调
                if (weakSelf.payOrderResolve) {
                    weakSelf.payOrderResolve([[NSArray alloc] initWithObjects:resultArr, nil]);
                    weakSelf.payOrderResolve = nil;
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return NO;
}


RCT_EXPORT_METHOD(setAlipayScheme:(NSString *)scheme) {
    alipayScheme = scheme;
}

RCT_EXPORT_METHOD(alipay:(NSString *)info resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    self.payOrderResolve = resolve;
    [AlipaySDK.defaultService payOrder:info fromScheme: alipayScheme callback:^(NSDictionary *resultDic) {
        resolve(resultDic);
    }];
}

RCT_EXPORT_METHOD(authInfo:(NSString *)info resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [AlipaySDK.defaultService auth_V2WithInfo:info fromScheme: alipayScheme callback:^(NSDictionary *resultDic) {
        resolve(resultDic);
    }];
}

RCT_EXPORT_METHOD(getVersion: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    resolve([[AlipaySDK defaultService] currentVersion]);
}

// TODO: 初始化SDK的时候需要传版本号和appName
RCT_EXPORT_METHOD(initBCSdk: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeUltimateSDK sharedInstance]  asyncInitWithSuccess:^{
        NSLog(@"百川初始化成功");
        resolve(@YES);
        [WVURLProtocolService setSupportWKURLProtocol:NO];
        [[AlibcTradeUltimateSDK sharedInstance] enableAutoShowDebug:YES];
        [[AlibcTradeUltimateSDK sharedInstance] setDebugLogOpen:YES];
        //2.手动打开自检工具（参数为任何当前页面VC，建议是百川套件打开前的VC）
        [[AlibcTradeUltimateSDK sharedInstance] showLocalDebugTool:rootViewController];
#ifdef DEBUG
        //必须在百川初始化成功之后调用，开启自检工具的悬浮入口
        
#endif
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"百川初始化失败");
        resolve(@NO);
    }];
}

RCT_EXPORT_METHOD(OpenTB: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [WVURLProtocolService setSupportWKURLProtocol:YES];
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

    [[AlibcTradeUltimateSDK sharedInstance].tradeService authorize4AppKey:@"34686816" appName:@"省钱通" appLogo:nil currentVC:rootViewController callBack:^(NSError *error, NSString *accessToken, NSString *expire) {
         NSLog(@"%@ - %@",accessToken,expire);
    }];
    
//    // 登录
//    if (![[[AlibcTradeUltimateSDK sharedInstance] loginService] isLogin]) {
//        [[[AlibcTradeUltimateSDK sharedInstance] loginService] setH5Only:YES];
//        [[[AlibcTradeUltimateSDK sharedInstance] loginService] auth:rootViewController success:^(AlibcUser *user) {
//            NSLog(@"登录成功");
//            resolve(@"登录成功");
//            [WVURLProtocolService setSupportWKURLProtocol:NO];
//        } failure:^(NSError *error) {
//            NSLog(@"登录失败");
//            resolve(@"");
//            [WVURLProtocolService setSupportWKURLProtocol:NO];
//        }];
//    } else {
//        AlibcUser *userInfo = [[[AlibcTradeUltimateSDK sharedInstance] loginService] getUser];
//        NSLog(@"已登录");
//        resolve(@"已登录");
//        [WVURLProtocolService setSupportWKURLProtocol:NO];
//        //  resolve([userInfo topAccessToken]);
//    }
    
}

RCT_EXPORT_METHOD(openTb: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    AlibcTradeTaokeParams *taokeParam;
    taokeParam.pid=@"mm_6252336851_3085800123_115679650219";
    taokeParam.relationId=@"3069901877";
    
    AlibcTradeShowParams *showParams;
    showParams.backUrl=@"alisdk://";
    showParams.isNeedOpenByAliApp=YES;
    
    NSDictionary * trackParams;
    
    
    [[AlibcTradeUltimateSDK sharedInstance].tradeService
             openTradeUrl:@"https://s.click.taobao.com/nzycent"
             parentController:rootViewController
             showParams:showParams
             taoKeParams:taokeParam
             trackParam:trackParams
             openUrlCallBack:^(NSError *_Nonnull error,NSDictionary *result) {

          }];
}

/*! 
 * [warn][tid:main][RCTModuleData.mm:68] Module Alipay requires main queue setup since it overrides `init` but doesn't implement `requiresMainQueueSetup`. 
 * In a future release React Native will default to initializing all native modules on a background thread unless explicitly opted-out of.
 */;
+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeAwesomeModuleSpecJSI>(params);
}
#endif

@end
