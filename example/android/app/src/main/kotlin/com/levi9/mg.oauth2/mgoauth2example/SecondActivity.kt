package com.levi9.mg.oauth2.mgoauth2example

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.webkit.WebView
import android.webkit.WebViewClient
import com.google.gson.Gson
import com.levi9.mg.oauth2.mgoauth2example.models.RequestParams

class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)

        val request_arguments = intent.getStringExtra("request_arguments")

        val webView = findViewById<WebView>(R.id.webView)
        webView.settings.javaScriptEnabled = true
        webView.webViewClient = MyWebClient(this)

        webView.loadUrl(genereateLoginUrl(request_arguments))
    }

    private fun genereateLoginUrl(request_arguments: String?): String {
        if (request_arguments != null) {
            val requestParams = Gson().fromJson(request_arguments, RequestParams::class.java)

            val stringBuilder = StringBuilder()
            stringBuilder.append(requestParams.url)
                    .append("client_id=").append(requestParams.clientID)
                    .append("&response_type=").append(requestParams.response)
                    .append("&redirect_uri=").append(requestParams.redirectURI)
                    .append("&response_mode=").append(requestParams.responseMode)
                    .append("&scope=").append(requestParams.scope)
                    .append("&state=").append(requestParams.state)

            return stringBuilder.toString()
        }

        return ""
    }
}

class MyWebClient(val activity: AppCompatActivity) : WebViewClient() {

    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)
    }

    override fun shouldOverrideUrlLoading(view: WebView?, url: String?): Boolean {
        if (url != null && url.contains("code")) {
            val start = url.indexOf("?code=") + 6
            val end = url.indexOf("&state=")
            MainActivity.calResult.success(url.substring(start, end))
            activity.finish()
            return true
        }

        return super.shouldOverrideUrlLoading(view, url)
    }
}