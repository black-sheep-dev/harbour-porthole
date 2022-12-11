import QtQuick 2.0
import Sailfish.Silica 1.0

import "../../."

Dialog {
    property bool connectionError: false

    id: dialog
    allowedOrientations: Orientation.Portrait
    acceptDestination: Qt.resolvedUrl("WizardTokenPage.qml")

    canAccept: false

    function testConnection() {
        Api.url = urlField.text
        Api.requestGet("status", function(data, status) {
            if (status !== 200) {
                //% "Could not connect to PiHole server"
                notification.show(qsTrId("id-pihole-not-found"))
                return
            }

            if (data.status !== "enabled") {
                //% "Admin API is not enabled on PiHole server"
                notification.show(qsTrId("id-pihole-api-not-enabled"))
                return
            }
            canAccept = true
        })
    }

    DialogHeader {
        id: header
        //% "Continue"
        acceptText: qsTrId("id-continue")
        //% "Back"
        cancelText: qsTrId("id-back")
    }

    Column {
        anchors.top: header.bottom
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x

        spacing: Theme.paddingMedium

        Label {
            width: parent.width

            //% "Connection Settings"
            text: qsTrId("id-connection-settings")

            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap

            //% "You need to provide the connection details to your Pi-hole server."
            text: qsTrId("id-provide-connection-details")
                  + "\n"
                    //% "Please provide a full URL for this!"
                  + qsTrId("id-provide-full-url")

            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap

            text: "<ul><li>http://pi-hole.local</li><li>http://192.168.168.2</li><li>http://pi-hole.local:8080</li></ul>"

            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
        }

        Item {
            width: 1
            height: Theme.paddingMedium
        }

        TextField {
            id: urlField
            width: parent.width

            //% "URL"
            label: qsTrId("id-url")
            //% "Enter URL (e.g. http://pi-hole.local)"
            placeholderText: qsTrId("id-enter-url")

            inputMethodHints: Qt.ImhUrlCharactersOnly
            validator: RegExpValidator {
                regExp: /^(http(s?):\/\/(www\.)?)[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*(\(.[a-zA-Z]{2,5})?(:[0-9]{1,5})?(\/.*)?$/g
            }

            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: {
                focus = false
                testConnection()
            }

            onFocusChanged: if (focus === false) testConnection()

            autoScrollEnabled: true
        }

        Label {
            width: parent.width
            visible: !urlField.acceptableInput
            //% "Valid URL required!"
            text: qsTrId("id-valid-url-required")
            color: Theme.errorColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }

        Label {
            visible: connectionError

            width: parent.width
            //% "Failed to connect to Pi-hole server!"
            text: qsTrId("id-connection-to-porthole-failed")
            color: Theme.errorColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }
    }

    onAccepted: config.url = urlField.text
}

