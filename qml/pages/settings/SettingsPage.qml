import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: ListModel {
            ListElement {
                title: qsTr("Whitelist");
                description: qsTr("Manage domains on whitelist")
                icon: "image://theme/icon-m-browser-permissions"
                page: "SettingsFiltersPage.qml"
                type: 1
            }
            ListElement {
                title: qsTr("Blacklist");
                description: qsTr("Manage domains on blacklist")
                icon: "image://theme/icon-m-vpn"
                page: "SettingsFiltersPage.qml"
                type: 2
            }
            ListElement {
                title: qsTr("Server Info");
                description: qsTr("Show server info")
                icon: "image://theme/icon-m-about"
                page: "SettingsServerInfoPage.qml"
                type: 0
            }
            ListElement {
                title: qsTr("About");
                description: qsTr("Infos about Porthole")
                icon: "image://theme/icon-m-about"
                page: "../AboutPage.qml"
                type: 0
            }
        }

        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Settings")
        }

        delegate: ListItem {
            id: delegate
            width: parent.width
            contentHeight: Theme.itemSizeMedium

            Row {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingMedium

                Image {
                    id: itemIcon
                    source: icon
                    anchors.verticalCenter: parent.verticalCenter
                }

                Column {
                    id: data
                    width: parent.width - itemIcon.width - parent.spacing
                    anchors.verticalCenter: itemIcon.verticalCenter
                    Label {
                        id: text
                        width: parent.width
                        text: title
                        color: pressed ? Theme.secondaryHighlightColor:Theme.highlightColor
                        font.pixelSize: Theme.fontSizeMedium
                    }
                    Label {
                        text: description
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }

            onClicked: pageStack.push(Qt.resolvedUrl(page), type > 0 ? {type: type} : {})
        }

        VerticalScrollDecorator {}
    }
}

