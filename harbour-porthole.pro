# The name of your application
TARGET = harbour-porthole

CONFIG += sailfishapp_qml
PKGCONFIG += nemonotifications-qt5

DISTFILES += qml/harbour-porthole.qml \
    qml/qmldir \
    qml/api.qml \
    qml/global.qml \
    qml/cover/CoverPage.qml \
    qml/dialogs/EditFilterDialog.qml \
    qml/pages/AboutPage.qml \
    qml/pages/AnalysisPage.qml \
    qml/pages/CounterListPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/settings/SettingsConnectionPage.qml \
    qml/pages/settings/SettingsFiltersPage.qml \
    qml/pages/settings/SettingsPage.qml \
    qml/pages/settings/SettingsServerInfoPage.qml \
    qml/pages/wizard/WizardConnectionPage.qml \
    qml/pages/wizard/WizardFinalPage.qml \
    qml/pages/wizard/WizardIntroPage.qml \
    qml/pages/wizard/WizardTokenPage.qml \
    rpm/harbour-porthole.changes \
    rpm/harbour-porthole.changes.run.in \
    rpm/harbour-porthole.spec \
    rpm/harbour-porthole.yaml \
    translations/*.ts \
    harbour-porthole.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 512x512

include(translations/translations.pri)

icons.files = icons/*.svg
icons.path = $$INSTALL_ROOT/usr/share/harbour-porthole/icons

images.files = images/*.svg
images.path = $$INSTALL_ROOT/usr/share/harbour-porthole/images

INSTALLS += icons images
