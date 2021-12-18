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
                //% "Settings"
                text: qsTrId("id-settings")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }

            MenuItem {
                //% "Analysis"
                text: qsTrId("id-analysis")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("AnalysisPage.qml"))
            }

            MenuItem {
                //% "Refresh"
                text: qsTrId("id-refresh")
                onClicked: refresh()
            }
        }


        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                //% "Dashboard"
                title: qsTrId("id-dashboard")
            }

            TextSwitch {
                id: statusSwitch

                //% "Ad blocking"
                text: qsTrId("id-ad-blocking")
                //% "Enable / disable ad blocking"
                description: qsTrId("id-toggle-blocking")

                onClicked: Porthole.sendRequest(checked ? "enable" : "disable", true)
            }

            SectionHeader {
                //% "Percent Blocked"
                text: qsTrId("id-percent-blocked")
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
                //% "Today Statistics"
                text: qsTrId("id-today-statistics")
            }

            DetailItem {
                id: totalClients
                //% "Total Clients"
                label: qsTrId("id-total-clients")
                value: Porthole.summary.unique_clients
            }

            DetailItem {
                id: totalQueries
                //%  "Total Queries"
                label: qsTrId("id-total-queries")
                value: Porthole.summary.dns_queries_today
            }

            DetailItem {
                id: blockedQueries
                //%  "Queries Blocked"
                label: qsTrId("id-queries-blocked")
                value: Porthole.summary.ads_blocked_today
            }

            DetailItem {
                id: domainsOnBlocklist
                //%  "Domains on Blocklist"
                label: qsTrId("id-domains-on-blocklist")
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
