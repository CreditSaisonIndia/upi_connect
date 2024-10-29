package com.cs.upi_connect;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** UpiConnectPlugin */
public class UpiConnectPlugin implements FlutterPlugin, MethodCallHandler,ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  String dummyUpiUrl = "upi://pay?pa=test@ybl&pn=test&am=1.00&tr=1210374251828217008&tn=Getupiapps&cu=INR&mode=04";

  private Activity activity ;

  private MethodChannel methodChannel;
  private EventChannel eventChannel;

  IntentResponseService intentResponseService = new IntentResponseService();

  private  String _channelName = "com.cs.upi_connect";

  private String TAG = "UPIConnect";

  private MethodChannel.Result result;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), _channelName+"/intent");
    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(),_channelName+"/upi_intent_response");

    methodChannel.setMethodCallHandler(this);
    eventChannel.setStreamHandler(intentResponseService);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    this.result = result;
    switch (call.method){
      case "upi_intent":
        handleIntent(call, result);
        break;
      case "get_all_upi_apps":
        fetchInstalledUpiApps(result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void fetchInstalledUpiApps(@NonNull Result result) {
    String upiUriString = dummyUpiUrl;
    HashMap<String, Object> appDataMap = new HashMap<>();
    List<Map<String, Object>> appPackagesList = new ArrayList<>();

    Intent upiIntent = new Intent(Intent.ACTION_VIEW);
    Uri upiUri = Uri.parse(upiUriString);
    upiIntent.setData(upiUri);

    if (activity == null) {
      result.error("activity_missing", "Activity is not attached!", null);
      return;
    }

    String appPackageName;
    String appName;
    Drawable appIconDrawable;
    Bitmap appIconBitmap;
    ByteArrayOutputStream iconStream;
    byte[] iconBytes;

    PackageManager packageManager = activity.getPackageManager();
    List<ResolveInfo> upiAppsList = packageManager.queryIntentActivities(upiIntent, 0);

    for (ResolveInfo appInfo : upiAppsList) {
      try {
        appPackageName = appInfo.activityInfo.packageName;
        appName = (String) packageManager.getApplicationLabel(
                packageManager.getApplicationInfo(appPackageName, PackageManager.GET_META_DATA));
        appIconDrawable = packageManager.getApplicationIcon(appPackageName);
        appIconBitmap = convertDrawableToBitmap(appIconDrawable);
        iconStream = new ByteArrayOutputStream();
        appIconBitmap.compress(Bitmap.CompressFormat.PNG, 100, iconStream);
        iconBytes = iconStream.toByteArray();

        Map<String, Object> appDetailsMap = new HashMap<>();
        appDetailsMap.put("packageName", appPackageName);
        appDetailsMap.put("name", appName);
        appDetailsMap.put("icon", iconBytes);

        appPackagesList.add(appDetailsMap);
      } catch (Exception e) {
        e.printStackTrace();
        result.error("package_fetch_error", "Unable to retrieve the list of UPI apps", null);
        return;
      }
    }

    appDataMap.put("appsList", appPackagesList);
    result.success(appDataMap);
  }

  private Bitmap convertDrawableToBitmap(Drawable drawable) {
    Bitmap bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(),
            Bitmap.Config.ARGB_8888);
    Canvas canvas = new Canvas(bitmap);
    drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
    drawable.draw(canvas);
    return bitmap;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
  }

  private void handleIntent(@NonNull MethodCall call, MethodChannel.Result result) {
    try {
      String intentURL = call.argument("intentURL");
      String packageName = call.argument("packageName");
      String intentAction = call.argument("action");
      int requestCode = call.argument("requestCode");
      Map<String, Object> extras = call.argument("extras");

      Intent intent = new Intent(intentAction);
      if (packageName!=null && !packageName.isEmpty()){
        intent.setPackage(packageName);
      }

      if (intentURL != null && !intentURL.isEmpty()) {
        intent.setData(Uri.parse(intentURL));
      }

      Map<String, Object> resultMap = new HashMap<>();
      try{
        activity.startActivityForResult(intent, requestCode);
        resultMap.put("message", "Intent has been started");
        resultMap.put("status", "SUCCESS");
        result.success(resultMap);
      } catch (ActivityNotFoundException e) {
        resultMap.put("message", "No app can handle this intent");
        resultMap.put("error", e);
        resultMap.put("status", "FAILED");
        result.success(resultMap);
      }
      catch (Exception e) {
        // Handle any exception and return an error result
        Map<String, Object> errorMap = new HashMap<>();
        errorMap.put("message", e.getMessage());
        errorMap.put("stackTrace", e.getStackTrace().toString());
        errorMap.put("status", "ERROR");
        result.success(errorMap);
      }

    } catch (Exception e) {
      // Handle any exception and return an error result
      Map<String, Object> errorMap = new HashMap<>();
      errorMap.put("message", e.getMessage());
      errorMap.put("stackTrace", e.getStackTrace().toString());
      errorMap.put("status", "ERROR");
      result.success(errorMap);
    }
  }


  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    Log.d(TAG, "onActivityResult: requestCode = " + requestCode + " result code = " + resultCode);

   if (data != null) {
     Log.d(TAG, "onActivityResult: intent data = " + data.toString());

     Bundle extras = data.getExtras();
     if (extras != null) {
       Log.d(TAG, "onActivityResult: intent extra = " + data.getExtras().toString());
     }

     Uri uri = data.getData();
     if (uri != null) {
       Log.d(TAG, "onActivityResult: intent data = " + uri.toString());
     }
   }
    intentResponseService.send(requestCode,resultCode,data);
    return false;
  }
}

