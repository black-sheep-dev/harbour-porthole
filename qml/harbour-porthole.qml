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
                notification.show(qsTr("Connection refused"))
                break

            case 3: // QNetworkReply::HostNotFoundError
                notification.show(qsTr("Host not found"))
                break

            case 4: // QNetworkReply::TimeoutError
                notification.show(qsTr("Connection timed out"))
                break

            case 6: // QNetworkReply::SslHandshakeFailedError
                notification.show(qsTr("Ssl handshake failed"))
                break

            case 201: // QNetworkReply::ContentAccessDenied
                notification.show(qsTr("Access denied"))
                break

            case 203: // QNetworkReply::ContentNotFoundError
                notification.show(qsTr("Not found"))
                break

            case 401: // QNetworkReply::InternalServerError
                notification.show(qsTr("Internal server error"))
                break

            default:
                notification.show(qsTr("Unkown connection error"))
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
