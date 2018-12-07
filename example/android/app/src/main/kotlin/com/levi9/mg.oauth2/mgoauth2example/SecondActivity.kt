package com.levi9.mg.oauth2.mgoauth2example

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.Button
import android.widget.EditText

class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)

        val btnSubmit = findViewById<Button>(R.id.btnSubmit)
        btnSubmit.setOnClickListener {
            val etText = findViewById<EditText>(R.id.etText)
            MainActivity.calResult.success(etText.text.toString())
            finish()
        }
    }
}