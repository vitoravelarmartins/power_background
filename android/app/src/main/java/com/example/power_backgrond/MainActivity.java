package com.example.power_backgrond;


import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;


import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

    private Intent forService;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());

        forService = new Intent(MainActivity.this, MyService.class);


        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "com.powerback.message")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {


                    @RequiresApi(api = Build.VERSION_CODES.O)
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        if (call.method.equals("startService")) {
                            startService();
                            result.success("Serviço Iniciado");
                        }
                        if (call.method.equals("stopService")) {
                            stopService();
                            result.success("Serviço Parado");
                        }
                    }
                });
    }


    @SuppressLint("MissingPermission")
    @RequiresApi(api = Build.VERSION_CODES.O)
    private void startService() {
        startForegroundService(forService);
    }

    private void stopService() {
        stopService(forService);

    }


}



