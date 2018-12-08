package com.levi9.mgoauth2.mgoauth2example.models

data class User(var id: String = "",
                var displayName: String = "",
                var givenName: String = "",
                var jobTitle: String = "",
                var mail: String = "",
                var mobilePhone: String = "",
                var officeLocation: String = "",
                var photoBase64: String = "")