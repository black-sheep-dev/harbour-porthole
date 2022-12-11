import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        anchors.left: parent.left
        anchors.top: parent.top
        width: parent.width
        height: sourceSize.height * width / sourceSize.width
        smooth: true
        source: "/usr/share/harbour-porthole/images/cover-background.svg"
        opacity: 0.1
    }

    Label {
        id: headerLabel
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: Theme.paddingLarge
        }
        horizontalAlignment: Text.AlignHCenter
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeLarge
        text: "Porthole"
    }

    Column {
        anchors{
            top: headerLabel.bottom
            topMargin: Theme.paddingSmall
        }
        width: parent.width
        spacing: Theme.paddingSmall

        Label {
            //% "Total queries"
            text: qsTrId("id-total-queries")
            x: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeExtraSmall
            font.bold: true
        }
        Label {
            id: totalQueries
            x: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeExtraSmall
            text: summary.dns_queries_today
        }
        Label {
            //% "Queries blocked"
            text: qsTrId("id-queries-blocked")
            x: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeExtraSmall
            font.bold: true
        }
        Label {
            id: blockedQueries
            x: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeExtraSmall
            text: summary.ads_blocked_today
        }
        Label {
            //% "Percent blocked"
            text: qsTrId("id-percent-blocked")
            x: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeExtraSmall
            font.bold: true
        }
        Label {
            id: blockedPercent
            x: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeExtraSmall
            text: Number(summary.ads_percentage_today).toLocaleString(Qt.locale()) + " %"
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: filterEnabled ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: app.toggleFilter()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: app.refresh()
        }
    }
}
