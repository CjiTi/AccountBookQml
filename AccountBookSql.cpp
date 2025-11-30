#include "AccountBookSql.h"

AccountBookSql::AccountBookSql(QObject *parent)
    : QObject{parent}, m_isConnected(false)
{
}

bool AccountBookSql::isConnected() const
{
    return m_isConnected;
}

int AccountBookSql::CurrentUserId() const
{
    return m_currentUserId;
}

QString AccountBookSql::CurrentUsername() const
{
    return m_currentUsername;
}
QString AccountBookSql::BillName() const
{
    return billname;
}

void AccountBookSql::billNameChanged(const QString &billname)
{
    if (this->billname != billname)
    {
        this->billname = billname;
        emit billNameChanged(billname);
        qDebug() << "Bill name changed to:" << billname;
    }
}

bool AccountBookSql::connectToDatabase()
{
    if (isConnected())
    {
        return true;
    }
    else
    {
        QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
        db.setHostName("127.0.0.1");
        db.setPort(5432);
        db.setUserName("postgres");
        db.setPassword("@Aa06036611");
        db.setDatabaseName("AccountBook");

        if (!db.open())
        {
            qDebug() << "Failed to connect to database:" << db.lastError().text();
            return false;
        }
        else
        {
            qDebug() << "Database connected successfully";
            m_isConnected = true;
            return true;
        }
    }
}

bool AccountBookSql::logonUser(const QString &username, const QString &password)
{
    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return false;
    }
    else
    {
        QSqlQuery query;
        query.prepare("SELECT * FROM users WHERE username = :username ");
        query.bindValue(":username", username);

        if (query.exec() && query.next())
        {
            qDebug() << "Username already exists";
            return false;
        }
        else
        {
            query.prepare("INSERT INTO users (username, password) VALUES (:username, :password)");
            query.bindValue(":username", username);
            query.bindValue(":password", password);
            if (query.exec())
            {
                qDebug() << "User logged in successfully";
                m_currentUserId = query.lastInsertId().toInt();
                m_currentUsername = username;
                return true;
            }
            else
            {
                qDebug() << "Failed to log in user:" << username;
                return false;
            }
        }
    }
}

bool AccountBookSql::loginUser(const QString &username, const QString &password)
{
    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return false;
    }
    else
    {
        QSqlQuery query;
        query.prepare("SELECT * FROM users WHERE username = :username AND password = :password");
        query.bindValue(":username", username);
        query.bindValue(":password", password);

        if (query.exec() && query.next())
        {
            qDebug() << "User logged in successfully";
            m_currentUserId = query.value("user_id").toInt();
            m_currentUsername = username;
            return true;
        }
        else
        {
            qDebug() << "Failed to log in user:" << username;
            return false;
        }
    }
}

bool AccountBookSql::createTemplate(const QString &templatename, const QString type)
{
    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return false;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return false;
        }
        QSqlQuery query;
        query.prepare("INSERT INTO templates (user_id, template_name, template_type) VALUES (:user_id, :template_name, :template_type)");
        query.bindValue(":user_id", m_currentUserId);
        query.bindValue(":template_name", templatename);
        query.bindValue(":template_type", type);
        if (query.exec())
        {
            qDebug() << "Template created successfully";
            return true;
        }
        else
        {
            qDebug() << "Failed to create template:" << templatename;
            qDebug() << "Error:" << query.lastError().text();
            return false;
        }
    }
}
QStringList AccountBookSql::getTemplateList()
{
    QStringList templateList;

    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return templateList;
    }

    // 检查用户是否已登录
    if (m_currentUserId == -1)
    {
        qDebug() << "User not logged in";
        return templateList;
    }

    QSqlQuery query;
    query.prepare("SELECT template_name FROM templates WHERE user_id = :user_id");
    query.bindValue(":user_id", m_currentUserId);

    if (query.exec())
    {
        while (query.next())
        {
            templateList.append(query.value("template_name").toString());
            qDebug() << "template_name:" << query.value("template_name").toString();
        }
    }
    else
    {
        qDebug() << "Failed to get template list:" << query.lastError().text();
    }

    return templateList;
}

