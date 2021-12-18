import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: ListModel {
            ListElement {
                //% "Whitelist"
                title: qsTrId("id-whitelist");
                //% "Manage domains on whitelist"
                description: qsTrId("id-whitelist-desc")
                icon: "image://theme/icon-m-browser-permissions"
                page: "SettingsFiltersPage.qml"
                type: 1
            }
            ListElement {
                //% "Blacklist"
                title: qsTrId("id-blacklist");
                //% "Manage domains on blacklist"
                description: qsTrId("id-blacklist-desc")
                icon: "image://theme/icon-m-vpn"
                page: "SettingsFiltersPage.qml"
                type: 2
            }
            ListElement {
                //% "Server Info"
                title: qsTrId("id-server-info");
                //% "Show server info"
                description: qsTrId("id-server-info-desc")
                icon: "image://theme/icon-m-about"
                page: "SettingsServerInfoPage.qml"
                type: 0
            }
            ListElement {
                //% "About"
                title: qsTrId("id-about");
                //% "Infos about Porthole"
                description: qsTrId("id-about-desc")
                icon: "image://theme/icon-m-about"
                page: "../AboutPage.qml"
                type: 0
            }
        }

        anchors.fill: parent
        header: PageHeader {
            //% "Settings"
            title: qsTrId("id-settings")
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

