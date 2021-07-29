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
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }

            MenuItem {
                text: qsTr("Analysis")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("AnalysisPage.qml"))
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
                text: qsTr("Percent Blocked")
            }

            ProgressCircle {
                id: blockedPercent
                anchors.horizontalCenter:  parent.horizontalCenter
                width: Math.min(page.width, page.height) * 0.3

                height: width
                borderWidth: Theme.fontSizeMedium
                progressValue: Porthole.summary.ads_percentage_today / 100

                Label {
                    id: percentLabel
                    anchors.centerIn: parent
                    text: Number(Porthole.summary.ads_percentage_today).toLocaleString(Qt.locale()) + " %"
                }
            }

            SectionHeader {
                text: qsTr("Today Statistics")
            }

            DetailItem {
                id: totalClients
                label: qsTr("Total Clients")
                value: Porthole.summary.unique_clients
            }

            DetailItem {
                id: totalQueries
                label: qsTr("Total Queries")
                value: Porthole.summary.dns_queries_today
            }

            DetailItem {
                id: blockedQueries
                label: qsTr("Queries Blocked")
                value: Porthole.summary.ads_blocked_today
            }

            DetailItem {
                id: domainsOnBlocklist
                label: qsTr("Domains on Blocklist")
                value: Porthole.summary.domains_being_blocked
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
        onRequestFinished: if (query === "enable" || query === "disable" || query === "summaryRaw") enabled = (data.status === "enabled")
    }
}