bool AccountBookSql::createBillList(const QString &templatename, const QString &billname)
{
    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return false;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return false;
        }

        // 检查账本名称是否已存在
        QSqlQuery checkQuery;
        checkQuery.prepare("SELECT COUNT(*) FROM bill_lists WHERE bill_name = :bill_name AND user_id = :user_id");
        checkQuery.bindValue(":bill_name", billname);
        checkQuery.bindValue(":user_id", m_currentUserId);

        if (checkQuery.exec() && checkQuery.next())
        {
            int count = checkQuery.value(0).toInt();
            if (count > 0)
            {
                qDebug() << "Bill list already exists:" << billname;
                return false;
            }
        }
        else
        {
            qDebug() << "Failed to check bill list existence:" << checkQuery.lastError().text();
            return false;
        }

        QSqlQuery query;
        query.prepare("INSERT INTO bill_lists (user_id, template_id, bill_name) "
                      "VALUES (:user_id, (SELECT template_id FROM templates WHERE template_name = :template_name AND user_id = :user_id), :bill_name)");
        query.bindValue(":user_id", m_currentUserId);
        query.bindValue(":template_name", templatename);
        query.bindValue(":bill_name", billname);
        if (query.exec())
        {
            qDebug() << "Bill list created successfully";
            return true;
        }
        else
        {
            qDebug() << "Failed to create bill list:" << billname;
            qDebug() << "Error:" << query.lastError().text();
            return false;
        }
    }
}
QStringList AccountBookSql::getBillList()
{
    QStringList billList;

    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return billList;
    }

    // 检查用户是否已登录
    if (m_currentUserId == -1)
    {
        qDebug() << "User not logged in";
        return billList;
    }

    QSqlQuery query;
    query.prepare("SELECT bill_name FROM bill_lists WHERE user_id = :user_id");
    query.bindValue(":user_id", m_currentUserId);

    if (query.exec())
    {
        while (query.next())
        {
            billList.append(query.value("bill_name").toString());
            qDebug() << "bill_name:" << query.value("bill_name").toString();
        }
    }
    else
    {
        qDebug() << "Failed to get bill list:" << query.lastError().text();
    }

    return billList;
}

QStringList AccountBookSql::Recentusagebill()
{
    QStringList billList;

    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return billList;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return billList;
        }
    }

    // 获取按最近使用时间排序的账本列表
    QSqlQuery selectQuery;
    selectQuery.prepare("SELECT DISTINCT bill_lists.bill_name FROM bill_lists "
                        "LEFT JOIN bill_items bill_items ON bill_lists.bill_list_id = bill_items.bill_list_id "
                        "WHERE bill_lists.user_id = user_id AND "
                        "(bill_lists.created_at >= CURRENT_DATE - INTERVAL '1 month' OR "
                        "bill_items.last_updated >= CURRENT_DATE - INTERVAL '1 month') ");
    selectQuery.bindValue(":user_id", m_currentUserId);

    if (selectQuery.exec())
    {
        while (selectQuery.next())
        {
            billList.append(selectQuery.value("bill_name").toString());
        }
    }
    else
    {
        qDebug() << "Failed to retrieve bill list:" << selectQuery.lastError().text();
    }

    return billList;
}

bool AccountBookSql::addBillItem(const QString &type, const QString &payment_method, const QString &transaction_time, const double &amount,
                                 const QString &category, const QString &notes)
{
    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return false;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return false;
        }
    }
    QSqlQuery query;
    query.prepare("INSERT INTO bill_items "
                  "(bill_list_id, type, payment_method, transaction_time, amount, category, notes) "
                  "VALUES ("
                  "(SELECT bill_list_id FROM bill_lists WHERE bill_name = :bill_name AND user_id = :user_id), "
                  ":type, :payment_method, :transaction_time, :amount, :category, :notes"
                  ")");
    query.bindValue(":bill_name", billname);
    query.bindValue(":user_id", m_currentUserId);
    query.bindValue(":type", type);
    query.bindValue(":payment_method", payment_method);
    query.bindValue(":transaction_time", transaction_time);
    query.bindValue(":amount", amount);
    query.bindValue(":category", category);
    query.bindValue(":notes", notes);

    if (query.exec())
    {
        qDebug() << "Bill item added successfully";
        return true;
    }
    else
    {
        qDebug() << "Failed to add bill item:" << query.lastError().text();
        return false;
    }
}

QVariantList AccountBookSql::getBillItems()
{
    QVariantList billItems;

    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return billItems;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return billItems;
        }
    }

    QSqlQuery query;
    query.prepare("SELECT * FROM bill_items WHERE bill_list_id = "
                  "(SELECT bill_list_id FROM bill_lists WHERE bill_name = :bill_name AND user_id = :user_id)");
    query.bindValue(":bill_name", billname);
    query.bindValue(":user_id", m_currentUserId);

    if (query.exec())
    {
        while (query.next())
        {
            QVariantMap item;
            item["type"] = query.value("type").toString();
            item["payment_method"] = query.value("payment_method").toString();
            item["transaction_time"] = query.value("transaction_time").toString();
            item["amount"] = query.value("amount").toDouble();
            item["category"] = query.value("category").toString();
            item["notes"] = query.value("notes").toString();
            billItems.append(item);
        }
    }
    else
    {
        qDebug() << "Failed to get bill items:" << query.lastError().text();
    }

    return billItems;
}

