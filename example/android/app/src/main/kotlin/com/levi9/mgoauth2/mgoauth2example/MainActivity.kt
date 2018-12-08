package com.levi9.mgoauth2.mgoauth2example

import android.content.Intent
import android.os.Bundle
import com.levi9.mgoauth2.mgoauth2example.document.DocumentActivity

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    companion object {
        lateinit var calResult: MethodChannel.Result
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, "plugin.screen").setMethodCallHandler(
                object : MethodChannel.MethodCallHandler {
                    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                        calResult = result

                        if (call.method.equals("openLoginScreen")) {
                            val intent = Intent(this@MainActivity, DocumentActivity::class.java)
                            intent.putExtra("request_arguments", call.arguments.toString())
                            startActivity(intent)
                        }
                    }
                })
    }
}
