pragma Singleton
import QtQuick 2.0

Item {
    property string accessToken
    property string url

    function getQueryUrl(query) {
        const queryUrl = url + "/admin/api.php?" + query
        if (accessToken.length > 0) queryUrl += "&auth=" + accessToken

        return queryUrl
    }

    function requestGet (query, callback) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if (myxhr.readyState !== 4) return

                if (myxhr.status === 308) {
                    const location = myxhr.getResponseHeader("Location")
                    request.call(myxhr, location, callback)
                    return
                }

                var data

                try {
                    data = JSON.parse(myxhr.responseText)
                } catch (e) {
                    data = myxhr.responseText
                }

                callback(data, myxhr.status)
            }
        })(xhr)



        xhr.open("GET", getQueryUrl(query))
        xhr.send()
    }

    function requestPost (query, payload, callback) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if (myxhr.readyState !== 4) return

                if (myxhr.status === 308) {
                    const location = myxhr.getResponseHeader("Location")
                    request.call(myxhr, location, callback)
                    return
                }

                var data

                try {
                    data = JSON.parse(myxhr.responseText)
                } catch (e) {
                    data = myxhr.responseText
                }

                callback(data, myxhr.status)
            }
        })(xhr)

        xhr.open("POST", getQueryUrl(query))
        xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
        xhr.send(payload)
    }
}