bool AccountBookSql::updateBillItem(const QString &type, const QString &payment_method, const QString &transaction_time, const double &amount,
                                    const QString &category, const QString &notes)
{
    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return false;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return false;
        }
    }
    QSqlQuery query;
    query.prepare("UPDATE bill_items SET "
                  "type = :type, "
                  "payment_method = :payment_method, "
                  "transaction_time = :transaction_time, "
                  "amount = :amount, "
                  "category = :category, "
                  "notes = :notes "
                  "WHERE bill_item_id = ("
                  "SELECT bill_item_id FROM bill_items "
                  "WHERE bill_list_id = ("
                  "SELECT bill_list_id FROM bill_lists "
                  "WHERE bill_name = :bill_name AND user_id = :user_id"
                  ") "
                  "ORDER BY bill_item_id DESC LIMIT 1"
                  ")");
    query.bindValue(":bill_name", billname);
    query.bindValue(":user_id", m_currentUserId);
    query.bindValue(":type", type);
    query.bindValue(":payment_method", payment_method);
    query.bindValue(":transaction_time", transaction_time);
    query.bindValue(":amount", amount);
    query.bindValue(":category", category);
    query.bindValue(":notes", notes);
    if (query.exec())
    {
        qDebug() << "Bill item updated successfully";
        return true;
    }
    else
    {
        qDebug() << "Failed to update bill item:" << query.lastError().text();
        return false;
    }
}
bool AccountBookSql::deleteBillItem()
{
    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return false;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return false;
        }
    }
    QSqlQuery query;
    query.prepare("DELETE FROM bill_items WHERE bill_item_id = ("
                  "SELECT bill_item_id FROM bill_items "
                  "WHERE bill_list_id = ("
                  "SELECT bill_list_id FROM bill_lists "
                  "WHERE bill_name = :bill_name AND user_id = :user_id"
                  ") "
                  "ORDER BY bill_item_id DESC LIMIT 1"
                  ")");
    query.bindValue(":bill_name", billname);
    query.bindValue(":user_id", m_currentUserId);
    if (query.exec())
    {
        qDebug() << "Bill item deleted successfully";
        return true;
    }
    else
    {
        qDebug() << "Failed to delete bill item:" << query.lastError().text();
        return false;
    }
}

// 计算收入、支出、资产
QVariantList AccountBookSql::calculateSummary()
{

    QVariantList calculate;

    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return calculate;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return calculate;
        }
    }
    QVariantList billItems = getBillItems();
    // 计算收入
    double income = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString type = itemMap["type"].toString();
        double amount = itemMap["amount"].toDouble();
        if (type == "收入")
        {
            income += amount;
        }
    }
    calculate.append(income);
    // 计算支出
    double expenditure = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString type = itemMap["type"].toString();
        double amount = itemMap["amount"].toDouble();
        if (type == "支出")
        {
            expenditure -= amount;
        }
    }
    calculate.append(expenditure);
    // 计算资产
    calculate.append(income + expenditure);
    return calculate;
}

