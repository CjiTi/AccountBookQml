#include <QApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include "AccountBookSql.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // 设置应用程序图标
    app.setWindowIcon(QIcon(":/icons/app_icon.svg"));

    // qmlRegisterType<AccountBookSql>("AccountBookSql", 1, 0, "AccountBookSql");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []()
        { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("AccountBookQml", "Welcome");
    AccountBookSql accountBookSql;
    engine.rootContext()->setContextProperty("AccountBookSql", &accountBookSql);

    return app.exec();
}