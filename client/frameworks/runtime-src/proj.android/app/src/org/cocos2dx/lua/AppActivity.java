/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2016 cocos2d-x.org
Copyright (c) 2013-2016 Chukong Technologies Inc.
Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package org.cocos2dx.lua;

import android.Manifest;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PermissionInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.IBinder;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.widget.Toast;

import com.android.billingclient.api.BillingClient;
import com.android.vending.billing.IInAppBillingService;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;
import com.bqd.hyzw.R;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookAuthorizationException;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginManager;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;
import com.zing.zalo.zalosdk.oauth.FeedData;
import com.zing.zalo.zalosdk.oauth.OpenAPIService;
import com.zing.zalo.zalosdk.oauth.ZaloPluginCallback;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.cocos2dx.login3rd.FacebookLoginActivity;
import org.cocos2dx.login3rd.ZaloLoginActivity;
import org.cocos2dx.services.ClipboardService;
import org.cocos2dx.utils.Constants;
import org.cocos2dx.utils.Tools;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;

public class AppActivity extends Cocos2dxActivity{

    public static AppActivity pInstance;

    private static ArrayList<String> permissionsList = new ArrayList<String>();
    private static HashMap<String, Object> options = new HashMap<>();
    private static String _machineId;

    public static CallbackManager facebookCallbackManager;
    public static ShareDialog facebookShareDialog;

    private static IInAppBillingService mService;
    private static ServiceConnection mServiceConn;

    public static boolean isForeground = false;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.setEnableVirtualButton(false);
        super.onCreate(savedInstanceState);
        // Workaround in https://stackoverflow.com/questions/16283079/re-launch-of-activity-on-home-button-but-only-the-first-time/16447508
        if (!isTaskRoot()) {
            // Android launched another instance of the root activity into an existing task
            //  so just quietly finish and go away, dropping the user back into the activity
            //  at the top of the stack (ie: the last state of this task)
            // Don't need to finish it again since it's finished in super.onCreate .
            return;
        }

        // DO OTHER INITIALIZATION BELOW
        pInstance = this;

