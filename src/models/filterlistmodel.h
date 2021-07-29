#ifndef FILTERLISTMODEL_H
#define FILTERLISTMODEL_H

#include <QAbstractListModel>

#include <QDateTime>
#include <QJsonArray>
#include <QJsonObject>

struct FilterItem {
    quint32 id{0};
    quint8 type{0};
    QString domain;
    bool enabled{false};
    QDateTime dateAdded;
    QDateTime dateModified;
    QString commment;
};

class FilterListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum FilterItemRoles {
        IdRole              = Qt::UserRole + 1,
        TypeRole,
        DomainRole,
        EnabledRole,
        DateAddedRole,
        DateModifiedRole,
        CommentRole
    };
    Q_ENUM(FilterItemRoles)

    explicit FilterListModel(QObject *parent = nullptr);
    ~FilterListModel() override;

public slots:
    void addItems(const QJsonObject &data);
    void removeItem(quint32 id);
    void setItems(const QJsonObject &data);
    void reset();

private:
    QList<FilterItem> getItems(const QJsonArray &items);

    QList<FilterItem> m_items;


    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // FILTERLISTMODEL_H