// 计算周，月，年的收入、支出
QVariantList AccountBookSql::calculateSummaryByTimePeriod()
{

    QVariantList calculate;

    if (!isConnected())
    {
        qDebug() << "Failed to connect to database";
        return calculate;
    }
    else
    {
        // 检查用户是否已登录
        if (m_currentUserId == -1)
        {
            qDebug() << "User not logged in";
            return calculate;
        }
    }
    QVariantList billItems = getBillItems();

    // 获取当前日期和当前周的起始日期（周一）和结束日期（周日）
    QDate currentDate = QDate::currentDate();
    int currentDayOfWeek = currentDate.dayOfWeek();              // 1=周一, 7=周日
    QDate weekStart = currentDate.addDays(1 - currentDayOfWeek); // 本周周一
    QDate weekEnd = currentDate.addDays(7 - currentDayOfWeek);   // 本周周日

    // 计算周收入
    double weekIncome = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString transaction_time = itemMap["transaction_time"].toString();
        QDate date = QDate::fromString(transaction_time, "yyyy-MM-dd");
        if (date.isValid())
        {
            // 检查交易日期是否在当前周范围内（周一到周日）
            if (date >= weekStart && date <= weekEnd)
            {
                QString type = itemMap["type"].toString();
                double amount = itemMap["amount"].toDouble();
                if (type == "收入")
                {
                    weekIncome += amount;
                }
            }
        }
    }
    calculate.append(weekIncome);
    // 计算周支出
    double weekExpenditure = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString transaction_time = itemMap["transaction_time"].toString();
        QDate date = QDate::fromString(transaction_time, "yyyy-MM-dd");
        if (date.isValid())
        {
            // 检查交易日期是否在当前周范围内（周一到周日）
            if (date >= weekStart && date <= weekEnd)
            {
                QString type = itemMap["type"].toString();
                double amount = itemMap["amount"].toDouble();
                if (type == "支出")
                {
                    weekExpenditure -= amount;
                }
            }
        }
    }
    calculate.append(weekExpenditure);
    // 计算月收入
    double monthIncome = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString type = itemMap["type"].toString();
        double amount = itemMap["amount"].toDouble();
        QString transaction_time = itemMap["transaction_time"].toString();
        QDate date = QDate::fromString(transaction_time, "yyyy-MM-dd");
        if (date.isValid())
        {
            if (date.month() == QDate::currentDate().month())
            {
                if (type == "收入")
                {
                    monthIncome += amount;
                }
            }
        }
    }
    calculate.append(monthIncome);
    // 计算月支出
    double monthExpenditure = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString transaction_time = itemMap["transaction_time"].toString();
        QDate date = QDate::fromString(transaction_time, "yyyy-MM-dd");
        if (date.isValid())
        {
            if (date.month() == QDate::currentDate().month())
            {
                QString type = itemMap["type"].toString();
                double amount = itemMap["amount"].toDouble();
                if (type == "支出")
                {
                    monthExpenditure -= amount;
                }
            }
        }
    }
    calculate.append(monthExpenditure);
    // 计算年收入
    double yearIncome = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString type = itemMap["type"].toString();
        double amount = itemMap["amount"].toDouble();
        QString transaction_time = itemMap["transaction_time"].toString();
        QDate date = QDate::fromString(transaction_time, "yyyy-MM-dd");
        if (date.isValid())
        {
            if (date.year() == QDate::currentDate().year())
            {
                if (type == "收入")
                {
                    yearIncome += amount;
                }
            }
        }
    }
    calculate.append(yearIncome);
    // 计算年支出
    double yearExpenditure = 0.0;
    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString transaction_time = itemMap["transaction_time"].toString();
        QDate date = QDate::fromString(transaction_time, "yyyy-MM-dd");
        if (date.isValid())
        {
            if (date.year() == QDate::currentDate().year())
            {
                QString type = itemMap["type"].toString();
                double amount = itemMap["amount"].toDouble();
                if (type == "支出")
                {
                    yearExpenditure -= amount;
                }
            }
        }
    }
    calculate.append(yearExpenditure);
    return calculate;
}
// 使用getBillItems获取的数据，根据分类计算收入、支出
QVariantList AccountBookSql::calculateSummaryByCategory()
{
    QVariantList calculate;

    // 初始化各分类的金额为0
    double foodExpense = 0.0;      // 餐饮支出
    double transportExpense = 0.0; // 交通支出
    double medicalExpense = 0.0;   // 医疗支出
    double otherExpense = 0.0;     // 其他支出
    double salaryIncome = 0.0;     // 工资收入
    double bonusIncome = 0.0;      // 奖金收入
    double investmentIncome = 0.0; // 投资收入
    double otherIncome = 0.0;      // 其他收入

    // 获取当前日期
    QDate currentDate = QDate::currentDate();
    int currentMonth = currentDate.month();
    int currentYear = currentDate.year();

    QVariantList billItems = getBillItems();

    for (const QVariant &item : billItems)
    {
        QVariantMap itemMap = item.toMap();
        QString type = itemMap["type"].toString();
        double amount = itemMap["amount"].toDouble();
        QString category = itemMap["category"].toString();
        QString transaction_time = itemMap["transaction_time"].toString();
        QDate date = QDate::fromString(transaction_time, "yyyy-MM-dd");

        // 只处理当前月份的数据
        if (date.isValid() && date.month() == currentMonth && date.year() == currentYear)
        {
            if (type == "支出")
            {
                if (category == "餐饮")
                    foodExpense += amount;
                else if (category == "交通")
                    transportExpense += amount;
                else if (category == "医疗")
                    medicalExpense += amount;
                else if (category == "其他")
                    otherExpense += amount;
            }
            else if (type == "收入")
            {
                if (category == "工资")
                    salaryIncome += amount;
                else if (category == "奖金")
                    bonusIncome += amount;
                else if (category == "投资")
                    investmentIncome += amount;
                else if (category == "其他")
                    otherIncome += amount;
            }
        }
    }

    // 按顺序添加各分类的汇总金额
    // 支出分类
    calculate.append(foodExpense);
    calculate.append(transportExpense);
    calculate.append(medicalExpense);
    calculate.append(otherExpense);

    // 收入分类
    calculate.append(salaryIncome);
    calculate.append(bonusIncome);
    calculate.append(investmentIncome);
    calculate.append(otherIncome);

    return calculate;
}