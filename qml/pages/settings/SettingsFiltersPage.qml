import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Page {
    property bool busy: false
    property int type: 1

    id: page

    allowedOrientations: Orientation.All

    PageBusyIndicator {
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
        running: busy
    }

    SilicaFlickable {
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

                        Porthole.sendPostRequest(query,
                                                 {
                                                     type: type,
                                                     comment: dialog.comment
                                                 },
                                                 -1)
                    })
                }
            }
            MenuItem {
                //% "Refresh"
                text: qsTrId("id-refresh")
                onClicked: refresh()
            }
            MenuItem {
                text: listView.showSearch ?
                          //% "Hide Search"
                          qsTrId("id-hide-search") :
                          //% "Search"
                          qsTrId("id-search")
                onClicked: listView.showSearch = !listView.showSearch
            }
        }

        anchors.fill: parent

        Column {
            id: headerColumn
            width: parent.width

            PageHeader {
                title: type === 1 ?
                           //% "Whitelist"
                           qsTrId("id-whitelist") :
                           //% "Blacklist"
                           qsTrId("id-blacklist")
            }

            SearchField {
                id: searchField
                width: parent.width
                height: listView.showSearch ? implicitHeight : 0
                opacity: listView.showSearch ? 1 : 0
                inputMethodHints: Qt.ImhPreferLowercase
                onTextChanged: {
                    sortModel.setFilterFixedString(text)
                }

                EnterKey.onClicked: focus = false

                Connections {
                    target: listView
                    onShowSearchChanged: {
                        searchField.forceActiveFocus()
                    }
                }

                Behavior on height {
                    NumberAnimation { duration: 300 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
        }

        SilicaListView {
            property bool showSearch: false

            id: listView

            anchors.top: headerColumn.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            clip: true

            model: SortModel {
                id: sortModel
                filterRole: FilterListModel.DomainRole
                filterCaseSensitivity: Qt.CaseInsensitive
                sortRole: FilterListModel.DomainRole
                sortCaseSensitivity: Qt.CaseInsensitive
                sourceModel: FilterListModel {
                    id: filterModel
                }
            }

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

                            switch (model.type) {
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

                            Porthole.sendRequest("list=" + list + "&sub=" + model.domain, true, model.id)
                        })
                    }
//                    MenuItem {
//                        text: model.enabled ? qsTr("Disable") : qsTr("Enable")
//                        delegate.remorseAction(qsTr(model.enabled ? qsTr("Disable filter") : qsTr("Enable filter")), function() { })
//                    }
                }

                Row {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2 * x
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.paddingMedium

                    Image {
                        id: itemIcon
                        source: model.enabled ? "image://theme/icon-m-acknowledge" : "image://theme/icon-m-clear"
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
                            text: model.domain
                            color: pressed ? Theme.secondaryHighlightColor:Theme.highlightColor
                            font.pixelSize: Theme.fontSizeMedium
                        }
                        Label {
                            text: model.comment
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
    }

    function refresh() {
        filterModel.reset()

        page.busy = true

        switch (page.type) {
        case 1:
            Porthole.sendRequest("list=white", true)
            Porthole.sendRequest("list=regex_white", true)
            break;

        case 2:
            Porthole.sendRequest("list=black", true)
            Porthole.sendRequest("list=regex_black", true)
            break;

        default:
            break;
        }
    }

    Connections {
        target: Porthole
        onRequestFailed: {
            if (query.indexOf("add=") >= 0) {
                //% "Failed to add filter"
                notification.show(qsTrId("id-add-filter-failed"))
                return
            }

            if (query.indexOf("sub=") >= 0) {
                //% "Failed to delete filter"
                notification.show(qsTrId("id-del-filter-failed"))
                return
            }

            if (page.type === 1 && (query.indexOf("list=white") >= 0 || query.indexOf("list=regex_white") >= 0)) {
                page.busy = false
            } else if (page.type === 2 && (query.indexOf("list=black") >= 0 || query.indexOf("list=regex_black") >= 0)) {
                page.busy = false
            }
        }
        onRequestFinished: {
            if (query.indexOf("add=") >= 0) {
                if (data.success) refresh()
                return
            }

            if (query.indexOf("sub=") >= 0) {
                if (data.success) filterModel.removeItem(info)
                return
            }

            if (page.type === 1 && (query.indexOf("list=white") >= 0 || query.indexOf("list=regex_white") >= 0)) {
                filterModel.addItems(data)
                sortModel.sortModel(Qt.AscendingOrder)
                page.busy = false
            } else if (page.type === 2 && (query.indexOf("list=black") >= 0 || query.indexOf("list=regex_black") >= 0)) {
                filterModel.addItems(data)
                sortModel.sortModel(Qt.AscendingOrder)
                page.busy = false
            }
        }
    }

    Component.onCompleted: refresh()
}
