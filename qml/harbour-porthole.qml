import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0

import "pages"
import "."

ApplicationWindow {
    property bool filterEnabled: false
    property var summary
    property var versions

    function refresh() {
        Api.requestGet("summaryRaw", function(data, status) {
            if (status !== 200) {
                //% "Failed to fetch data from server"
                notification.show(qsTrId("id-error-failed-to-fetch-data"))
                return
            }

            summary = data
            filterEnabled = data.status === "enabled"
        })
    }

    function toggleFilter() {
        Api.requestGet(filterEnabled ? "disable" : "enable", function(data, status) {
            if (status !== 200) {
                //% "Failed to toggle filter on/off"
                notification.show(qsTrId("id-error-failed-to-toggle-filter"))
                return
            }

            filterEnabled = data.status === "enabled"
        })
    }

    function getVersions() {
        Api.requestGet("versions", function (data, status) {
            if (status !== 200) {
                //% "Could not get version info from server"
                notification.show(qsTrId("id-error-could-not-get-version-info"))
                return
            }

            versions = data

            if (data.core_current !== data.core_latest) {
                //% "PiHole update available"
                notification.showPopup(qsTrId("id-pihole-update"),
                                       //% "An update for PiHole core is available"
                                       qsTrId("id-core-update-available") + ": " + data.core_latest)
            }
            if (data.web_current !== data.web_latest) {
                //% "PiHole update available"
                notification.showPopup(qsTrId("id-pihole-update"),
                                       //% "An update for PiHole web is available"
                                       qsTrId("id-web-update-available") + ": " + data.web_latest)
            }
            if (data.FTL_current !== data.FTL_latest) {
                //% "PiHole update available"
                notification.showPopup(qsTrId("id-pihole-update"),
                                       //% "An update for PiHole FTL is available"
                                       qsTrId("id-ftl-update-available") + ": " + data.FTL_latest)
            }
        })
    }

    id: app

    ConfigurationGroup {
        id: config
        path: "/apps/harbour-porthole"
        synchronous: true

        property string accessToken: ""
        property string url: ""

        onAccessTokenChanged: Api.accessToken = accessToken
        onUrlChanged: Api.url = url

        Component.onCompleted: {
            Api.accessToken = accessToken
            Api.url = url
        }
    }

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
            icon = icn || ""
            publish()
        }

        id: notification
        appName: "Porthole"
        expireTimeout: 3000
    }

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    Component.onCompleted: {
        if (config.accessToken.length === 0 || config.url.length === 0) {
            pageStack.push(Qt.resolvedUrl("pages/wizard/WizardIntroPage.qml"))
        } else {
            pageStack.push(Qt.resolvedUrl("pages/MainPage.qml"))
            refresh()
            getVersions()
        }
    }
}
