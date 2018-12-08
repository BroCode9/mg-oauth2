package com.levi9.mgoauth2.mgoauth2example.models

data class RequestParams(var url: String = "",
                         var clientID: String = "",
                         var response: String = "",
                         var redirectURI: String = "",
                         var responseMode: String = "",
                         var scope: String = "",
                         var state: String = "")