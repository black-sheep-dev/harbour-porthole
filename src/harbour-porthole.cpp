#include <QtQuick>

#include <sailfishapp.h>
#include <QCoreApplication>

#include "porthole.h"
#include "models/countermodel.h"
#include "models/sortmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationVersion(APP_VERSION);
    QCoreApplication::setOrganizationName(QStringLiteral("nubecula.org"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("nubecula.org"));

#ifdef QT_DEBUG
    #define uri "org.nubecula.harbour.porthole"
#else
    const auto uri = "org.nubecula.harbour.porthole";
#endif

    qmlRegisterType<CounterModel>(uri, 1, 0, "CounterModel");
    qmlRegisterType<SortModel>(uri, 1, 0, "SortModel");

    qmlRegisterSingletonType<Porthole>(uri,
                                              1,
                                              0,
                                              "Porthole",
                                              [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {

        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        auto app = new Porthole();

        return app;
    });

    return SailfishApp::main(argc, argv);
}
