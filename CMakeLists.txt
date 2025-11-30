cmake_minimum_required(VERSION 3.16)

project(AccountBookQml VERSION 0.1 LANGUAGES CXX )

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql Charts)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appAccountBookQml
    main.cpp
    AccountBookSql.cpp
    AccountBookSql.h
)

qt_add_qml_module(appAccountBookQml
    URI AccountBookQml
    VERSION 1.0
    QML_FILES
        Welcome.qml
        Login.qml
        Logon.qml
        Main.qml
        Home.qml
        Template.qml
        Setting.qml
        MyBill.qml
        User.qml
        Personal.qml
        Bill.qml
        Summary.qml
        Bookkeeping.qml
)

qt_add_resources(
    RESOURCES AccountBook.qrc
)
target_sources(appAccountBookQml PRIVATE ${RESOURCES})
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appAccountBookQml PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appAccountBookQml
    #QT_QML_MODULE_VERSION 1.0
    #QT_QML_MODULE_URI AccountBookQml
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    #WIN32_EXECUTABLE TRUE
    EXECUTABLE TRUE
)

target_link_libraries(appAccountBookQml
    PRIVATE 
     Qt6::Sql
     Qt6::Quick
     Qt6::Charts
)

include(GNUInstallDirs)
install(TARGETS appAccountBookQml
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
