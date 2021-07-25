import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

Page {
    property alias enabled: statusSwitch.checked

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh()
            }
        }


        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Dashboard")
            }

            TextSwitch {
                id: statusSwitch
                text: qsTr("Ad blocking")
                description: qsTr("Enable / disable ad blocking")

                onClicked: Porthole.sendRequest(checked ? "enable" : "disable", true)
            }

            SectionHeader {
                text: qsTr("Today Statistics")
            }

            DetailItem {
                id: totalQueries
                label: qsTr("Total Queries")
            }

            DetailItem {
                id: blockedQueries
                label: qsTr("Queries Blocked")
            }

            DetailItem {
                id: domainsOnBlocklist
                label: qsTr("Domains on Blocklist")
            }

            SectionHeader {
                text: qsTr("Percent Blocked")
            }

            ProgressCircle {
                id: blockedPercent
                anchors.horizontalCenter:  parent.horizontalCenter
                width: Math.min(page.width, page.height) * 0.4

                height: width
                borderWidth: Theme.fontSizeMedium

                Label {
                    id: percentLabel
                    anchors.centerIn: parent
                }
            }
        }
    }

    function refresh() {
        Porthole.sendRequest("summaryRaw")
    }

    function startSetupWizard() {
        pageStack.clear()
        pageStack.push(Qt.resolvedUrl("wizard/WizardIntroPage.qml"))
    }

    Component.onCompleted: refresh()

    onStatusChanged: {
        if (status !== PageStatus.Active) return

        if (Porthole.accessToken.length === 0 || Porthole.url === 0) startSetupWizard()
    }

    Connections {
        target: Porthole
        onRequestFinished: {
           if (query === "enable" || query === "disable") enabled = (data.status === "enabled")

           if (query === "summaryRaw") {
               enabled = (data.status === "enabled")

               totalQueries.value = data.dns_queries_today
               blockedQueries.value = data.ads_blocked_today
               domainsOnBlocklist.value = data.domains_being_blocked

               blockedPercent.progressValue = data.ads_percentage_today / 100
               percentLabel.text = Number(data.ads_percentage_today).toLocaleString(Qt.locale()) + " %"
           }
        }
    }
}
