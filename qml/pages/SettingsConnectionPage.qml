import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    function applyChanges() {
        if (urlField.acceptableInput) Porthole.url = urlField.text
        if (tokenField.text.length > 0) Porthole.accessToken = tokenField.text
        Porthole.saveSettings()
    }

    RemorsePopup { id: remorse }

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                text: qsTr("Reset")
                onClicked: remorse.execute(qsTr("Reset application"), function() {
                    Porthole.url = ""
                    Porthole.accessToken = ""
                    Porthole.saveSettings()
                    pageStack.clear()
                    pageStack.push(Qt.resolvedUrl("MainPage.qml"))
                })
            }
        }

        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Connection Settings")
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
                EnterKey.onClicked: tokenField.focus = true


                autoScrollEnabled: true
            }

            PasswordField {
                id: tokenField
                width: parent.width

                label: qsTr("Access Token")
                placeholderText: qsTr("Enter access token")

                text: Porthole.accessToken

                EnterKey.onClicked: focus = false
            }
        }
    }

    onStatusChanged: if (status == PageStatus.Deactivating) page.applyChanges();
}
