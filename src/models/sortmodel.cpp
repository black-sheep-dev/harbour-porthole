#include "sortmodel.h"

SortModel::SortModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{

}

void SortModel::sortModel(Qt::SortOrder order)
{
    this->sort(0, order);
}
