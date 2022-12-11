import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

Page {
    property string title
    property int type: 0

    property var items: []

    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        PullDownMenu {
            MenuItem {
                //% "Refresh"
                text: qsTrId("id-refresh")
                onClicked: refresh()
            }
        }

        id: listView
        model: items

        anchors.fill: parent
        header: PageHeader {
            title: page.title
        }

        delegate: ListItem {
            id: delegate
            width: parent.width
            contentHeight: contentRow.height + 2*Theme.paddingMedium

            Row {
                id: contentRow
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingMedium

                Column {
                    id: data
                    width: parent.width - frequencyCircle.width - parent.spacing
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        id: text
                        width: parent.width
                        wrapMode: Text.WrapAnywhere
                        text: {
                            if (type === 2 || type === 3) {
                                modelData.name.split("|")[0]
                            } else {
                                return modelData.name
                            }
                        }
                        color: pressed ? Theme.secondaryHighlightColor:Theme.highlightColor
                        font.pixelSize: Theme.fontSizeMedium
                    }
                    Label {
                        //% "%n Request(s)"
                        text: qsTrId("id-requests", modelData.count)
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }

                ProgressCircle {
                    id: frequencyCircle
                    height: Theme.itemSizeExtraSmall
                    width: Theme.itemSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter

                    progressValue: Math.min(modelData.count / summary.dns_queries_all_types, 1)


                    Label {
                        anchors.centerIn: parent
                        font.pixelSize: Theme.fontSizeTiny * 0.8
                        text: Math.floor(frequencyCircle.progressValue * 100) + " %"
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    function setItems(data) {
        var arr = []
        Object.keys(data).forEach(function(key) {
            var item = {
                name: key,
                count: data[key]
            }

            arr.push(item)
        })

        items = arr
    }

    function refresh() {
        var query
        switch (page.type) {
        case 0:
        case 1:
            query = "topItems"
            break; 

        case 2:
            query = "topClients"
            break;

        case 3:
            query = "topClientsBlocked"
            break;

        default:
            return;
        }

        Api.requestGet(query, function(data, status) {
            if (status !== 200) {
                //% "Failed to fetch data"
                notification.show(qsTrId("id-error-failed-to-fetch-data"))
                return
            }

            if (query === "topItems") {
                if (type === 0) {
                    setItems(data.top_queries)
                } else if (type === 1) {
                    setItems(data.top_ads)
                }
            } else if (query === "topClients" && type === 2) {
                setItems(data.top_sources)
            } else if (query === "topClientsBlocked" && type === 3) {
                setItems(data.top_sources_blocked)
            }
        })
    }

    Component.onCompleted: refresh()
}

