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
            acceptText: edit ?
                            //% "Save"
                            qsTrId("id-save") :
                            //% "Add"
                            qsTrId("id-add")
        }

        ComboBox {
            id: filterBox
            //% "Filter"
            label: qsTrId("id-filter")
            menu: ContextMenu {
                MenuItem {
                    //% "Domain"
                    text: qsTrId("id-domain")
                }
                MenuItem {
                    //% "RegEx filter"
                    text: qsTrId("id-regex-filter")
                }
            }
        }

        TextField {
            id: domainField
            width: parent.width
            placeholderText: filterBox.currentIndex === 0 ?
                                 //% "Enter domain"
                                 qsTrId("id-enter-domain") :
                                 //% "Enter regular expression"
                                 qsTrId("id-enter-regex")
            label: filterBox.currentIndex === 0 ?
                       //% "Domain"
                       qsTrId("id-domain") :
                       //% "Regular expression"
                       qsTrId("id-regex")
            inputMethodHints: filterBox.currentIndex === 0 ? Qt.ImhUrlCharactersOnly : Qt.ImhNoPredictiveText
        }

        TextSwitch {
            //visible: filterBox.currentIndex === 0
            visible: false
            id: wildcardSwitch
            //% "Add domain as wildcard"
            text: qsTrId("id-add-domain-wildcard")
            //% "Activate this to involve all subdomains"
            description: qsTrId("id-add-domain-wildcard-desc")
        }

        TextField {
            id: commentField
            width: parent.width
            //% "Enter description (optional)"
            placeholderText: qsTrId("id-enter-description-optional")
            //% "Comment"
            label: qsTrId("id-comment")
        }

    }

}
