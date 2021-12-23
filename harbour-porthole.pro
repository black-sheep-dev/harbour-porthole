# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# VERSION
VERSION = 0.2.1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# The name of your application
TARGET = harbour-porthole
DEFINES += APP_TARGET=\\\"$$TARGET\\\"

QT += dbus

CONFIG += link_pkgconfig sailfishapp
PKGCONFIG += nemonotifications-qt5

SOURCES += src/harbour-porthole.cpp \
    src/models/countermodel.cpp \
    src/models/filterlistmodel.cpp \
    src/models/sortmodel.cpp \
    src/porthole.cpp

DISTFILES += qml/harbour-porthole.qml \
    qml/cover/CoverPage.qml \
    qml/dialogs/EditFilterDialog.qml \
    qml/pages/AnalysisPage.qml \
    qml/pages/CounterListPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingsConnectionPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/settings/SettingsFiltersPage.qml \
    qml/pages/settings/SettingsServerInfoPage.qml \
    qml/pages/wizard/WizardConnectionPage.qml \
    rpm/harbour-porthole.changes \
    rpm/harbour-porthole.changes.run.in \
    rpm/harbour-porthole.spec \
    rpm/harbour-porthole.yaml \
    translations/*.ts \
    harbour-porthole.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 512x512

# to disable building translations every time, comment out the
# following CONFIG line

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
include(translations/translations.pri)

RESOURCES += \
    ressources.qrc

HEADERS += \
    src/models/countermodel.h \
    src/models/filterlistmodel.h \
    src/models/sortmodel.h \
    src/porthole.h

include(secret.pri)
include(extern/sailfishos-utils/compressor/compressor.pri)
include(extern/sailfishos-utils/crypto/crypto.pri)
