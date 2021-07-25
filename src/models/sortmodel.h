#ifndef SORTMODEL_H
#define SORTMODEL_H

#include <QSortFilterProxyModel>

class SortModel : public QSortFilterProxyModel
{
    Q_OBJECT

public:
    explicit SortModel(QObject *parent = nullptr);

    Q_INVOKABLE void sortModel(Qt::SortOrder order);
};

#endif // SORTMODEL_H
