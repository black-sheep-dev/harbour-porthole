import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: ListModel {
            ListElement {
                //% "Top permitted"
                title: qsTrId("id-top-permitted");
                //% "Show top permitted domains"
                description: qsTrId("id-top-permitted-desc")
                icon: "image://theme/icon-m-acknowledge"
                page: "CounterListPage.qml"
                type: 0
            }
            ListElement {
                //% "Top blocked"
                title: qsTrId("id-top-blocked");
                //% "Show top blocked domains"
                description: qsTrId("id-top-blocked-desc")
                icon: "image://theme/icon-m-vpn"
                page: "CounterListPage.qml"
                type: 1
            }
            ListElement {
                //% "Top clients"
                title: qsTrId("id-top-clients");
                //% "Show top clients"
                description: qsTrId("id-top-clients-desc")
                icon: "image://theme/icon-m-media-artists"
                page: "CounterListPage.qml"
                type: 2
            }
            ListElement {
                //% "Top clients blocked"
                title: qsTrId("id-top-clients-blocked");
                //% "Show top blocked clients"
                description: qsTrId("id-top-clients-blocked-desc")
                icon: "image://theme/icon-m-media-artists"
                page: "CounterListPage.qml"
                type: 3
            }
        }

        anchors.fill: parent
        header: PageHeader {
            //% "Analysis"
            title: qsTrId("id-analysis")
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

            onClicked: pageStack.push(Qt.resolvedUrl(page), {
                                          title: model.title,
                                          type: model.type
                                      })
        }

        VerticalScrollDecorator {}
    }
}

