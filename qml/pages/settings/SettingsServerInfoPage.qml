import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.porthole 1.0

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
                value: Porthole.summary.gravity_last_updated.file_exists ?
                           //% "yes"
                           qsTrId("id-yes") :
                           //% "no"
                           qsTrId("id-no")
            }

            DetailItem {
                //% "Last update"
                label: qsTrId("id-last-update")
                value: new Date(Porthole.summary.gravity_last_updated.absolute * 1000).toLocaleString()
            }

            DetailItem {
                //% "Timespan"
                label: qsTrId("id-timespan")
                //% "%n day(s)"
                value: qsTrId("id-n-days", "0", Porthole.summary.gravity_last_updated.relative.days)
                        + "\n"
                        //% "%n hour(s)"
                        + qsTrId("id-n-hours", "0", Porthole.summary.gravity_last_updated.relative.hours )
                        + "\n"
                        //% "%n minute(s)"
                        + qsTrId("id-n-minutes", "0", Porthole.summary.gravity_last_updated.relative.minutes)
            }

            SectionHeader {
                //% "Software Versions"
                text: qsTrId("id-software-version")
            }

            DetailItem {
                //% "Core"
                label: qsTrId("id-core")
                value: Porthole.versions.core_current //+ Porthole.versions.core_update ? (" (" + Porthole.versions.core_latest + ")") : ""
            }

            DetailItem {
                //% "Web"
                label: qsTrId("id-web")
                value: Porthole.versions.web_current //+ Porthole.versions.web_update ? (" (" + Porthole.versions.web_latest + ")") : ""
            }

            DetailItem {
                //% "FTL"
                label: qsTrId("id-ftl")
                value: Porthole.versions.FTL_current //+ Porthole.versions.FTL_update ? (" (" + Porthole.versions.FTL_latest + ")") : ""
            }

        }
    }
}
