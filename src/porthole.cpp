#include "porthole.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

#include <QJsonDocument>
#include <QJsonParseError>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QSettings>

#include <Sailfish/Secrets/createcollectionrequest.h>
#include <Sailfish/Secrets/deletecollectionrequest.h>
#include <Sailfish/Secrets/deletesecretrequest.h>
#include <Sailfish/Secrets/storesecretrequest.h>
#include <Sailfish/Secrets/storedsecretrequest.h>

const QString PORTHOLE_COLLECTION_NAME            = QStringLiteral("porthole");
const QString PORTHOLE_COLLECTION_NAME_DEBUG      = QStringLiteral("portholedebug");

Porthole::Porthole(QObject *parent) :
    QObject(parent),
    m_secretsIdentifier(Sailfish::Secrets::Secret::Identifier(
                                QStringLiteral("secrets"),
                                #ifdef QT_DEBUG
                                    PORTHOLE_COLLECTION_NAME_DEBUG,
                                #else
                                    PORTHOLE_COLLECTION_NAME,
                                #endif
                                Sailfish::Secrets::SecretManager::DefaultEncryptedStoragePluginName))
{
    readSettings();
    loadCredentials();

    connect(m_manager, &QNetworkAccessManager::finished, this, &Porthole::onRequestFinished);
}

Porthole::~Porthole()
{
    writeSettings();

    m_manager->deleteLater();
}

void Porthole::initialize()
{

}

void Porthole::reset()
{
    setAccessToken(QString());
    setUrl(QString());
    saveSettings();
    deleteCollection();
}

void Porthole::saveSettings()
{
    writeSettings();
    storeCredentials();
}

QString Porthole::accessToken() const
{
    return m_accessToken;
}

QString Porthole::url() const
{
    return m_url;
}

void Porthole::sendRequest(const QString &query, bool auth)
{
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
}

void Porthole::setAccessToken(const QString &token)
{
    if (m_accessToken == token)
        return;

    m_accessToken = token;
    emit accessTokenChanged(m_accessToken);
}

void Porthole::setUrl(const QString &url)
{
    if (m_url == url)
        return;

    m_url = url;
    emit urlChanged(m_url);
}

void Porthole::onRequestFinished(QNetworkReply *reply)
{
#ifdef QT_DEBUG
    qDebug() << "API REPLY";
#endif

    const QString query = reply->property("query").toString();

    // handel errors
    if (reply->error()) {
#ifdef QT_DEBUG
        qDebug() << reply->errorString();
#endif
        emit requestFailed(query);

        reply->deleteLater();
        return;
    }

    // read data
    const QByteArray raw = reply->readAll();
    QByteArray data = Compress::gunzip(raw);

    if (data.isEmpty())
        data = raw;

    reply->deleteLater();

#ifdef QT_DEBUG
        qDebug() << data;
#endif

    // parse response
    QJsonParseError error{};

    const QJsonObject obj = QJsonDocument::fromJson(data, &error).object();

    if (error.error) {
#ifdef QT_DEBUG
        qDebug() << "JSON PARSE ERROR";
        qDebug() << error.errorString();
#endif
        return;
    }

    emit requestFinished(query, obj);
}

void Porthole::createCollection()
{
#ifndef DISABLE_SAILFISH_SECRETS

    Sailfish::Secrets::CreateCollectionRequest createCollection;
    createCollection.setManager(&m_secretManager);
    createCollection.setCollectionLockType(Sailfish::Secrets::CreateCollectionRequest::DeviceLock);
    createCollection.setDeviceLockUnlockSemantic(Sailfish::Secrets::SecretManager::DeviceLockKeepUnlocked);
    createCollection.setUserInteractionMode(Sailfish::Secrets::SecretManager::SystemInteraction);
    createCollection.setCollectionName(
                                   #ifdef QT_DEBUG
                                       PORTHOLE_COLLECTION_NAME_DEBUG
                                   #else
                                       PORTHOLE_COLLECTION_NAME
                                   #endif
                                       );
    createCollection.setStoragePluginName(Sailfish::Secrets::SecretManager::DefaultEncryptedStoragePluginName);
    createCollection.setEncryptionPluginName(Sailfish::Secrets::SecretManager::DefaultEncryptedStoragePluginName);
    createCollection.startRequest();
    createCollection.waitForFinished();

#ifdef QT_DEBUG
    qDebug() << createCollection.result().code();
    qDebug() << createCollection.result().errorMessage();
#endif

#endif
}

