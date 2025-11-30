#pragma once

#include <QObject>
#include <QtSql>

class AccountBookSql : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY isConnectedChanged)

public:
    explicit AccountBookSql(QObject *parent = nullptr);

    bool isConnected() const;
    Q_INVOKABLE int CurrentUserId() const;
    Q_INVOKABLE QString CurrentUsername() const;
    Q_INVOKABLE QString BillName() const;
    Q_INVOKABLE void billNameChanged(const QString &billname);

    Q_INVOKABLE bool connectToDatabase();
    Q_INVOKABLE bool logonUser(const QString &username, const QString &password);
    Q_INVOKABLE bool loginUser(const QString &username, const QString &password);
    Q_INVOKABLE bool createTemplate(const QString &templatename, const QString type);
    Q_INVOKABLE QStringList getTemplateList();
    Q_INVOKABLE bool createBillList(const QString &templatename, const QString &billname);
    Q_INVOKABLE QStringList getBillList();
    Q_INVOKABLE QStringList Recentusagebill(); // 最近使用的账单

    // 新增bill_item表操作方法
    Q_INVOKABLE bool addBillItem(const QString &type, const QString &payment_method, const QString &transaction_time, const double &amount,
                                 const QString &category, const QString &notes);
    Q_INVOKABLE QVariantList getBillItems();
    Q_INVOKABLE bool updateBillItem(const QString &type, const QString &payment_method, const QString &transaction_time, const double &amount,
                                    const QString &category, const QString &notes);
    Q_INVOKABLE bool deleteBillItem();
    //计算收入、支出、资产
    Q_INVOKABLE QVariantList calculateSummary();
    //计算周，月，年的收入、支出
    Q_INVOKABLE QVariantList calculateSummaryByTimePeriod();
    Q_INVOKABLE QVariantList calculateSummaryByCategory();

signals:
    void isConnectedChanged();

private:
    bool m_isConnected = false;
    int m_currentUserId = -1;
    QString m_currentUsername;
    QString billname;
};