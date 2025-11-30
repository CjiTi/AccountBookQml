import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: welcome
    width: 800
    height: 480
    visible: true
    title: qsTr("欢迎使用记账本")
    flags: Qt.Window | Qt.FramelessWindowHint

    signal successShow

    Connections {
        target: welcome
        function onSuccessShow() {
            var mainWindow = Qt.createComponent("Main.qml").createObject(null);
            welcome.hide();
            mainWindow.show();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Image {
            source: "qrc:/image/login.jpg"
            anchors.fill: parent
            opacity: 1 //透明度
            z: -1
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                welcome.startSystemMove();
            }
        }
    }
    Rectangle {
        width: parent.width
        height: 40
        border.width: 2
        color: "transparent"
        border.color: "transparent"
        // radius: 5 // 圆角半径

        RowLayout {
            id: windowControl
            anchors.fill: parent
            anchors.margins: 5
            spacing: 8

            Item {
                Layout.fillWidth: true
            }
            Button {
                //关闭
                icon.source: "qrc:/icons/close.svg"
                onClicked: {
                    Qt.quit();
                }
            }
        }
    }
    Column {
        id: mainContainer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: windowControl.parent.bottom
        anchors.bottom: textDrag.top
        anchors.topMargin: 60
        spacing: 50

        // 标题区域
        Column {
            spacing: 40
            anchors.horizontalCenter: parent.horizontalCenter

            // 主标题
            Text {
                text: qsTr("欢迎使用记账本")
                font.family: "Microsoft YaHei"
                font.pixelSize: 60
                color: "#FF8A5C" // 橙色
                // 设置主标题文字为粗体样式
                font.bold: true
                // 添加文字描边效果
                style: Text.Outline
                styleColor: "#FF8A5C"
            }

            // 副标题
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("简单高效地管理您的收支")
                font.family: "Microsoft YaHei"
                font.pixelSize: 18
                color: "#666666" // 深灰色
            }
        }
        RowLayout {
            spacing: 80
            anchors.horizontalCenter: parent.horizontalCenter
            height: 150

            // 注册按钮
            Rectangle {
                id: registerBtn
                Layout.preferredWidth: 300
                Layout.preferredHeight: 60
                color: registerBtnArea.pressed ? "#cec3c3" : (registerBtnArea.containsMouse ? "#FF8A5C" : "#ffffff")
                border.width: 2
                border.color: "#FF8A5C" // 橙色边框
                radius: 25 // 圆角

                Text {
                    id: registerText
                    text: qsTr("注册")
                    color: registerBtnArea.pressed ? '#000000' : (registerBtnArea.containsMouse ? "#ffffff" : "#FF8A5C")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 18
                    font.bold: true
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: registerBtnArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        // 这里添加注册逻辑
                        console.log("注册按钮被点击");
                        var logonWindow = Qt.createComponent("Logon.qml").createObject(null);
                        welcome.hide();
                        logonWindow.show();
                        logonWindow.welcomeShow.connect(function () {
                            welcome.show(); // 登录完成后显示欢迎窗口
                            logonWindow.close(); // 关闭登录窗口
                            logonWindow.destroy();
                        });
                        logonWindow.successShow.connect(function () {
                            welcome.show(); // 登录完成后显示欢迎窗口
                            logonWindow.close(); // 关闭登录窗口
                            logonWindow.destroy();
                            welcome.successShow();
                        });
                    }
                }
            }

            // 登录按钮
            Rectangle {
                Layout.preferredWidth: 300
                Layout.preferredHeight: 60
                color: loginBtnArea.pressed ? '#cec3c3' : (loginBtnArea.containsMouse ? "#ffffff" : "#FF8A5C")
                border.width: 2
                border.color: "#FF8A5C" // 橙色边框
                radius: 25 // 圆角
                Text {
                    text: qsTr("登录")
                    color: loginBtnArea.pressed ? '#000000' : (loginBtnArea.containsMouse ? "#FF8A5C" : "#ffffff")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 18
                    font.bold: true
                    anchors.centerIn: parent
                }
                MouseArea {
                    id: loginBtnArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        // 这里添加登录逻辑
                        console.log("登录按钮被点击");
                        var loginWindow = Qt.createComponent("Login.qml").createObject(null);
                        welcome.hide();
                        loginWindow.show();
                        loginWindow.welcomeShow.connect(function () {
                            welcome.show(); // 登录完成后显示欢迎窗口
                            loginWindow.close(); // 关闭登录窗口
                            loginWindow.destroy();
                        });
                         loginWindow.successShow.connect(function () {
                            welcome.show(); // 登录完成后显示欢迎窗口
                            loginWindow.close(); // 关闭登录窗口
                            loginWindow.destroy();
                            welcome.successShow();
                        });
                    }
                }
            }
        }
    }

    Text {
        id: textDrag
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 10
        text: qsTr("天行健，君子以自强不息")
        font.family: "SimSun"
        font.pixelSize: 14
        color: "#AAAAAA"
    }
}
