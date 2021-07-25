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
VERSION = 0.1.0
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# The name of your application
TARGET = harbour-porthole
DEFINES += APP_TARGET=\\\"$$TARGET\\\"

# custom defines
#DEFINES += DISABLE_SAILFISH_SECRETS

QT += dbus

CONFIG += link_pkgconfig sailfishapp
PKGCONFIG += sailfishsecrets

LIBS += -lz

SOURCES += src/harbour-porthole.cpp \
    src/porthole.cpp \
    src/tools/compress.cpp

DISTFILES += qml/harbour-porthole.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingsConnectionPage.qml \
    qml/pages/SettingsPage.qml \
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
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-porthole-de.ts

RESOURCES += \
    ressources.qrc

HEADERS += \
    src/porthole.h \
    src/tools/compress.h
