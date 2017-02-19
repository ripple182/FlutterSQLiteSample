// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.ripple182.fluttersqlite;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterView;

public class ExampleActivity extends Activity
{
    private static final String TAG = "ExampleActivity";

    private RawSQLiteHelper sqLiteHelper;
    private FlutterView flutterView;

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        FlutterMain.ensureInitializationComplete(getApplicationContext(), null);
        setContentView(R.layout.hello_services_layout);

        flutterView = (FlutterView) findViewById(R.id.flutter_view);
        flutterView.runFromBundle(FlutterMain.findAppBundlePath(getApplicationContext()), null);

        final Context context = this;
        flutterView.addOnMessageListener("initDatabase", new FlutterView.OnMessageListener()
        {
            @Override
            public String onMessage(FlutterView flutterView, String s)
            {
                sqLiteHelper = new RawSQLiteHelper(context, flutterView, s, 1);

                return "";
            }
        });
    }

    @Override
    protected void onDestroy()
    {
        if (flutterView != null)
        {
            flutterView.destroy();
        }
        super.onDestroy();
    }

    @Override
    protected void onPause()
    {
        super.onPause();
        flutterView.onPause();
    }

    @Override
    protected void onPostResume()
    {
        super.onPostResume();
        flutterView.onPostResume();
    }
}
