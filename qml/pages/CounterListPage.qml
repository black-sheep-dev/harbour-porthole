import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Page {
    property string title
    property int type: 0

    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView
        model: SortModel {
            id: sortModel
            sortRole: CounterModel.CountRole
            sourceModel: CounterModel {
                id: counterModel
            }
        }

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
                                model.name.split("|")[0]
                            } else {
                                return model.name
                            }
                        }
                        color: pressed ? Theme.secondaryHighlightColor:Theme.highlightColor
                        font.pixelSize: Theme.fontSizeMedium
                    }
                    Label {
                        //% "%n Request(s)"
                        text: qsTrId("id-requests", model.count)
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }

                ProgressCircle {
                    id: frequencyCircle
                    height: Theme.itemSizeExtraSmall
                    width: Theme.itemSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter

                    progressValue: Math.min(model.count / Porthole.summary.dns_queries_all_types, 1)


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

    function refresh() {
        switch (page.type) {
        case 0:
        case 1:
            Porthole.sendRequest("topItems", true)
            break; 

        case 2:
            Porthole.sendRequest("topClients", true)
            break;

        case 3:
            Porthole.sendRequest("topClientsBlocked", true)
            break;

        default:
            break;
        }
    }

    Connections {
        target: Porthole
        onRequestFinished: {
            if (query === "topItems") {
                if (type === 0) {
                    counterModel.setItems(data.top_queries)
                    sortModel.sortModel(Qt.DescendingOrder)
                } else if (type === 1) {
                    counterModel.setItems(data.top_ads)
                    sortModel.sortModel(Qt.DescendingOrder)
                }
            } else if (query === "topClients" && type === 2) {
                counterModel.setItems(data.top_sources)
                sortModel.sortModel(Qt.DescendingOrder)
            } else if (query === "topClientsBlocked" && type === 3) {
                counterModel.setItems(data.top_sources_blocked)
                sortModel.sortModel(Qt.DescendingOrder)
            }
        }
    }

    Component.onCompleted: refresh()
}

