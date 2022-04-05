package com.example.power_backgrond;

import android.annotation.SuppressLint;
import android.app.Service;

import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.IBinder;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class MyService extends Service implements LocationListener {

    private LocationManager locationManager;
    private NotificationCompat.Builder builder;

    @SuppressLint("MissingPermission")
    @Override
    public void onCreate() {
        super.onCreate();
        showNotification("Iniciou Serviço", "Serviço de localização em Background");

        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 10, this);

    }


    @Override
    public IBinder onBind(Intent intent) {

        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (locationManager != null) {
            locationManager.removeUpdates(this);
        }
    }

    @Override
    public void onLocationChanged(@NonNull Location location) {
        String latitude = String.valueOf(location.getLatitude());
        String longitude = String.valueOf(location.getLongitude());
      //  String altitude = String.valueOf(location.getAltitude());
     //   String speed = String.valueOf(location.getSpeed());
      //  String time = String.valueOf(location.getTime());

        showNotification("Localização atual", "latitude: " + latitude+" longitude: " + longitude);

    }

    private void showNotification(String title, String msg) {
        if (this.builder == null) {

            this.builder = new NotificationCompat.Builder(this, "messages")
                    .setContentTitle(title)
                    .setContentText(msg)
                    .setSmallIcon(R.mipmap.localizacao);
        } else {
            this.builder.setContentText(msg);
            this.builder.setContentTitle(title);
        }
        startForeground(101, builder.build());
        //(int) UUID.randomUUID().getMostSignificantBits()
    }
}


