package org.cocos2dx.utils;

import android.content.Context;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Base64;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.security.MessageDigest;

public class Tools {
    public static String md5(String strMd5) {
        try {
            String password = strMd5;
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte byteData[] = md.digest();

            //convert the byte to hex format method 1
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
            }

            //convert the byte to hex format method 2
            StringBuffer hexString = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
                String hex = Integer.toHexString(0xff & byteData[i]);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception ex) {
            return ex.toString();
        }
    }

    public static boolean isInstalledApp(Context context, String uri)
    {
        try
        {
            PackageManager pm = context.getPackageManager();
            pm.getPackageInfo(uri, PackageManager.GET_ACTIVITIES);
            return true;
        }
        catch(PackageManager.NameNotFoundException e)
        {
            e.printStackTrace();
        }

        return false;
    }

    public synchronized static boolean checkInternetConnection(Context context) {
        ConnectivityManager conn = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo info = conn.getActiveNetworkInfo();
        if (info == null)
            return false;
        if (!info.isConnected())
            return false;
        if (!info.isAvailable())
            return false;
        return true;
    }

    public static String getImagePath(Context ctx, Uri uri, String selection) {
        String path = null;
        Cursor cursor = ctx.getContentResolver().query(uri, null, selection, null, null);
        if (cursor != null) {
            if (cursor.moveToFirst()) {
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA));
            }
            cursor.close();
        }
        return path;
    }

    public static Bitmap createBitmapThumbnail(Bitmap bitmap, int limitW, int limitH) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        if (limitW < width || limitH < height) {
            double maxLine = Math.max(width, height) * 1.0;
            double maxW = limitW * 1.0;
            float scale = (float)(maxW / maxLine);
            Matrix matrix = new Matrix();
            matrix.postScale(scale, scale);
            Bitmap newBitMap = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, true);
            bitmap.recycle();
            return newBitMap;
        } else {
            return bitmap;
        }
    }

    public static byte[] Bitmap2Bytes(String pathFile, int limitW, int limitH) {
        Bitmap bitmap = BitmapFactory.decodeFile(pathFile);
        bitmap = createBitmapThumbnail(bitmap, limitW, limitH);
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 80, output);

        byte[] result = output.toByteArray();
        try {
            output.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        bitmap.recycle();

        return result;
    }

    public static String Bitmap2Base64(String pathFile, int limitW, int limitH) {
        byte[] bytes = Bitmap2Bytes(pathFile, limitW, limitH);
        return Base64.encodeToString(bytes, Base64.NO_WRAP);
    }

    public static String getExtensionName(String filename) {
        if ((filename != null) && (filename.length() > 0)) {
            int dot = filename.lastIndexOf('.');
            if ((dot >-1) && (dot < (filename.length() - 1))) {
                return filename.substring(dot + 1);
            }
        }
        return filename;
    }

    public static String makeURLEncoded(final String params) {
        try {
            return URLEncoder.encode(params, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String HTTPPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        StringBuffer result = new StringBuffer();
        try {
            URL realUrl = new URL(url);
            URLConnection conn = realUrl.openConnection();
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setRequestProperty("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            out = new PrintWriter(conn.getOutputStream());
            out.print(param);
            out.flush();
            in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            String line;
            while ((line = in.readLine()) != null) {
                result.append(line);
            }
            System.out.println("\nresult=[" + result + "]\n");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.close();
                }
                if (in != null) {
                    in.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
        return result.toString();
    }
}
