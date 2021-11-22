#ifndef PORTHOLE_H
#define PORTHOLE_H

#include <QObject>

#include <QJsonObject>
#include <QNetworkAccessManager>

#include <Sailfish/Secrets/secretmanager.h>

#include "tools/compress.h"

class Porthole : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString accessToken READ accessToken WRITE setAccessToken NOTIFY accessTokenChanged)
    Q_PROPERTY(QJsonObject summary READ summary WRITE setSummary NOTIFY summaryChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QJsonObject versions READ versions WRITE setVersions NOTIFY versionsChanged)

public:
    explicit Porthole(QObject *parent = nullptr);
    ~Porthole() override;

    Q_INVOKABLE void initialize();
    Q_INVOKABLE void reset();
    Q_INVOKABLE void saveSettings();

    // properties
    const QString &accessToken() const;
    const QJsonObject &summary() const;
    const QString &url() const;
    const QJsonObject &versions() const;

signals:
    void requestFailed(const QString &query, int error, const QVariant &info = QVariant());
    void requestFinished(const QString &query, const QJsonObject &data, const QVariant &info = QVariant());

    // properties
    void accessTokenChanged(const QString &token);
    void summaryChanged(const QJsonObject &summary);
    void urlChanged(const QString &url);   
    void versionsChanged(const QJsonObject &versions);

public slots:
    void sendRequest(const QString &query, bool auth = false, const QVariant &info = QVariant());
    void sendPostRequest(const QString &query, const QJsonObject &data = QJsonObject(), const QVariant &info = QVariant());

    // properties
    void setAccessToken(const QString &token);
    void setSummary(const QJsonObject &summary);
    void setUrl(const QString &url);   
    void setVersions(const QJsonObject &versions);

private slots:
    void onRequestFinished(QNetworkReply *reply);

private:
    // sailfish secrets
    void createCollection();
    void deleteCollection();
    void loadCredentials();
    void storeCredentials();

    // settings
    void readSettings();
    void writeSettings();

    QNetworkAccessManager *m_manager{new QNetworkAccessManager};
    Sailfish::Secrets::SecretManager m_secretManager;
    Sailfish::Secrets::Secret::Identifier m_secretsIdentifier;

    // properties
    QString m_accessToken;
    QJsonObject m_summary;
    QString m_url;
    QJsonObject m_versions;
};

#endif // PORTHOLE_H
