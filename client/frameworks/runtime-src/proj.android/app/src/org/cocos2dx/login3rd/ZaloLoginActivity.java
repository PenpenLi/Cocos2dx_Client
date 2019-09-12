package org.cocos2dx.login3rd;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;

import com.bqd.hyzw.R;
import com.zing.zalo.zalosdk.core.helper.Utils;
import com.zing.zalo.zalosdk.oauth.LoginVia;
import com.zing.zalo.zalosdk.oauth.OAuthCompleteListener;
import com.zing.zalo.zalosdk.oauth.OauthResponse;
import com.zing.zalo.zalosdk.oauth.ValidateOAuthCodeCallback;
import com.zing.zalo.zalosdk.oauth.ZaloOpenAPICallback;
import com.zing.zalo.zalosdk.oauth.ZaloSDK;

import org.json.JSONObject;

public class ZaloLoginActivity extends Activity {
    private ZaloLoginActivity pInstance;
    private LoginListener listener;
    private Button btnBack;

    //Login callback
    private class LoginListener extends OAuthCompleteListener {
        private Activity ctx;
        public LoginListener(Activity ctx) {
            this.ctx = ctx;
        }

        @Override
        public void onSkipProtectAcc(Dialog dialog) {
            dialog.dismiss();
        }

        @Override
        public void onProtectAccComplete(int errorCode, String message, Dialog dialog) {
            if (errorCode == 0) {
                ZaloSDK.Instance.isAuthenticate(new ValidateOAuthCodeCallback() {

                    @Override
                    public void onValidateComplete(boolean validated, int error_Code, long userId, String oauthCode) {

                    }
                });
                dialog.dismiss();
            }
            com.zing.zalo.zalosdk.payment.direct.Utils.showAlertDialog(ctx, message, null);
        }

        @Override
        public void onAuthenError(int errorCode, String message) {
            if (ctx != null && !TextUtils.isEmpty(message))
                com.zing.zalo.zalosdk.payment.direct.Utils.showAlertDialog(ctx, message, null);
            super.onAuthenError(errorCode, message);

            Intent intent = new Intent();
            intent.putExtra("code", 1);
            intent.putExtra("result", message);
            pInstance.setResult(RESULT_OK, intent);
            pInstance.finish();
        }

        @Override
        public void onGetOAuthComplete(OauthResponse response) {
            super.onGetOAuthComplete(response);

            btnBack.setVisibility(View.VISIBLE);

            String [] fields = {"id", "birthday", "gender", "picture", "name"};

            ZaloSDK.Instance.getProfile(pInstance, new ZaloOpenAPICallback() {
                @Override
                public void onResult(JSONObject arg0) {
                    try{
                        if (arg0.has("name")){
                            String userid = arg0.getString("id");
                            String name = arg0.getString("name");
                            String avatar = arg0.getJSONObject("picture").getJSONObject("data").getString("url");
                            String retString = String.format("{userid=\"%s\",name=\"%s\",icon=\"%s\"}", userid, name, avatar);
                            Intent intent = new Intent();
                            intent.putExtra("code", 0);
                            intent.putExtra("result", retString);
                            pInstance.setResult(RESULT_OK, intent);
                            pInstance.finish();
                        }
                        else{
                            Intent intent = new Intent();
                            intent.putExtra("code", 1);
                            intent.putExtra("result", "Login failed!");
                            pInstance.setResult(RESULT_OK, intent);
                            pInstance.finish();
                        }
                    }
                    catch(Exception ex){
                        Intent intent = new Intent();
                        intent.putExtra("code", 1);
                        intent.putExtra("result", ex.toString());
                        pInstance.setResult(RESULT_OK, intent);
                        pInstance.finish();
                    }
                }
            }, fields);
        }
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.zalo_login_layout);

        pInstance = this;
        listener = new LoginListener(this);

        btnBack = (Button)findViewById(R.id.btn_back_zalo_login);
        btnBack.setVisibility(View.INVISIBLE);
        btnBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.putExtra("code", 1);
                intent.putExtra("result", "User Cancel!");
                pInstance.setResult(RESULT_OK, intent);
                pInstance.finish();
            }
        });

        startLogin();
    }

    private void startLogin() {
        new Handler().postDelayed(new Runnable(){
            public void run() {
                ZaloSDK.Instance.unauthenticate();
                ZaloSDK.Instance.authenticate(pInstance, LoginVia.APP_OR_WEB, listener);
            }
        }, 1000);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Utils.onPauseResume("onResume", this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        Utils.onPauseResume("onPause", this);
    }

    @Override
    //This method is required by ZaloSDK
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        ZaloSDK.Instance.onActivityResult(this, requestCode, resultCode, data);
    }
}
