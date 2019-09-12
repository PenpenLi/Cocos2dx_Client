package org.cocos2dx.login3rd;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.Profile;
import com.facebook.ProfileTracker;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.bqd.hyzw.R;

import java.util.Arrays;

public class FacebookLoginActivity extends Activity {
    private FacebookLoginActivity pInstance;
    private CallbackManager callbackManager;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.facebook_login_layout);

        pInstance = this;
        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this);

        callbackManager = CallbackManager.Factory.create();

        LoginManager.getInstance().registerCallback(callbackManager,
                new FacebookCallback<LoginResult>() {
                    private ProfileTracker mProfileTracker;
                    @Override
                    public void onSuccess(LoginResult loginResult) {
                        // App code
                        Profile profile = Profile.getCurrentProfile();
                        if (profile == null)
                        {
                            mProfileTracker = new ProfileTracker() {
                                @Override
                                protected void onCurrentProfileChanged(Profile oldProfile, Profile currentProfile) {
                                    String userid = currentProfile.getId();
                                    String Token = AccessToken.getCurrentAccessToken().getToken();
                                    String sname = currentProfile.getName();
                                    String simage = currentProfile.getProfilePictureUri(120, 120).toString();

                                    mProfileTracker.stopTracking();

                                    pInstance.successLogin(userid, sname, simage);
                                }
                            };
                        }
                        else
                        {
                            String userid = profile.getId();
                            String Token = AccessToken.getCurrentAccessToken().getToken();
                            String sname = profile.getName();
                            String simage = profile.getProfilePictureUri(120, 120).toString();

                            pInstance.successLogin(userid, sname, simage);
                        }
                    }

                    @Override
                    public void onCancel() {
                        // App code
                        Intent intent = new Intent();
                        intent.putExtra("code", 1);
                        intent.putExtra("result", "User Cancel!");
                        pInstance.setResult(RESULT_OK, intent);
                        pInstance.finish();
                    }

                    @Override
                    public void onError(FacebookException exception) {
                        // App code
                        Intent intent = new Intent();
                        intent.putExtra("code", 1);
                        intent.putExtra("result", exception.toString());
                        pInstance.setResult(RESULT_OK, intent);
                        pInstance.finish();
                    }
                });

        startLogin();
    }

    private void startLogin() {
        new Handler().postDelayed(new Runnable(){
            public void run() {
                LoginManager.getInstance().logInWithReadPermissions(pInstance, Arrays.asList("public_profile"));
            }
        }, 1000);
    }

    private void successLogin(String userid, String name, String avatar) {
        String retString = String.format("{userid=\"%s\",name=\"%s\",icon=\"%s\"}", userid, name, avatar);
        Intent intent = new Intent();
        intent.putExtra("code", 0);
        intent.putExtra("result", retString);
        pInstance.setResult(RESULT_OK, intent);
        pInstance.finish();
    }

    @Override
    //This method is required by ZaloSDK
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }
}
