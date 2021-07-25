import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Dialog {
    id: dialog
    allowedOrientations: Orientation.Portrait

    DialogHeader {
        id: header
        acceptText: qsTr("Complete")
        cancelText: qsTr("Back")
    }

    Column {
        anchors.top: header.bottom
        width: parent.width
        spacing: Theme.paddingMedium

        Label {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x

            text: qsTr("Setup process completed")

            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
        }
    }

    onAccepted: {
        Porthole.saveSettings()
        pageStack.clear()
        pageStack.push(Qt.resolvedUrl("../MainPage.qml"))
    }
}

