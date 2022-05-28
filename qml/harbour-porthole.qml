import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0

import "pages"

import org.nubecula.harbour.porthole 1.0

ApplicationWindow {

    Notification {
        function show(message, icn) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = icn || ""
            publish()
        }
        function showPopup(title, message, icn) {
            replacesId = 0
            previewSummary = title
            previewBody = message
            icon = icn
            publish()
        }

        id: notification
        appName: "Porthole"
        expireTimeout: 3000
    }

    Connections {
        target: Porthole
        onRequestFailed: {
            switch (error) {
            case 0:
                return

            case 1: // QNetworkReply::ConnectionRefusedError
                //% "Connection refused"
                notification.show(qsTrId("id-error-connection-refused"))
                break

            case 3: // QNetworkReply::HostNotFoundError
                //% "Host not found"
                notification.show(qsTrId("id-error-host-not-found"))
                break

            case 4: // QNetworkReply::TimeoutError
                //% "Connection timed out"
                notification.show(qsTrId("id-error-connection-timed-out"))
                break

            case 6: // QNetworkReply::SslHandshakeFailedError
                //% "Ssl handshake failed"
                notification.show(qsTrId("id-error-ssl-handshake-failed"))
                break

            case 201: // QNetworkReply::ContentAccessDenied
                //% "Access denied"
                notification.show(qsTrId("id-error-access-denied"))
                break

            case 203: // QNetworkReply::ContentNotFoundError
                //% "Not found"
                notification.show(qsTrId("id-error-not-found"))
                break

            case 401: // QNetworkReply::InternalServerError
                //% "Internal server error"
                notification.show(qsTrId("id-error-internal-server-error"))
                break

            default:
                //% "Unkown connection error"
                notification.show(qsTrId("id-error-unkown-connection-error"))
                break
            }
        }
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        Porthole.initialize()
    }
}
