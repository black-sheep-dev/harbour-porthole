#include "porthole.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

#include <QFile>
#include <QJsonDocument>
#include <QJsonParseError>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QSettings>
#include <QStandardPaths>
#include <QUrlQuery>

#include "compressor.h"

Porthole::Porthole(QObject *parent) :
    QObject(parent)
{
    readSettings();

    connect(m_manager, &QNetworkAccessManager::finished, this, &Porthole::onRequestFinished);
}

Porthole::~Porthole()
{
    writeSettings();

    m_manager->deleteLater();
}

void Porthole::initialize()
{
    if (!m_url.isEmpty())
        sendRequest("versions");
}

void Porthole::reset()
{
    setAccessToken(QString());
    setUrl(QString());
    saveSettings();
}

void Porthole::saveSettings()
{
    writeSettings();
}

const QString &Porthole::accessToken() const
{
    return m_accessToken;
}

const QJsonObject &Porthole::summary() const
{
    return m_summary;
}

const QString &Porthole::url() const
{
    return m_url;
}

const QJsonObject &Porthole::versions() const
{
    return m_versions;
}

void Porthole::sendRequest(const QString &query, bool auth, const QVariant &info)
{
#ifdef QT_DEBUG
    qDebug() << "API REQUEST";
    qDebug() << query;
#endif

    if (query.isEmpty())
        return;

    QString url = m_url + QStringLiteral("/admin/api.php?") + query;

    if (auth && !m_accessToken.isEmpty())
        url += QStringLiteral("&auth=") + m_accessToken;

    QNetworkRequest request(url);
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Connection", "keep-alive");
    request.setRawHeader("Accept-Encoding", "gzip");
    request.setSslConfiguration(QSslConfiguration::defaultConfiguration());

    auto reply = m_manager->get(request);
    reply->setProperty("query", query);
    reply->setProperty("info", info);
}

void Porthole::sendPostRequest(const QString &query, const QJsonObject &data, const QVariant &info)
{
#ifdef QT_DEBUG
    qDebug() << "API POST REQUEST";
    qDebug() << query;
#endif

    if (query.isEmpty())
        return;

    QString url = m_url + QStringLiteral("/admin/api.php?") + query;

    url += QStringLiteral("&auth=") + m_accessToken;

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Connection", "keep-alive");
    request.setRawHeader("Accept-Encoding", "gzip");
    request.setSslConfiguration(QSslConfiguration::defaultConfiguration());

    QUrlQuery postData;
    for (const auto &key : data.keys()) {
        postData.addQueryItem(key, data.value(key).toString());
    }

#ifdef QT_DEBUG
    qDebug() << postData.toString(QUrl::FullyEncoded);
#endif

    auto reply = m_manager->post(request, postData.toString(QUrl::FullyEncoded).toUtf8());
    reply->setProperty("query", query);
    reply->setProperty("info", info);
}

void Porthole::setAccessToken(const QString &token)
{
    if (m_accessToken == token)
        return;

    m_accessToken = token;
    emit accessTokenChanged(m_accessToken);
}

void Porthole::setSummary(const QJsonObject &summary)
{
    if (m_summary == summary)
        return;

    m_summary = summary;
    emit summaryChanged(m_summary);
}

void Porthole::setUrl(const QString &url)
{
    if (m_url == url)
        return;

    m_url = url;
    emit urlChanged(m_url);
}

void Porthole::setVersions(const QJsonObject &versions)
{
    if (m_versions == versions)
        return;

    m_versions = versions;
    emit versionsChanged(m_versions);
}

void Porthole::onRequestFinished(QNetworkReply *reply)
{
#ifdef QT_DEBUG
    qDebug() << "API REPLY";
#endif

    const QString query = reply->property("query").toString();
    const QVariant info = reply->property("info");
    const int error = reply->error();

    // handel errors
    if (error) {
#ifdef QT_DEBUG
        qDebug() << reply->errorString();
#endif
        emit requestFailed(query, error, info);

        reply->deleteLater();
        return;
    }

    // read data
    const QByteArray data = Compressor::gunzip(reply->readAll());

    reply->deleteLater();

#ifdef QT_DEBUG
        qDebug() << data;
#endif

    // parse response
    QJsonParseError err{};

    const QJsonObject obj = QJsonDocument::fromJson(data, &err).object();

    if (err.error) {
#ifdef QT_DEBUG
        qDebug() << "JSON PARSE ERROR";
        qDebug() << err.errorString();
#endif
        emit requestFailed(query, error, info);
        return;
    }

    if (query == QLatin1String("summaryRaw")) {
        setSummary(obj);
    } else if (query == QLatin1String("versions")) {
        setVersions(obj);
    }

    emit requestFinished(query, obj, info);
}

void Porthole::readSettings()
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/org.nubecula/Porthole/porthole.conf";

    if (!QFile(path).exists()) {
           path = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/harbour-porthole/harbour-porthole.conf";
    }

    QSettings settings(path, QSettings::NativeFormat);

    settings.beginGroup(QStringLiteral("APP"));
    setUrl(settings.value(QStringLiteral("url")).toString());
    setAccessToken(settings.value(QStringLiteral("token")).toString());

    settings.endGroup();
}

void Porthole::writeSettings()
{
    QSettings settings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/org.nubecula/Porthole/porthole.conf", QSettings::NativeFormat);

    settings.beginGroup(QStringLiteral("APP"));
    settings.setValue(QStringLiteral("url"), m_url);
    settings.setValue(QStringLiteral("token"), m_url);

    settings.endGroup();
}
