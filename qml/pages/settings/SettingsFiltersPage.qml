import QtQuick 2.0
import Sailfish.Silica 1.0

import "../../."

Page {
    property bool busy: false
    property var items: []
    property int type: 1

    id: page

    allowedOrientations: Orientation.All

    PageBusyIndicator {
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
        running: busy
    }

    SilicaListView {
        PullDownMenu {
            MenuItem {
                //% "Add"
                text: qsTrId("id-add")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("../../dialogs/EditFilterDialog.qml"))

                    dialog.accepted.connect(function() {
                        var query = "list="

                        if (dialog.filter === 1) query += "regex_"
                            query += page.type === 1 ? "white" : "black"

                        query += "&add=" + dialog.domain

                        var type;
                        if (dialog.filter === 0 && page.type === 1 && !dialog.wildcard) {
                            type = "0"
                        } else if (dialog.filter === 0 && page.type === 1 && dialog.wildcard) {
                            type = "2W"
                        } else if (dialog.filter === 0 && page.type === 2 && !dialog.wildcard) {
                            type = "1"
                        } else if (dialog.filter === 0 && page.type === 2 && dialog.wildcard) {
                            type = "3W"
                        } else if (dialog.filter === 1 && page.type === 1) {
                            type = "2"
                        } else if (dialog.filter === 1 && page.type === 2) {
                            type = "3"
                        }

                        var data = "type=" + type + "&comment=" + dialog.comment

                        Api.requestPost(query, data, function (data, status) {
                            if (status !== 200) {
                                //% "Failed to add filter"
                                notification.show(qsTrId("id-error-failed-to-add-filter"))
                                return
                            }

                            refresh()
                       })
                    })
                }
            }
            MenuItem {
                //% "Refresh"
                text: qsTrId("id-refresh")
                onClicked: refresh()
            }
        }

        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: type === 1 ?
                       //% "Whitelist"
                       qsTrId("id-whitelist") :
                       //% "Blacklist"
                       qsTrId("id-blacklist")
        }

        clip: true

        model: items

        delegate: ListItem {
            id: delegate
            width: parent.width
            contentHeight: Theme.itemSizeMedium

            menu: ContextMenu {
                MenuItem {
                    //% "Delete"
                    text: qsTrId("id-delete")
                    //% "Delete filter"
                    onClicked: delegate.remorseAction(qsTrId("id-delete-filter"), function() {
                        var list

                        switch (modelData.type) {
                        case 0:
                            list = "white"
                            break;

                        case 1:
                            list = "black"
                            break;

                        case 2:
                            list = "regex_white"
                            break;

                        case 3:
                            list = "regex_black"
                            break;

                        default:
                            return;
                        }

                        Api.requestGet("list=" + list + "&sub=" + modelData.domain, function (data, status) {
                            if (status !== 200) {
                                //% "Failed to delete filter"
                                notification.show(qsTrId("id-error-failed-to-delete-filter"))
                                return
                            }

                            refresh()
                        })
                    })
                }
            }

            Row {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingMedium

                Image {
                    id: itemIcon
                    source: modelData.enabled ? "image://theme/icon-m-acknowledge" : "image://theme/icon-m-clear"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Item {
                    width:Theme.paddingMedium
                    height:1
                }

                Column {
                    id: data
                    width: parent.width - itemIcon.width - parent.spacing
                    anchors.verticalCenter: itemIcon.verticalCenter
                    Label {
                        id: text
                        width: parent.width
                        text: modelData.domain
                        color: pressed ? Theme.secondaryHighlightColor:Theme.highlightColor
                        font.pixelSize: Theme.fontSizeMedium
                    }
                    Label {
                        text: modelData.comment
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count === 0 && !page.busy
            //% "No filters available"
            text: qsTrId("id-no-filters")
            //% "Pull down to add one"
            hintText: qsTrId("id-filter-add-info")
        }

        VerticalScrollDecorator {}
    }

    function refresh() {
        page.busy = true

        switch (page.type) {
        case 1:
            items = []
            Api.requestGet("list=white", function (data, status) {
                page.busy = false
                if (status !== 200) {
                    //% "Failed to get whitelist"
                    notification.show(qsTrId("id-error-failed-to-get-whitelist"))
                    return
                }

                items = items.concat(data.data)
            })
            Api.requestGet("list=regex_white", function (data, status) {
                page.busy = false
                if (status !== 200) {
                    //% "Failed to get regex whitelist"
                    notification.show(qsTrId("id-error-failed-to-get-regex-whitelist"))
                    return
                }

                items = items.concat(data.data)
            })
            break;

        case 2:
            items = []
            Api.requestGet("list=black", function (data, status) {
                page.busy = false
                if (status !== 200) {
                    //% "Failed to get blacklist"
                    notification.show(qsTrId("id-error-failed-to-get-blacklist"))
                    return
                }

                items = items.concat(data.data)
            })
            Api.requestGet("list=regex_black", function (data, status) {
                page.busy = false
                if (status !== 200) {
                    //% "Failed to get regex blacklist"
                    notification.show(qsTrId("id-error-failed-to-get-regex-blacklist"))
                    return
                }

                items = items.concat(data.data)
            })
            break;

        default:
            break;
        }
    }

    Component.onCompleted: refresh()
}
