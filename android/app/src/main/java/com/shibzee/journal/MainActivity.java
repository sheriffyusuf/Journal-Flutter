package com.shibzee.journal;

//import androidx.multidex.MultiDex;

import android.content.Context;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity{
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }

/*  @Override
  protected void attachBaseContext(Context newBase) {
    super.attachBaseContext(newBase);
    MultiDex.install(this);
  }*/
}
