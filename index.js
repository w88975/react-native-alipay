import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@uiw/react-native-alipay' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

console.log(':::NativeModules:::', NativeModules.RNAlipay)
const RNAlipay = NativeModules.RNAlipay ? NativeModules.RNAlipay : new Proxy(
  {},
  {
    get() {
      throw new Error(LINKING_ERROR);
    },
  }
);
// console.log('>RNAlipay1111>',  RNAlipay.setAlipayScheme)

// console.log('>>NativeModules.RNAlipay:', NativeModules.RNAlipay)

export default class Alipay {
  /**
   * 支付
   * @param orderInfo 支付详情
   * @returns result 支付宝回调结果 https://docs.open.alipay.com/204/105301
   */
  static alipay(orderInfo) {
    return NativeModules.RNAlipay.alipay(orderInfo);
  }

  /**
   * 快速登录授权
   * @param authInfoStr 验证详情
   * @returns result 支付宝回调结果 详情见 https://opendocs.alipay.com/open/218/105325
   */
  static authInfo(authInfoStr) {
    return NativeModules.RNAlipay.authInfo(authInfoStr)
  }

  /**
   *  获取当前版本号
   *  @return 当前版本字符串
   */
  static getVersion() {
    return NativeModules.RNAlipay.getVersion()
  }

  /**
   * 设置支付宝跳转Scheme，仅 iOS
   * @param scheme
   * @platform ios
   */
  static setAlipayScheme(scheme) {
    if (Platform.OS === 'ios') {
      NativeModules.RNAlipay.setAlipayScheme(scheme);
    }
  }

  /**
   * 设置支付宝沙箱环境，仅 Android
   * @param isSandBox
   * @platform android
   */
  static setAlipaySandbox(isSandBox) {
    if (Platform.OS === 'android') {
      NativeModules.RNAlipay.setAlipaySandbox(isSandBox);
    }
  }

  /**
   * 初始化阿里百川sdk
   * @param version app版本
   * @param app_name app名称
   * @platform android
   */
  static initBCSdk() {
    if (Platform.OS === 'android') {
      return NativeModules.RNAlipay.initBCSdk()
    } else if (Platform.OS === 'ios') {
      return NativeModules.RNAlipay.initBCSdk()
    }
  }

  /**
 * 阿里百川淘宝授权
 * @param callback 授权回调
 * @platform android
 */
  static OpenTB(callback) {
    if (Platform.OS === 'android') {
      NativeModules.RNAlipay.OpenTB(callback)
    } else if (Platform.OS === 'ios') {
      console.log('ios暂未支持')
    }
  }

  /**
* 阿里百川打开返利商品链接
* @param url
* @param pid
* @param relationId
* @platform android
*/
  static openTb(url, pid, relationId) {
    if (Platform.OS === 'android') {
      NativeModules.RNAlipay.openTb(url, pid, relationId)
    } else if (Platform.OS === 'ios') {
      console.log('ios暂未支持')
    }
  }
}
