package org.cocos2dx.services;

import android.app.Service;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;

import java.util.Timer;
import java.util.TimerTask;

public class ClipboardService extends Service {
    boolean started;
    String content;

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        content = intent.getStringExtra("content");

        if (!started) {
            started = true;
            timer.schedule(timerTask,1000,1000);
        }
        return super.onStartCommand(intent, flags, startId);
    }

    Handler mHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == 1){
                ClipboardManager clipboard = (ClipboardManager)getSystemService(CLIPBOARD_SERVICE);
                ClipData cd = clipboard.getPrimaryClip();
                if(cd == null) {
                    clipboard.setPrimaryClip(ClipData.newPlainText(null, content));
                } else {
                    ClipData.Item item = cd.getItemAt(0);
                    if (item == null) {
                        clipboard.setPrimaryClip(ClipData.newPlainText(null, content));
                    } else if(item.getText().equals("")) {
                        clipboard.setPrimaryClip(ClipData.newPlainText(null, content));
                    }
                }
            }
            super.handleMessage(msg);
        }
    };

    Timer timer = new Timer();
    TimerTask timerTask = new TimerTask() {
        @Override
        public void run() {
            Message message = new Message();
            message.what = 1;
            mHandler.sendMessage(message);
        }
    };

    @Override
    public void onDestroy() {
        super.onDestroy();
        timer.cancel();
    }
}
