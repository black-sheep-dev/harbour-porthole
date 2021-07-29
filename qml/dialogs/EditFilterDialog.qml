import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property alias comment: commentField.text
    property alias domain: domainField.text
    property bool edit: false
    property alias filter: filterBox.currentIndex
    property alias wildcard: wildcardSwitch.checked

    Column {
        width: parent.width

        DialogHeader {
            acceptText: edit ? qsTr("Save") : qsTr("Add")
        }

        ComboBox {
            id: filterBox
            label: qsTr("Filter")
            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Domain")
                }
                MenuItem {
                    text: qsTr("RegEx filter")
                }
            }
        }

        TextField {
            id: domainField
            width: parent.width
            placeholderText: filterBox.currentIndex === 0 ? qsTr("Enter domain") : qsTr("Enter regular expression")
            label: filterBox.currentIndex === 0 ? qsTr("Domain") : qsTr("Regular Expression")
            inputMethodHints: filterBox.currentIndex === 0 ? Qt.ImhUrlCharactersOnly : Qt.ImhNoPredictiveText
        }

        TextSwitch {
            //visible: filterBox.currentIndex === 0
            visible: false
            id: wildcardSwitch
            text: qsTr("Add domain as wildcard")
            description: qsTr("Activate this to involve all subdomains")
        }

        TextField {
            id: commentField
            width: parent.width
            placeholderText: qsTr("Enter description (optional)")
            label: qsTr("Comment")
        }

    }

}
