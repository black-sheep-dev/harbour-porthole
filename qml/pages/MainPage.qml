import QtQuick 2.0
import Sailfish.Silica 1.0

import "../."

Page {
    property alias enabled: statusSwitch.checked

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                //% "About"
                text: qsTrId("id-about")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                //% "Settings"
                text: qsTrId("id-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }

            MenuItem {
                //% "Analysis"
                text: qsTrId("id-analysis")
                onClicked: pageStack.push(Qt.resolvedUrl("AnalysisPage.qml"))
            }

            MenuItem {
                //% "Refresh"
                text: qsTrId("id-refresh")
                onClicked: app.refresh()
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

                checked: filterEnabled

                onClicked: app.toggleFilter()
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
                progressValue: summary.ads_percentage_today / 100

                Label {
                    id: percentLabel
                    anchors.centerIn: parent
                    text: Number(summary.ads_percentage_today).toLocaleString(Qt.locale()) + " %"
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
                value: summary.unique_clients
            }

            DetailItem {
                id: totalQueries
                //%  "Total Queries"
                label: qsTrId("id-total-queries")
                value: summary.dns_queries_today
            }

            DetailItem {
                id: blockedQueries
                //%  "Queries Blocked"
                label: qsTrId("id-queries-blocked")
                value: summary.ads_blocked_today
            }

            DetailItem {
                id: domainsOnBlocklist
                //%  "Domains on Blocklist"
                label: qsTrId("id-domains-on-blocklist")
                value: summary.domains_being_blocked
            }           
        }
    }

    Component.onCompleted: app.refresh()
}
