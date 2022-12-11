import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    function applyChanges() {
        if (urlField.acceptableInput) config.url = urlField.text
        if (tokenField.text.length > 0) config.accessToken = tokenField.text
    }

    RemorsePopup { id: remorse }

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                //% "Reset"
                text: qsTrId("id-reset")
                //% "Reset and close application"
                onClicked: remorse.execute(qsTrId("id-reset-and-close-application"), function() {
                    config.url = ""
                    config.accessToken = ""
                    Qt.quit()
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
                //% "Connection Settings"
                title: qsTrId("id-connection-settings")
            }

            TextField {
                id: urlField
                width: parent.width

                //% "URL"
                label: qsTrId("id-url")
                //% "Enter URL (e.g. http://pi-hole.local)"
                placeholderText: qsTrId("id-enter-url")

                text: config.url

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

                //% "Access Token"
                label: qsTrId("id-access-token")
                //% "Enter access token"
                placeholderText: qsTrId("id-enter-access-token")

                text: config.accessToken

                EnterKey.onClicked: focus = false
            }
        }
    }

    onStatusChanged: if (status == PageStatus.Deactivating) page.applyChanges();
}
