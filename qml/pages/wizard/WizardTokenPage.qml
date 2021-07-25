import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Dialog {
    id: dialog
    allowedOrientations: Orientation.Portrait
    acceptDestination: Qt.resolvedUrl("WizardFinalPage.qml")

    DialogHeader {
        id: header
        acceptText: qsTr("Continue")
        cancelText: qsTr("Back")
    }

    Column {
        anchors.top: header.bottom
        width: parent.width
        spacing: Theme.paddingMedium

        Label {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x

            text: qsTr("Access Token")

            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
        }

        Label {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall

            text: qsTr("You need to provide an access token to connect to Pi-hole server.")
                  + "\n"
                  + qsTr("This token can be found in config file e.g. \"/etc/pihole/setupVars.conf\".")
                  + "\n"
                  + qsTr("Search for entry WEBPASSWORD.")

            color: Theme.highlightColor
        }

        Item {
            width: 1
            height: Theme.paddingLarge
        }

        PasswordField {
            id: tokenField
            width: parent.width

            label: qsTr("Access Token")
            placeholderText: qsTr("Enter access token")

            text: Porthole.accessToken

            onTextChanged: checkInput()

            focus: true
        }
    }

    function checkInput() { canAccept = tokenField.text.length > 0 }

    onAccepted: {
        Porthole.accessToken = tokenField.text
    }

    Component.onCompleted: checkInput()
}