        initGooglePay();
        initFacebook();
        initAppsflyer();
        initJPush();
    }

    private void initGooglePay() {
        mServiceConn = new ServiceConnection() {
            @Override
            public void onServiceDisconnected(ComponentName name) {
                mService = null;
            }

            @Override
            public void onServiceConnected(ComponentName name, IBinder service) {
                mService = IInAppBillingService.Stub.asInterface(service);
            }
        };

        Intent serviceIntent = new Intent("com.android.vending.billing.InAppBillingService.BIND");
        serviceIntent.setPackage("com.android.vending");
        bindService(serviceIntent, mServiceConn, Context.BIND_AUTO_CREATE);
    }

    private void initFacebook() {
        facebookCallbackManager = CallbackManager.Factory.create();
        facebookShareDialog = new ShareDialog(this);
        facebookShareDialog.registerCallback(facebookCallbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                pInstance.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onFacebookShareSuccess", "");
                    }
                });
            }

            @Override
            public void onCancel() {
                pInstance.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onShare3rdFailed", "");
                    }
                });
            }

            @Override
            public void onError(FacebookException error) {
                if (error instanceof FacebookAuthorizationException) {
                    if (AccessToken.getCurrentAccessToken() != null) {
                        LoginManager.getInstance().logOut();
                    }
                }

                pInstance.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onShare3rdFailed", "");
                    }
                });
            }
        }, Constants.REQ_FACE_BOOK_SHARE);
    }

    private void initAppsflyer() {
        AppsFlyerConversionListener conversionDataListener =
                new AppsFlyerConversionListener() {
                    @Override
                    public void onInstallConversionDataLoaded(Map<String, String> map) {
                        JSONObject jObject = new JSONObject(map);
                        Intent intent = pInstance.getIntent();
                        intent.putExtra("InstallConversionData", jObject.toString());
                    }

                    @Override
                    public void onInstallConversionFailure(String s) {
                        Intent intent = pInstance.getIntent();
                        intent.putExtra("InstallConversionData", "{}");
                    }

                    @Override
                    public void onAppOpenAttribution(Map<String, String> map) {
                        JSONObject jObject = new JSONObject(map);
                        Intent intent = pInstance.getIntent();
                        intent.putExtra("AppOpenAttribution", jObject.toString());
                    }

                    @Override
                    public void onAttributionFailure(String s) {
                        Intent intent = pInstance.getIntent();
                        intent.putExtra("AppOpenAttribution", "{}");
                    }
                };

        final String af_dev_key = getString(R.string.appsflyer_dev_key);
        AppsFlyerLib.getInstance().init(af_dev_key, conversionDataListener, getApplicationContext());
        AppsFlyerLib.getInstance().startTracking(getApplication());
        AppsFlyerLib.getInstance().sendDeepLinkData(this);
    }

    private void initJPush() {
        JPushInterface.setDebugMode(true);
        JPushInterface.init(this);

        BasicPushNotificationBuilder builder = new BasicPushNotificationBuilder(this);
        builder.statusBarDrawable = R.mipmap.ic_launcher;
        builder.notificationFlags = Notification.FLAG_AUTO_CANCEL;  //设置为点击后自动消失
        builder.notificationDefaults = Notification.DEFAULT_SOUND;  //设置为铃声（ Notification.DEFAULT_SOUND）或者震动（ Notification.DEFAULT_VIBRATE）
        JPushInterface.setPushNotificationBuilder(1, builder);
    }

    public static void changeOrientation(int orientation){
        switch(orientation)
        {
            case 0://横屏
                pInstance.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
                break;
            case 1://竖屏
                pInstance.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                break;
        }
    }

    public static String getAppInstallExtras(final String key){
        Intent intent = pInstance.getIntent();
        String value = intent.getStringExtra(key);
        if(value == null)
            return "";
        else
            return value;
    }

    public static void copy2Clipboard(final String content) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ClipboardManager clipboard = (ClipboardManager)pInstance.getSystemService(CLIPBOARD_SERVICE);
                clipboard.setPrimaryClip(ClipData.newPlainText(null, content));
            }
        });
    }

    private void onClipboardServiceStart(final String content) {
        Intent intent = new Intent(this, ClipboardService.class);
        intent.putExtra("content", content);
        startService(intent);
    }

    private void onClipboardServiceStop() {
        Intent intent = new Intent(this, ClipboardService.class);
        stopService(intent);
    }

    public static void clipboardServiceStart(final String content) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pInstance.onClipboardServiceStart(content);
            }
        });
    }

    public static void clipboardServiceStop() {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                pInstance.onClipboardServiceStop();
            }
        });
    }

    public static void openAppWithUrl(final String packagename, final String homepage) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (Tools.isInstalledApp(pInstance, packagename)) {
                    PackageManager pm = pInstance.getPackageManager();
                    Intent intent = pm.getLaunchIntentForPackage(packagename);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    pInstance.startActivity(intent);
                } else if(!homepage.isEmpty()) {
                    Intent intent = new Intent();
                    intent.setAction("android.intent.action.VIEW");

                    Uri content_url = Uri.parse(homepage);
                    intent.setData(content_url);
                    pInstance.startActivity(intent);
                }
            }
        });
    }

    public static void AppsFlyerSetCustomerUserId(final String userid) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AppsFlyerLib.getInstance().setCustomerUserId(userid);
            }
        });
    }

    public static void AppsFlyerTrackEvent(final String eventName, final String jsonValues) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    Map<String,Object> eventValues = new HashMap<>();
                    JSONObject jObject= new JSONObject(jsonValues);
                    Iterator it = jObject.keys();
                    while(it.hasNext()){
                        String key = (String) it.next().toString();
                        Object value = jObject.get(key);
                        eventValues.put(key, value);
                    }
                    AppsFlyerLib.getInstance().trackEvent(pInstance, eventName, eventValues);
                } catch (JSONException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        });
    }

    public static void getStoreItems(final String jsonSku) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        ArrayList<String> skuList = new ArrayList<String>();
                        JSONTokener jsonParser = new JSONTokener(jsonSku);
                        try {
                            JSONArray jArray = (JSONArray) jsonParser.nextValue();
                            for (int i = 0; i < jArray.length(); i++) {
                                String sku = jArray.getString(i);
                                skuList.add(sku);
                            }

                            Bundle querySkus = new Bundle();
                            querySkus.putStringArrayList("ITEM_ID_LIST", skuList);

                            Bundle skuDetails = mService.getSkuDetails(3, pInstance.getPackageName(), "inapp", querySkus);
                            int response = skuDetails.getInt("RESPONSE_CODE");
                            if (response == BillingClient.BillingResponse.OK) {
                                String retString = "";
                                ArrayList<String> responseList = skuDetails.getStringArrayList("DETAILS_LIST");
                                for (String thisResponse : responseList) {
                                    JSONObject object = new JSONObject(thisResponse);
                                    String productId = object.getString("productId");
                                    String price = object.getString("price");
                                    String title = object.getString("title");
                                    String desc = object.getString("description");

                                    retString += String.format("{productId=\"%s\",name=\"%s\",desc=\"%s\",price=\"%s\"},", productId, title, desc, price);
                                }

                                final String result = String.format("{%s}", retString);
                                pInstance.runOnGLThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onStoreItemsSuccess", result);
                                    }
                                });
                            } else {
                                pInstance.runOnGLThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onStoreItemsFailed", "");
                                    }
                                });
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }).start();
            }
        });
    }

    public static void buyStoreItem(final String sku, final String extra) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            Bundle buyIntentBundle = mService.getBuyIntent(3, pInstance.getPackageName(), sku, "inapp", extra);
                            int response = buyIntentBundle.getInt("RESPONSE_CODE");
                            if (response == BillingClient.BillingResponse.OK) {
                                PendingIntent pendingIntent = buyIntentBundle.getParcelable("BUY_INTENT");
                                pInstance.startIntentSenderForResult(pendingIntent.getIntentSender(), Constants.REQ_STORE_BUY, new Intent(), Integer.valueOf(0), Integer.valueOf(0), Integer.valueOf(0));
                            } else if (response == BillingClient.BillingResponse.ITEM_ALREADY_OWNED) {
                                Bundle ownedItems = mService.getPurchases(3, pInstance.getPackageName(), "inapp", null);
                                response = ownedItems.getInt("RESPONSE_CODE");
                                if (response == BillingClient.BillingResponse.OK) {
                                    ArrayList<String>  purchaseDataList = ownedItems.getStringArrayList("INAPP_PURCHASE_DATA_LIST");

                                    for (int i = 0; i < purchaseDataList.size(); ++i) {
                                        String purchaseData = purchaseDataList.get(i);
                                        JSONObject jo = new JSONObject(purchaseData);
                                        String productid = jo.getString("productId");

                                        if (productid.equals(sku)) {
                                            String packagename = jo.getString("packageName");
                                            String orderid = jo.getString("orderId");
                                            String token = jo.getString("purchaseToken");
                                            String extra = jo.getString("developerPayload");

                                            final String result = String.format("{orderid=\"%s\",productid=\"%s\",packagename=\"%s\",token=\"%s\",extra=\"%s\",state=0}", orderid, productid, packagename, token, extra);

                                            pInstance.runOnGLThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onBuyStoreItemSuccess", result);
                                                }
                                            });
                                        }
                                    }
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }).start();
            }
        });
    }

    public static void consumePurchase(final String orderid, final String token) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            final String result = String.format("{orderid=\"%s\"}", orderid);
                            int response = mService.consumePurchase(3, pInstance.getPackageName(), token);
                            if (response == BillingClient.BillingResponse.OK) {
                                pInstance.runOnGLThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onConsumeStoreItemSuccess", result);
                                    }
                                });
                            } else {
                                pInstance.runOnGLThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onConsumeStoreItemFailed", result);
                                    }
                                });
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }).start();
            }
        });
    }

    public static void openLoginZalo() {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Intent intent = new Intent(pInstance, ZaloLoginActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                pInstance.startActivityForResult(intent, Constants.REQ_ZALO_LOGIN);
            }
        });
    }

    public static void openZaloShare(final String message, final String link, final String linkTitle, final String linkSource, final String linkDesc, final String linkThumb) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                FeedData feed = new FeedData();
                feed.setMsg(message);
                feed.setLink(link);
                feed.setLinkTitle(linkTitle);
                feed.setLinkSource(linkSource);
                feed.setLinkDesc(linkDesc);
                feed.setLinkThumb(new String[] {linkThumb});
                OpenAPIService.getInstance().share(pInstance, feed, new ZaloPluginCallback() {
                    @Override
                    public void onResult(boolean isSuccess, int errorCode, String msg, String data) {
                        if(isSuccess) {
                            pInstance.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onZaloShareSuccess", "");
                                }
                            });
                        } else {
                            pInstance.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onShare3rdFailed", "");
                                }
                            });
                        }
                    }
                }, true);
            }
        });
    }

    public static void openLoginFacebook() {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Intent intent = new Intent(pInstance, FacebookLoginActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                pInstance.startActivityForResult(intent, Constants.REQ_FACE_BOOK_LOGIN);
            }
        });
    }

    public static void openFacebookShare(final String message, final String link, final String linkTitle, final String linkSource, final String linkDesc, final String linkThumb) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ShareLinkContent content = new ShareLinkContent.Builder().setContentUrl(Uri.parse(link)).build();
                if (facebookShareDialog.canShow(content, ShareDialog.Mode.WEB)) {
                    facebookShareDialog.show(content, ShareDialog.Mode.WEB);
                }
            }
        });
    }

    public static void openImageUpload(final String uploadUrl, final int limitSize, final int limitWidth, final int limitHeight) {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                options.put("uploadUrl", uploadUrl);
                options.put("limitSize", limitSize);
                options.put("limitWidth", limitWidth);
                options.put("limitHeight", limitHeight);

                Intent intent = new Intent(Intent.ACTION_PICK, null);
                intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
                pInstance.startActivityForResult(intent, Constants.REQ_PICK_IMAGE);
            }
        });
    }

    /** 设置极光推送所需要的平台编号和用户id **/
    public static void setJPushOptions(final String alias, final String tag)
    {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                JPushInterface.setAlias(pInstance,0,alias); //别名 别名是唯一的 用来推送单个用户 userId和平台编号
                Set<String> tags = new HashSet<String>();
                tags.add(tag);
                JPushInterface.setTags(pInstance,0,tags); //标签  用来给整个平台推送的
            }
        });
    }

    public static String getMachineId() {
        return _machineId;
    }

    private void check4MachineId() {
        try {
            final File fileDst = Environment.getExternalStorageDirectory();
            final String pathDst = fileDst.getPath();
            final File fileMachineId = new File(pathDst, ".bqd");

            if(fileMachineId.exists())
            {
                FileInputStream inputStream = new FileInputStream(fileMachineId);
                StringBuilder sb = new StringBuilder("");
                byte[] buffer = new byte[1024];
                int len = inputStream.read(buffer);

                while(len > 0){
                    sb.append(new String(buffer,0,len));
                    len = inputStream.read(buffer);
                }
                inputStream.close();

                _machineId = sb.toString();
            }
            else
            {
                _machineId = UUID.randomUUID().toString();
                FileOutputStream outputStream = new FileOutputStream(fileMachineId);
                outputStream.write(_machineId.getBytes());
                outputStream.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void checkPermissions() {
        pInstance.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (android.os.Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
                    try {
                        final String pkname = pInstance.getPackageName();
                        PackageInfo packageInfo = pInstance.getPackageManager().getPackageInfo(pkname, PackageManager.GET_PERMISSIONS);
                        for (int i = 0; i < packageInfo.requestedPermissions.length; i++) {
                            String permission = packageInfo.requestedPermissions[i];

                            if (permission.equals(Manifest.permission.MOUNT_UNMOUNT_FILESYSTEMS)
                                    || permission.equals(Manifest.permission.WRITE_SETTINGS)
                                    || permission.equals(Manifest.permission.SYSTEM_ALERT_WINDOW)
                                    || permission.equals(Manifest.permission.READ_LOGS))
                                continue;

                            try {
                                PermissionInfo permissionInfo = pInstance.getPackageManager().getPermissionInfo(permission, 0);
                                int result = ContextCompat.checkSelfPermission(pInstance, permission);
                                if (result == PackageManager.PERMISSION_DENIED) {
                                    permissionsList.add(permission);
                                }
                            } catch (PackageManager.NameNotFoundException e) {
                                e.printStackTrace();
                            }
                        }

                        pInstance.start4Authorization();
                    } catch (PackageManager.NameNotFoundException e) {
                        e.printStackTrace();
                    }
                }
                else {
                    pInstance.finishAuthorization();
                }
            }
        });
    }

    private void filtratePermissions() {
        try {
            PackageInfo packageInfo = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_PERMISSIONS);
            for (int i = permissionsList.size() - 1; i >= 0; i--) {
                String permission = permissionsList.get(i);
                int result = ContextCompat.checkSelfPermission(this, permission);
                if (result == PackageManager.PERMISSION_GRANTED) {
                    permissionsList.remove(i);
                }
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
    }

    protected void start4Authorization() {
        check4Authorization();
    }

    protected void check4Authorization() {
        if(permissionsList.size() > 0) {
            String[] array = (String[])permissionsList.toArray(new String[0]);
            ActivityCompat.requestPermissions (this, array, Constants.REQ_PERMISSION_GRANT);
        } else {
            finishAuthorization();
        }
    }

    private void finishAuthorization() {
        check4MachineId();

        runOnGLThread(new Runnable() {
            @Override
            public void run() {
                Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("applicationPermissionsGrant", "");
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        if(permissions == null || grantResults == null)
            finishAuthorization();
        else
        {
            switch (requestCode) {
                case Constants.REQ_PERMISSION_GRANT: {
                    boolean openSetting = false;
                    for (int i = permissions.length - 1; i >= 0; i-- ) {
                        int result = grantResults[i];
                        if (result == PackageManager.PERMISSION_GRANTED) {
                            permissionsList.remove(i);
                        } else {
                            boolean shouldShow = ActivityCompat.shouldShowRequestPermissionRationale(this, permissions[i]);
                            if(!shouldShow) openSetting = true;
                        }
                    }

                    if (openSetting) {
                        openPermissionSetting();
                    } else {
                        checkPermissions();
                    }
                }
            }
        }
    }

    protected void openPermissionSetting() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", getPackageName(),null);
        intent.setData(uri);
        startActivityForResult(intent, Constants.REQ_PERMISSION_SETTING);
    }

    @Override
    protected void onResume() {
        isForeground = true;
        onClipboardServiceStop();
        super.onResume();
    }

    @Override
    protected void onPause() {
        isForeground = false;
        super.onPause();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mService != null) {
            unbindService(mServiceConn);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case Constants.REQ_PERMISSION_SETTING:
                filtratePermissions();
                check4Authorization();
                break;
            case Constants.REQ_ZALO_LOGIN:
                final int codeZalo = data.getIntExtra("code", 1);
                if (codeZalo == 0) {
                    final String dataZalo = data.getStringExtra("result");
                    pInstance.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onLoginZaloSuccess", dataZalo);
                        }
                    });
                }
                else {
                    final String desc = data.getStringExtra("result");
                    Toast.makeText(pInstance, desc, Toast.LENGTH_LONG).show();

                    pInstance.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onLogin3rdFailed", desc);
                        }
                    });
                }
                break;
            case Constants.REQ_FACE_BOOK_LOGIN:
                final int codeFacebook = data.getIntExtra("code", 1);
                if (codeFacebook == 0) {
                    final String dataFacebook = data.getStringExtra("result");
                    pInstance.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onLoginFaceBookSuccess", dataFacebook);
                        }
                    });
                }
                else {
                    final String desc = data.getStringExtra("result");
                    Toast.makeText(pInstance, desc, Toast.LENGTH_LONG).show();

                    pInstance.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onLogin3rdFailed", desc);
                        }
                    });
                }
                break;
            case Constants.REQ_FACE_BOOK_SHARE:
                facebookCallbackManager.onActivityResult(requestCode, resultCode, data);
                break;
            case Constants.REQ_STORE_BUY:
                int responseCode = data.getIntExtra("RESPONSE_CODE", 0);
                String purchaseData = data.getStringExtra("INAPP_PURCHASE_DATA");
                String dataSignature = data.getStringExtra("INAPP_DATA_SIGNATURE");

                if (resultCode == RESULT_OK) {
                    try {
                        JSONObject jo = new JSONObject(purchaseData);
                        String productid = jo.getString("productId");
                        String packagename = jo.getString("packageName");
                        String orderid = jo.getString("orderId");
                        String token = jo.getString("purchaseToken");
                        String extra = jo.getString("developerPayload");

                        final String result = String.format("{orderid=\"%s\",productid=\"%s\",packagename=\"%s\",token=\"%s\",extra=\"%s\",state=0}", orderid, productid, packagename, token, extra);

                        pInstance.runOnGLThread(new Runnable() {
                            @Override
                            public void run() {
                                Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onBuyStoreItemSuccess", result);
                            }
                        });
                    }
                    catch (JSONException e) {
                        pInstance.runOnGLThread(new Runnable() {
                            @Override
                            public void run() {
                                Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onBuyStoreItemFailed", "");
                            }
                        });
                        e.printStackTrace();
                    }
                } else {
                    pInstance.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onBuyStoreItemFailed", "");
                        }
                    });
                }
                break;
            case Constants.REQ_PICK_IMAGE:
                if (data != null) {
                    Uri uri = data.getData();
                    final String path = Tools.getImagePath(pInstance, uri, null);
                    final String extension = Tools.getExtensionName(path);
                    if (extension.equals("jpg") || extension.equals("png")) {
                        final String uploadUrl = (String)options.get("uploadUrl");
                        final int limitSize = (int)options.get("limitSize");
                        final int limitWidth = (int)options.get("limitWidth");
                        final int limitHeight = (int)options.get("limitHeight");
                        try {
                            File imageFile = new File(path);
                            long imageSize = imageFile.length();
                            if (imageSize > limitSize) {
                                final double mbytes = limitSize / (1024 * 1024);
                                final String desc = String.format("Tải lên tập tin không lớn hơn %.1fMB", mbytes);
                                Toast.makeText(pInstance, desc, Toast.LENGTH_LONG).show();

                                pInstance.runOnGLThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onUploadImageFailed", "");
                                    }
                                });
                            } else {
                                new Thread(new Runnable() {
                                    @Override
                                    public void run() {
                                        try {
                                            final String base64bytes = Tools.Bitmap2Base64(path, limitWidth, limitHeight);
                                            final String params = String.format("UpFilePath=data:image/%s;base64,%s", extension, Tools.makeURLEncoded(base64bytes));
                                            final String ret = Tools.HTTPPost(uploadUrl, params);
                                            pInstance.runOnGLThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onUploadImageSuccess", ret);
                                                }
                                            });
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                            pInstance.runOnGLThread(new Runnable() {
                                                @Override
                                                public void run() {
                                                    Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onUploadImageFailed", "");
                                                }
                                            });
                                        }
                                    }
                                }).start();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                } else {
                    pInstance.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("onUploadImageFailed", "");
                        }
                    });
                }
                break;
            default:
                break;
        }

        super.onActivityResult(requestCode, resultCode, data);
    }
}
