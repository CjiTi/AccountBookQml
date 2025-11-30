import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
    id: main
    width: 900
    height: 700
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: qsTr("main")
    color: '#eae3e3'
    flags: Qt.Window | Qt.FramelessWindowHint

    property int resizeBorderWidth: 5

    // 左边缘
    MouseArea {
        id: leftEdge
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: main.resizeBorderWidth
        cursorShape: Qt.SizeHorCursor
        onPressed: {
            main.startSystemResize(Qt.LeftEdge);
        }
    }

    // 右边缘
    MouseArea {
        id: rightEdge
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: main.resizeBorderWidth
        cursorShape: Qt.SizeHorCursor
        onPressed: {
            main.startSystemResize(Qt.RightEdge);
        }
    }

    // 上边缘
    MouseArea {
        id: topEdge
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: main.resizeBorderWidth
        cursorShape: Qt.SizeVerCursor
        onPressed: {
            main.startSystemResize(Qt.TopEdge);
        }
    }

    // 下边缘
    MouseArea {
        id: bottomEdge
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: main.resizeBorderWidth
        cursorShape: Qt.SizeVerCursor
        onPressed: {
            main.startSystemResize(Qt.BottomEdge);
        }
    }

    // 左上角
    MouseArea {
        id: topLeftCorner
        anchors.left: parent.left
        anchors.top: parent.top
        width: main.resizeBorderWidth * 2
        height: main.resizeBorderWidth * 2
        cursorShape: Qt.SizeFDiagCursor
        onPressed: {
            main.startSystemResize(Qt.LeftEdge | Qt.TopEdge);
        }
    }

    // 右上角
    MouseArea {
        id: topRightCorner
        anchors.right: parent.right
        anchors.top: parent.top
        width: main.resizeBorderWidth * 2
        height: main.resizeBorderWidth * 2
        cursorShape: Qt.SizeBDiagCursor

        onPressed: {
            main.startSystemResize(Qt.RightEdge | Qt.TopEdge);
        }
    }

    // 左下角
    MouseArea {
        id: bottomLeftCorner
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: main.resizeBorderWidth * 2
        height: main.resizeBorderWidth * 2
        cursorShape: Qt.SizeBDiagCursor
        onPressed: {
            main.startSystemResize(Qt.LeftEdge | Qt.BottomEdge);
        }
    }

    // 右下角
    MouseArea {
        id: bottomRightCorner
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: main.resizeBorderWidth * 2
        height: main.resizeBorderWidth * 2
        cursorShape: Qt.SizeFDiagCursor
        onPressed: {
            main.startSystemResize(Qt.RightEdge | Qt.BottomEdge);
        }
    }

    // 窗口控制栏
    Rectangle {
        id: windowControlBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        height: 40
        border.width: 1.5
        border.color: "#FF8A5C"
        radius: 5

        MouseArea {
            anchors.fill: parent
            onPressed: {
                main.startSystemMove();
            }
        }

        RowLayout {
            //anchors.fill: parent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            spacing: 8

            Rectangle {
                Layout.preferredHeight: 30
                Layout.preferredWidth: 30
                //color:"transparent"
                Image {
                    source: "qrc:/icons/app_icon.svg"
                    anchors.fill: parent
                    opacity: 1 //透明度
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                //最小化
                id: btnMin
                icon.source: "qrc:/icons/minimize.svg"
                onClicked: {
                    main.showMinimized();
                }
            }
            Button {
                //最大化
                icon.source: "qrc:/icons/maximize.svg"
                onClicked: {
                    if (main.visibility == Window.Maximized) {
                        main.visibility = Window.Windowed;
                    } else {
                        main.visibility = Window.Maximized;
                    }
                }
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

    RowLayout {
        id: mainwindow
        anchors.top: windowControlBar.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 5
        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: 180
            Rectangle {
                id: btnArea
                anchors.fill: parent
                color: "#ffffff"
                border.width: 1.5
                border.color: "#FF8A5C"
                radius: 5

                property var selsctedButton: null

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10
                    Rectangle {
                        id: homeBtn
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: 170
                        color: homeBtnArea.pressed ? '#e0d5d5' : (homeBtnArea.containsMouse ? '#e6e0dd' : (btnArea.selsctedButton === homeBtn ? '#e6e0dd' : "#ffffff"))
                        border.width: 1
                        border.color: "#FF8a5c"
                        radius: 5
                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            Image {
                                source: "qrc:/icons/home.svg"
                            }
                            Text {
                                id: homeText
                                text: qsTr("首页")
                                color: btnArea.selsctedButton === homeBtn ? '#2b00ff' : "#000000"
                                font.family: "Microsoft YaHei"
                                font.pixelSize: 18
                                font.bold: btnArea.selsctedButton === homeBtn ? true : false
                            }
                        }

                        MouseArea {
                            id: homeBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("首页被点击");
                                btnArea.resetAllButtons();
                                btnArea.selsctedButton = homeBtn;
                                homeLoader.source = "Home.qml";
                            }
                        }
                    }
                    Rectangle {
                        id: myBillBtn
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: 170
                        color: myBillBtnArea.pressed ? '#e0d5d5' : (myBillBtnArea.containsMouse ? '#e6e0dd' : (btnArea.selsctedButton === myBillBtn ? '#e6e0dd' : "#ffffff"))
                        border.width: 1
                        border.color: "#FF8a5c"
                        radius: 5
                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            Image {
                                source: "qrc:/icons/books.svg"
                            }
                            Text {
                                id: myBillText
                                text: qsTr("我的账单")
                                color: btnArea.selsctedButton === myBillBtn ? '#2b00ff' : "#000000"
                                font.family: "Microsoft YaHei"
                                font.pixelSize: 18
                                font.bold: btnArea.selsctedButton === myBillBtn ? true : false
                            }
                        }

                        MouseArea {
                            id: myBillBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("我的账单被点击");
                                btnArea.resetAllButtons();
                                btnArea.selsctedButton = myBillBtn;
                                homeLoader.source = "MyBill.qml";
                            }
                        }
                    }
                    Rectangle {
                        id: invoiceTemplateBtn
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: 170
                        color: invoiceTemplateBtnArea.pressed ? '#e0d5d5' : (invoiceTemplateBtnArea.containsMouse ? '#e6e0dd' : (btnArea.selsctedButton === invoiceTemplateBtn ? '#e6e0dd' : "#ffffff"))
                        border.width: 1
                        border.color: "#FF8a5c"
                        radius: 5
                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            Image {
                                source: "qrc:/icons/templates.svg"
                            }
                            Text {
                                id: invoiceTemplateText
                                text: qsTr("账单模板")
                                color: btnArea.selsctedButton === invoiceTemplateBtn ? '#2b00ff' : "#000000"
                                font.family: "Microsoft YaHei"
                                font.pixelSize: 18
                                font.bold: btnArea.selsctedButton === invoiceTemplateBtn ? true : false
                            }
                        }

                        MouseArea {
                            id: invoiceTemplateBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("账单模板被点击");
                                btnArea.resetAllButtons();
                                btnArea.selsctedButton = invoiceTemplateBtn;
                                homeLoader.source = "Template.qml";
                            }
                        }
                    }
                    //占位
                    Item {
                        Layout.fillHeight: true
                    }
                    Rectangle {
                        id: settingBtn
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: 170
                        color: settingBtnArea.pressed ? '#e0d5d5' : (settingBtnArea.containsMouse ? '#e6e0dd' : (btnArea.selsctedButton === settingBtn ? '#e6e0dd' : "#ffffff"))
                        border.width: 1
                        border.color: "#FF8a5c"
                        radius: 5
                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            Image {
                                source: "qrc:/icons/settings.svg"
                            }
                            Text {
                                id: settingText
                                text: qsTr("设置  ")
                                color: btnArea.selsctedButton === settingBtn ? '#2b00ff' : "#000000"
                                font.family: "Microsoft YaHei"
                                font.pixelSize: 18
                                font.bold: btnArea.selsctedButton === settingBtn ? true : false
                            }
                        }

                        MouseArea {
                            id: settingBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("设置被点击");
                                btnArea.resetAllButtons();
                                btnArea.selsctedButton = settingBtn;
                                homeLoader.source = "Setting.qml";
                            }
                        }
                    }
                    Rectangle {
                        id: userBtn
                        Layout.preferredHeight: 60
                        Layout.preferredWidth: 170
                        color: userBtnArea.pressed ? '#e0d5d5' : (userBtnArea.containsMouse ? '#e6e0dd' : (btnArea.selsctedButton === userBtn ? '#e6e0dd' : "#ffffff"))
                        border.width: 1
                        border.color: "#FF8a5c"
                        radius: 5
                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            Image {
                                source: "qrc:/icons/user.svg"
                            }
                            Text {
                                id: userText
                                text: qsTr("用户  ")
                                color: btnArea.selsctedButton === userBtn ? '#2b00ff' : "#000000"
                                font.family: "Microsoft YaHei"
                                font.pixelSize: 18
                                font.bold: btnArea.selsctedButton === userBtn ? true : false
                            }
                        }

                        MouseArea {
                            id: userBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                console.log("用户被点击");
                                btnArea.resetAllButtons();
                                btnArea.selsctedButton = userBtn;
                                homeLoader.source = "User.qml";
                            }
                        }
                    }
                }
                function resetAllButtons() {
                    btnArea.selsctedButton = null;
                }
            }
        }

        Item {
            id: homeItem
            Layout.fillHeight: true
            Layout.fillWidth: true
            Loader {
                id: homeLoader
                source: "Home.qml"
                anchors.fill: parent
            }
            Connections {
                target: homeLoader.item
                function onBillShow() {
                    console.log("默认账单已加载");
                    homeLoader.source = "Bill.qml";
                }
                function onTemplateShow() {
                    console.log("新建账单已加载");
                    homeLoader.source = "Template.qml";
                }
            }

        }
    }
}
