package com.example.taskfirst;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity
{
    TextView text_variant;
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        text_variant = (TextView)findViewById(R.id.text_variant);

        if ((BuildConfig.DEBUG) || (BuildConfig.BUILD_TYPE.equals("Debug")))
        {
            //Build is Testing Type
            text_variant.setText("QA");
        }
        else
        {
            //Build is Production Type
            text_variant.setText("PRODUCTION");
        }
    }
}
