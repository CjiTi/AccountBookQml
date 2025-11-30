import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: login
    width: 600
    height: 350
    visible: true
    title: qsTr("登录")
    flags: Qt.Window | Qt.FramelessWindowHint

    Component.onCompleted: {
        AccountBookSql.connectToDatabase();
    }

    //弹窗：请先同意注册协议(未美化)
    Popup {
        id: agreementPopup
        width: 200
        height: 80
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 5
        }
        anchors.centerIn: parent
        Label {
            id: labelAgreement
            text: "请先同意注册协议"
            font.pixelSize: 14
            font.family: "微软雅黑"
            font.bold: true
            color: "red"
            anchors.centerIn: parent
        }
    }
    //弹窗：登录失败(未美化)
    Popup {
        id: failPopup
        width: 200
        height: 80
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 5
        }
        anchors.centerIn: parent
        Label {
            id: labelFail
            text: "登录失败"
            font.pixelSize: 14
            font.family: "微软雅黑"
            font.bold: true
            color: "red"
            anchors.centerIn: parent
        }
    }

    signal welcomeShow
    signal successShow

    // 背景图片
    Image {
        source: "qrc:/image/login.jpg"
        anchors.fill: parent
        opacity: 1
        z: -1
    }
    // 窗口控制栏
    Rectangle {
        width: parent.width
        height: 40
        border.width: 2
        color: "transparent"
        border.color: "transparent"

        MouseArea {
            anchors.fill: parent
            onPressed: {
                login.startSystemMove();
            }
        }

        RowLayout {
            id: windowControl
            anchors.fill: parent
            anchors.margins: 5
            spacing: 8
            Button {
                icon.source: "qrc:/icons/back.svg"
                onClicked: {
                    console.log("返回按钮被点击");
                    login.welcomeShow();
                }
            }

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
    // 登录表单
    Column {
        id: loginForm
        anchors.centerIn: parent
        spacing: 20
        width: 300

        // 用户名输入框
        Rectangle {
            width: parent.width
            height: 40
            color: "white"
            radius: 5
            border.width: 1
            border.color: "#cccccc"

            TextField {
                id: usernameInput
                width: parent.width - 20
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
                color: "#333333"
                placeholderText: qsTr("请输入用户名")
                background: null // 移除TextField的默认背景，使用父Rectangle的样式
            }
        }

        // 密码输入框
        Rectangle {
            width: parent.width
            height: 40
            color: "white"
            radius: 5
            border.width: 1
            border.color: "#cccccc"

            TextField {
                id: passwordInput
                width: parent.width - 20
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
                color: "#333333"
                echoMode: TextInput.Password
                placeholderText: qsTr("请输入密码")
                background: null // 移除TextField的默认背景，使用父Rectangle的样式
            }
        }

        //登录按钮:
        Rectangle {
            width: parent.width
            height: 40
            color: loginBtnArea.pressed ? '#cec3c3' : (loginBtnArea.containsMouse ? "#ffffff" : "#FF8A5C")
            border.width: 2
            border.color: "#FF8A5C" // 橙色边框
            radius: 5 // 圆角

            Text {
                text: qsTr("登录")
                color: loginBtnArea.pressed ? '#000000' : (loginBtnArea.containsMouse ? "#FF8A5C" : "#ffffff")
                font.family: "Microsoft YaHei"
                font.pixelSize: 16
                font.bold: true
                anchors.centerIn: parent
            }

            MouseArea {
                id: loginBtnArea
                anchors.fill: parent
                onClicked: {
                    console.log("登录按钮被点击");
                    if (agreementCheckbox.checked) {
                        console.log("用户已同意协议");
                        if (AccountBookSql.isConnected) {
                            console.log("数据库已连接");
                            // 登录逻辑
                            if (AccountBookSql.loginUser(usernameInput.text, passwordInput.text)) {
                                console.log("登录成功");
                                login.successShow();
                            } else {
                                console.log("登录失败");
                                failPopup.open();
                            }
                        } else {
                            console.log("数据库未连接,登录失败");
                            failPopup.open();
                        }
                    } else {
                        agreementPopup.open();
                        console.log("用户未同意协议");
                    }
                }
            }
        }
    }

    RowLayout {
        anchors.top: loginForm.bottom
        x: parent.width / 2 - (agreementCheckbox.width + 100) / 2 - 88
        anchors.topMargin: 10
        spacing: 0

        CheckBox {
            id: agreementCheckbox
            checked: false
        }

        Text {
            text: "我已阅读并同意"
            font.pixelSize: 12
            color: "#333333"
        }

        Text {
            text: "《用户协议》"
            font.pixelSize: 12
            color: "#0066CC"
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Qt.openUrlExternally("https://example.com/user-agreement");
                }
            }
        }
    }
}