void Porthole::deleteCollection()
{
#ifndef DISABLE_SAILFISH_SECRETS

    Sailfish::Secrets::DeleteCollectionRequest deleteCollection;
    deleteCollection.setManager(&m_secretManager);
    deleteCollection.setCollectionName(
                    #ifdef QT_DEBUG
                        PORTHOLE_COLLECTION_NAME_DEBUG
                    #else
                        PORTHOLE_COLLECTION_NAME
                    #endif
                );
    deleteCollection.setStoragePluginName(Sailfish::Secrets::SecretManager::DefaultEncryptedStoragePluginName);
    deleteCollection.setUserInteractionMode(Sailfish::Secrets::SecretManager::SystemInteraction);
    deleteCollection.startRequest();
    deleteCollection.waitForFinished();


#ifdef QT_DEBUG
    qDebug() << deleteCollection.result().code();
    qDebug() << deleteCollection.result().errorMessage();
#endif

#endif
}

void Porthole::loadCredentials()
{
#ifndef DISABLE_SAILFISH_SECRETS
    auto fetchCode = new Sailfish::Secrets::StoredSecretRequest;

    fetchCode->setManager(&m_secretManager);
    fetchCode->setUserInteractionMode(Sailfish::Secrets::SecretManager::SystemInteraction);
    fetchCode->setIdentifier(m_secretsIdentifier);

    fetchCode->startRequest();
    fetchCode->waitForFinished();

#ifdef QT_DEBUG
    qDebug() << QStringLiteral("CREDENTIALS LOADED");
    qDebug() << fetchCode->result().code();
    qDebug() << fetchCode->secret().data();

    if (fetchCode->result().errorCode() > 0) {
        qDebug() << fetchCode->result().errorCode();
        qDebug() << fetchCode->result().errorMessage();
    }
#endif

    if (fetchCode->result().code() != Sailfish::Secrets::Result::Succeeded) {
        fetchCode->deleteLater();
        return;
    }

    setAccessToken(fetchCode->secret().data());

    fetchCode->deleteLater();

#endif
}

void Porthole::storeCredentials()
{
#ifndef DISABLE_SAILFISH_SECRETS

    if (m_accessToken.isEmpty())
        return;

    // reset and create
    deleteCollection();
    createCollection();

    // store data in wallet
    Sailfish::Secrets::Secret secret(m_secretsIdentifier);
    secret.setData(m_accessToken.toUtf8());

    Sailfish::Secrets::StoreSecretRequest storeCode;
    storeCode.setManager(&m_secretManager);
    storeCode.setSecretStorageType(Sailfish::Secrets::StoreSecretRequest::CollectionSecret);
    storeCode.setUserInteractionMode(Sailfish::Secrets::SecretManager::SystemInteraction);
    storeCode.setSecret(secret);
    storeCode.startRequest();
    storeCode.waitForFinished();

    if (storeCode.result().errorCode())
        return;

    #ifdef QT_DEBUG
        qDebug() << storeCode.result().code();
        qDebug() << storeCode.result().errorMessage();
    #endif

#endif
}

void Porthole::readSettings()
{
    QSettings settings;

    settings.beginGroup(QStringLiteral("APP"));
    setUrl(settings.value(QStringLiteral("url")).toString());

#ifdef DISABLE_SAILFISH_SECRETS
    setAccessToken(settings.value(QStringLiteral("token")).toString());
#endif
    settings.endGroup();
}

void Porthole::writeSettings()
{
    QSettings settings;

    settings.beginGroup(QStringLiteral("APP"));
    settings.setValue(QStringLiteral("url"), m_url);

#ifdef DISABLE_SAILFISH_SECRETS
    settings.setValue(QStringLiteral("token"), m_accessToken);
#endif
    settings.endGroup();
}
