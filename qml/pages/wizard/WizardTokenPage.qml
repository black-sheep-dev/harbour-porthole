import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    allowedOrientations: Orientation.Portrait
    acceptDestination: Qt.resolvedUrl("WizardFinalPage.qml")
    canAccept: tokenField.text.length > 0

    DialogHeader {
        id: header
        //% "Continue"
        acceptText: qsTrId("id-continue")
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

            //% "Access Token"
            text: qsTrId("id-access-token")

            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeLarge
        }

        Label {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            wrapMode: Text.WordWrap
            font.pixelSize: Theme.fontSizeSmall

            //% "You need to provide an access token to connect to Pi-hole server."
            text: qsTrId("id-wizard-provice-access-token")
                  + "\n"
                    //% "This token can be found in config file e.g."
                  + qsTrId("id-wizard-config-file-info") +  "\"/etc/pihole/setupVars.conf\"."
                  + "\n"
                    //% "Search for entry WEBPASSWORD."
                  + qsTrId("id-wizard-search-webpassword")

            color: Theme.highlightColor
        }

        Item {
            width: 1
            height: Theme.paddingLarge
        }

        PasswordField {
            id: tokenField
            width: parent.width

            //% "Access Token"
            label: qsTrId("id-access-token")
            //% "Enter access token"
            placeholderText: qsTrId("id-enter-access-token")

            focus: true
        }
    }

    onAccepted: config.accessToken = tokenField.text
}

