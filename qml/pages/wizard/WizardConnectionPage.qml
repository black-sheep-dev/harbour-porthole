import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Dialog {
    property bool connectionError: false

    id: dialog
    allowedOrientations: Orientation.Portrait
    acceptDestination: Qt.resolvedUrl("WizardTokenPage.qml")

    canAccept: false

    DialogHeader {
        id: header
        acceptText: qsTr("Continue")
        cancelText: qsTr("Back")
    }

    Column {
        anchors.top: header.bottom
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x

        spacing: Theme.paddingMedium

        Label {
            width: parent.width

            text: qsTr("Connection Settings")

            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap

            text: qsTr("You need to provide the connection details to your Pi-hole server.")
                  + "\n"
                  + qsTr("Please provide a full URL for this!")

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

            label: qsTr("URL")
            placeholderText: qsTr("Enter URL (e.g. http://pi-hole.local)")

            text: Porthole.url

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
            text: qsTr("Valid URL required!")
            color: Theme.errorColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }

        Label {
            visible: connectionError

            width: parent.width
            text: qsTr("Failed to connect to Pi-hole server!")
            color: Theme.errorColor
            font.pixelSize: Theme.fontSizeExtraSmall
        }

    }

    function testConnection() {
        if (!urlField.acceptableInput) return

        connectionError = false
        Porthole.setUrl(urlField.text)
        Porthole.sendRequest("status")
    }

    Connections {
        target: Porthole
        onRequestFailed: {
            canAccept = false
            connectionError = true
        }
        onRequestFinished: {
            if (query !== "status") return
            connectionError = false
            canAccept = true
        }
    }
}

