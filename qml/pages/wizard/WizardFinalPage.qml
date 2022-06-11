import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Dialog {
    id: dialog
    allowedOrientations: Orientation.Portrait

    acceptDestination: Qt.resolvedUrl("../MainPage.qml")
    acceptDestinationAction: PageStackAction.Replace
    acceptDestinationReplaceTarget: null

    DialogHeader {
        id: header
        //% "Complete"
        acceptText: qsTrId("id-complete")
        //% "Back"
        cancelText: qsTrId("id-back")
    }

    Column {
        anchors.top: header.bottom
        width: parent.width
        spacing: Theme.paddingMedium

        Label {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x

            //% "Setup process completed"
            text: qsTrId("id-setup-complete")

            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
        }
    }

    onAccepted: Porthole.saveSettings()
}

