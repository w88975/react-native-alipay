package com.uiwjs.alipay;

import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;

import android.util.Log;

import com.alipay.sdk.app.AuthTask;
import com.alipay.sdk.app.PayTask;
import com.alipay.sdk.app.EnvUtils;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Promise;
import com.alibaba.alibcprotocol.callback.AlibcTradeCallback;
import com.alibaba.alibcprotocol.param.AlibcShowParams;
import com.alibaba.alibcprotocol.param.AlibcTaokeParams;
import com.alibaba.alibcprotocol.param.OpenType;
import com.alibaba.baichuan.trade.common.utils.AlibcLogger;
import com.baichuan.nb_trade.AlibcTrade;
import com.baichuan.nb_trade.callback.AlibcTradeInitCallback;
import com.baichuan.nb_trade.core.AlibcTradeSDK;
import com.randy.alibcextend.auth.AuthCallback;
import com.randy.alibcextend.auth.TopAuth;
// import com.facebook.react.bridge.Callback;

import java.util.HashMap;
import java.util.Map;

public class RNAlipayModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNAlipayModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNAlipay";
    }

    // @ReactMethod
    // public void sampleMethod(String stringArgument, int numberArgument, Callback callback) {
    //     // TODO: Implement some actually useful functionality
    //     callback.invoke("Received numberArgument: " + numberArgument + " stringArgument: " + stringArgument);
    // }

    @ReactMethod
    public void authInfo(final String infoStr, final Promise promise) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                AuthTask authTask = new AuthTask(getCurrentActivity());
                Map<String, String> map = authTask.authV2(infoStr, true);
                promise.resolve(getWritableMap(map));
            }
        };
        Thread thread = new Thread(runnable);
        thread.start();
    }

    @ReactMethod
    public void setAlipaySandbox(Boolean isSandbox) {
        if (isSandbox) {
            EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX);
        } else {
            EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE);
        }
    }
    @ReactMethod
    public void alipay(final String orderInfo, final Promise promise) {
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                PayTask alipay = new PayTask(getCurrentActivity());
                Map<String, String> result = alipay.payV2(orderInfo, true);
                promise.resolve(getWritableMap(result));
            }
        };
        // 必须异步调用
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    @ReactMethod
    public void initBCSdk(Promise promise) {
        // 扩展参数（默认可不设置或传空）
        Map<String, Object> extParams = new HashMap<>(16);
        AlibcTradeSDK.asyncInit(getCurrentActivity().getApplication(), extParams, new AlibcTradeInitCallback() {
            @Override
            public void onSuccess() {
                Log.e("tb======", "success");
                promise.resolve(true);
            }

            @Override
            public void onFailure(int p0, String p1) {
                Log.e("tb======", "fail=====" + p1);
                promise.resolve(false);
            }
        });
    }

        @ReactMethod
    public void OpenTB(Callback cb) {
//        Toast.makeText(getCurrentActivity(), "111111111111", Toast.LENGTH_SHORT).show();
//        JumpToTianMaoUtils.toTaoBao(Objects.requireNonNull(getCurrentActivity()),url);
// 在后台线程中

        runOnUiThread(() ->
                TopAuth.showAuthDialog(getCurrentActivity(), null, "省钱通", "34672600", new AuthCallback() {
                            @Override
                            public void onError(String s, String s1) {
//                                Toast.makeText(getCurrentActivity(), s + "=fail=" + s1, Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onSuccess(String accessToken, String expireTime) {
                                Log.e("tb====", accessToken + "====" + expireTime);
//                                Toast.makeText(getCurrentActivity(), "授权成功", Toast.LENGTH_SHORT).show();
//                                WritableMap writableMap =   convertToWritableMap(AlibcLogin.getInstance().getUserInfo());
                                cb.invoke(accessToken);
                            }


                        }

                ));

    }

    @ReactMethod
    public void openTb(String url, String pid, String relationId) {
//        Toast.makeText(getCurrentActivity(), "jinglaile=============", Toast.LENGTH_SHORT).show();
        AlibcLogger.e("TAG=======", url + "==" + pid + "==" + relationId);
        String DEFAULT_BACK_URL = "alisdk://";

        AlibcTaokeParams taokeParams = new AlibcTaokeParams("", "", "");
        taokeParams.subPid = "";
        taokeParams.pid = pid;
        taokeParams.unionId = "";
        taokeParams.relationId = relationId;
        taokeParams.materialSourceUrl = "";
        taokeParams.extParams = new HashMap<>();

        Map<String, String> trackParams = new HashMap<>(16);
        trackParams.put("testKey", "testValue");

        AlibcShowParams showParams = new AlibcShowParams();
        showParams.setBackUrl(DEFAULT_BACK_URL);
        showParams.setOpenType(OpenType.Native);


        AlibcTrade.openByUrl(getCurrentActivity(), url, showParams, taokeParams, trackParams, new AlibcTradeCallback() {
            @Override
            public void onSuccess(int i, Object o) {
            }

            @Override
            public void onFailure(int code, String msg) {
                AlibcLogger.e("TAG=======", "open fail: code = " + code + ", msg = " + msg);
            }
        });
    }


    @ReactMethod
    public void getVersion(Promise promise) {
        PayTask payTask = new PayTask(getCurrentActivity());
        promise.resolve(payTask.getVersion());
    }

    private WritableMap getWritableMap(Map<String, String> map) {
        WritableMap writableMap = Arguments.createMap();
        for (Map.Entry<String, String> entry : map.entrySet()) {
            writableMap.putString(entry.getKey(), entry.getValue());
        }
        return writableMap;
    }
}
