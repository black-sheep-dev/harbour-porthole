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
                title: qsTr("Server Info")
            }

            SectionHeader {
                text: qsTr("Gravity")
            }

            DetailItem {
                label: qsTr("File exists")
                value: Porthole.summary.gravity_last_updated.file_exists ? qsTr("yes") : qsTr("no")
            }

            DetailItem {
                label: qsTr("Last update")
                value: new Date(Porthole.summary.gravity_last_updated.absolute * 1000).toLocaleString()
            }

            DetailItem {
                label: qsTr("Timespan")
                value: qsTr("%n day(s)", "0", Porthole.summary.gravity_last_updated.relative.days)
                        + "\n"
                        + qsTr("%n hour(s)", "0", Porthole.summary.gravity_last_updated.relative.hours )
                        + "\n"
                        + qsTr("%n minute(s)", "0", Porthole.summary.gravity_last_updated.relative.minutes)
            }

            SectionHeader {
                text: qsTr("Software Versions")
            }

            DetailItem {
                label: qsTr("Core")
                value: Porthole.versions.core_current //+ Porthole.versions.core_update ? (" (" + Porthole.versions.core_latest + ")") : ""
            }

            DetailItem {
                label: qsTr("Web")
                value: Porthole.versions.web_current //+ Porthole.versions.web_update ? (" (" + Porthole.versions.web_latest + ")") : ""
            }

            DetailItem {
                label: qsTr("FTL")
                value: Porthole.versions.FTL_current //+ Porthole.versions.FTL_update ? (" (" + Porthole.versions.FTL_latest + ")") : ""
            }

        }
    }
}
