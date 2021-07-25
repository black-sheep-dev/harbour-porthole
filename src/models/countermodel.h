#ifndef COUNTERMODEL_H
#define COUNTERMODEL_H

#include <QAbstractListModel>

#include <QJsonObject>

struct CounterItem {
    QString name;
    int count;
};

class CounterModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum CounterItemRoles {
        NameRole            = Qt::UserRole + 1,
        CountRole
    };
    Q_ENUM(CounterItemRoles)

    explicit CounterModel(QObject *parent = nullptr);
    ~CounterModel() override;

public slots:
    void setItems(const QJsonObject &obj);

private:
    QList<CounterItem> m_items;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

};

#endif // COUNTERMODEL_H
