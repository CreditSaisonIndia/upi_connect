package com.cs.upi_connect;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;


import io.flutter.plugin.common.EventChannel;

public class IntentResponseService implements EventChannel.StreamHandler {
    // To store the event sink whenever flutter starts listenting
    EventChannel.EventSink events;
    private static final String TAG = "FlutterIntent";

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d(TAG, "Got into onlisten " + events.toString());
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {
        Log.d(TAG, "onCancel: Cancelled");
    }

    // Based on the response we get from intent, we are processing and sending back to flutter side
    public void send(int requestCode, int resultCode, Intent data) {
        Map<String, Object> resultMap = new HashMap<>();
        Map<String, Object> extraMap = new HashMap<>();
        Map<String, Object> dataMap = new HashMap<>();

        resultMap.put("resultCode", resultCode);
        resultMap.put("requestCode",requestCode);

        if (data != null) {
            Bundle extras = data.getExtras();
            Uri uri = data.getData();
            if (extras!=null) {
                extraMap = bundleToMap(extras);
                Log.d(TAG, "Extras: " + extraMap);
            }

            if (uri!=null) {
                String url = uri.toString();
                dataMap.put("url", url);
                Log.d(TAG, url);
            }
        }
        resultMap.put("extraData", extraMap);
        resultMap.put("dataMap",dataMap);

        if (events != null) {
            events.success(resultMap);
            events.endOfStream();
        } else {
            Log.d(TAG, "Event is null");
        }
    }

    private Map<String, Object> bundleToMap(Bundle extras) {
        Map<String, Object> map = new HashMap<>();
        for (String key : extras.keySet()) {
            Object value = extras.get(key);
            map.put(key, value);
        }
        return map;
    }
}
