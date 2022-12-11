import QtQuick 2.0
import Sailfish.Silica 1.0

import "../../."

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium

            PageHeader {
                //% "Server Info"
                title: qsTrId("id-server-info")
            }

            SectionHeader {
                //% "Gravity"
                text: qsTrId("id-gravity")
            }

            DetailItem {
                //% "File exists"
                label: qsTrId("id-file-exists")
                value: summary.gravity_last_updated.file_exists ?
                           //% "yes"
                           qsTrId("id-yes") :
                           //% "no"
                           qsTrId("id-no")
            }

            DetailItem {
                //% "Last update"
                label: qsTrId("id-last-update")
                value: new Date(summary.gravity_last_updated.absolute * 1000).toLocaleString()
            }

            DetailItem {
                //% "Timespan"
                label: qsTrId("id-timespan")
                //% "%n day(s)"
                value: qsTrId("id-n-days", summary.gravity_last_updated.relative.days)
                        + "\n"
                        //% "%n hour(s)"
                        + qsTrId("id-n-hours", summary.gravity_last_updated.relative.hours )
                        + "\n"
                        //% "%n minute(s)"
                        + qsTrId("id-n-minutes", summary.gravity_last_updated.relative.minutes)
            }

            SectionHeader {
                //% "Software Versions"
                text: qsTrId("id-software-version")
            }

            DetailItem {
                //% "Core"
                label: qsTrId("id-core")
                value: versions.core_current
            }

            DetailItem {
                //% "Web"
                label: qsTrId("id-web")
                value: versions.web_current
            }

            DetailItem {
                //% "FTL"
                label: qsTrId("id-ftl")
                value: versions.FTL_current
            }

        }
    }

    Component.onCompleted: app.getVersions()
}
