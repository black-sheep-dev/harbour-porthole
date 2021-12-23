#include <QtQuick>

#include <sailfishapp.h>
#include <QCoreApplication>

#include "porthole.h"
#include "models/countermodel.h"
#include "models/filterlistmodel.h"
#include "models/sortmodel.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setApplicationVersion(APP_VERSION);
    app->setApplicationName("Porthole");
    app->setOrganizationDomain("org.nubecula");
    app->setOrganizationName("org.nubecula");

    QScopedPointer<QQuickView> v(SailfishApp::createView());
    auto context = v.data()->rootContext();

#ifdef QT_DEBUG
    #define uri "org.nubecula.harbour.porthole"
#else
    const auto uri = "org.nubecula.harbour.porthole";
#endif

    qmlRegisterType<CounterModel>(uri, 1, 0, "CounterModel");
    qmlRegisterType<FilterListModel>(uri, 1, 0, "FilterListModel");
    qmlRegisterType<SortModel>(uri, 1, 0, "SortModel");

//    qmlRegisterSingletonType<Porthole>(uri,
//                                       1,
//                                       0,
//                                       "Porthole",
//                                       [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {

//        Q_UNUSED(engine)
//        Q_UNUSED(scriptEngine)

//        auto app = new Porthole(nullptr);

//        return app;
//    });

    auto porthole = new Porthole;
    context->setContextProperty("Porthole", porthole);

    v->setSource(SailfishApp::pathTo("qml/harbour-porthole.qml"));
    v->show();

    return app->exec();
}
