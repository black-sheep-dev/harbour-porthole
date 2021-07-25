import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: ListModel {
            ListElement {
                title: qsTr("Top permitted");
                description: qsTr("Show top permitted domains")
                icon: "image://theme/icon-m-acknowledge"
                page: "CounterListPage.qml"
                type: 0
            }
            ListElement {
                title: qsTr("Top blocked");
                description: qsTr("Show top blocked domains")
                icon: "image://theme/icon-m-vpn"
                page: "CounterListPage.qml"
                type: 1
            }
            ListElement {
                title: qsTr("Top clients");
                description: qsTr("Show top clients")
                icon: "image://theme/icon-m-media-artists"
                page: "CounterListPage.qml"
                type: 2
            }
            ListElement {
                title: qsTr("Top clients blocked");
                description: qsTr("Show top blocked clients")
                icon: "image://theme/icon-m-media-artists"
                page: "CounterListPage.qml"
                type: 3
            }
        }

        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Analysis")
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

                Image {
                    id: itemIcon
                    source: icon
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width:Theme.paddingMedium
                    height:1
                }

                Column {
                    id: data
                    width: parent.width - itemIcon.width
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

            onClicked: pageStack.push(Qt.resolvedUrl(page), {
                                          title: model.title,
                                          type: model.type
                                      })
        }

        VerticalScrollDecorator {}
    }
}

