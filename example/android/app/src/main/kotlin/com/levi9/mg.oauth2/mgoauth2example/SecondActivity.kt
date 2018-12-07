package com.levi9.mg.oauth2.mgoauth2example

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient

class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)

        val webView = findViewById<WebView>(R.id.webView)
        webView.settings.javaScriptEnabled = true
        webView.webViewClient = MyWebClient(this)

        webView.loadUrl("https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=eeffec03-c281-4980-b6c0-8c5cbb564dc4&response_type=code&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient&response_mode=query&scope=offline_access%20user.read%20mail.read&state=12345")
    }
}

class MyWebClient(val activity: AppCompatActivity) : WebViewClient() {

    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)
    }

    override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
        if(url != null && url.contains("code")) {
            val start = url.indexOf("?code") - 5
            val end = url.indexOf("&state")
            MainActivity.calResult.success(url.substring(start, end))
            activity.finish()
            return true
        }

        return super.shouldOverrideUrlLoading(view, url)
    }
}