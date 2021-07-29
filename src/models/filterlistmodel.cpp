#include "filterlistmodel.h"

FilterListModel::FilterListModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

FilterListModel::~FilterListModel()
{
    m_items.clear();
}

void FilterListModel::addItems(const QJsonObject &data)
{
    QList<FilterItem> items = getItems(data.value("data").toArray());

    if (items.isEmpty())
        return;

    beginInsertRows(QModelIndex(), m_items.count(), m_items.count() + items.count() - 1);
    m_items.append(items);
    endInsertRows();
}

void FilterListModel::removeItem(quint32 id)
{
    int index{-1};

    for (int i = 0; i < m_items.count(); ++i) {
        if (m_items[i].id != id)
            continue;

        index = i;
        break;
    }

    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    endRemoveRows();
}

void FilterListModel::setItems(const QJsonObject &data)
{
    beginResetModel();
    m_items.clear();
    m_items = getItems(data.value("data").toArray());
    endResetModel();
}

void FilterListModel::reset()
{
    beginResetModel();
    m_items.clear();
    endResetModel();
}

QList<FilterItem> FilterListModel::getItems(const QJsonArray &items)
{
    QList<FilterItem> list;

    for (const auto &v : items) {
        const auto obj = v.toObject();

        if (obj.isEmpty())
            continue;

        FilterItem item;
        item.id = obj.value("id").toInt();
        item.type = obj.value("type").toInt();
        item.domain = obj.value("domain").toString();
        item.enabled = obj.value("enabled").toInt();
        item.dateAdded = QDateTime::fromTime_t(obj.value("date_added").toInt());
        item.dateModified = QDateTime::fromTime_t(obj.value("date_modified").toInt());
        item.commment = obj.value("comment").toString();

        list.append(item);
    }

    return list;
}

int FilterListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_items.count();
}

QVariant FilterListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto &item = m_items[index.row()];

    switch (role) {
    case IdRole:
        return item.id;

    case TypeRole:
        return item.type;

    case DomainRole:
        return item.domain;

    case EnabledRole:
        return item.enabled;

    case DateAddedRole:
        return item.dateAdded;

    case DateModifiedRole:
        return item.dateModified;

    case CommentRole:
        return item.commment;

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> FilterListModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[IdRole]               = "id";
    roles[TypeRole]             = "type";
    roles[DomainRole]           = "domain";
    roles[EnabledRole]          = "enabled";
    roles[DateAddedRole]        = "dateAdded";
    roles[DateModifiedRole]     = "dateModified";
    roles[CommentRole]          = "comment";

    return roles;
}
