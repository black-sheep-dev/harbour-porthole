#include "countermodel.h"

#include <QDebug>

CounterModel::CounterModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

CounterModel::~CounterModel()
{
    m_items.clear();
}

void CounterModel::setItems(const QJsonObject &obj)
{
    qDebug() << obj;

    beginResetModel();
    for (const auto &key : obj.keys()) {
        CounterItem item;

        item.name = key;
        item.count = obj.value(key).toInt();

        m_items.append(item);
    }
    endResetModel();
}

int CounterModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_items.count();
}

QVariant CounterModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto &item = m_items[index.row()];

    switch (role) {
    case NameRole:
        return item.name;

    case CountRole:
        return item.count;

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> CounterModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[NameRole]     = "name";
    roles[CountRole]    = "count";

    return roles;
}
