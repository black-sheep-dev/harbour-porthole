import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

import org.nubecula.harbour.porthole 1.0

ApplicationWindow {
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: Porthole.initialize()
}
