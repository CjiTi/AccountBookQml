import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: personal
    anchors.fill: parent

    // 模板列表数据模型
    ListModel {
        id: templateListModel
    }

    // 加载模板列表的函数
    function loadTemplateList() {
        templateListModel.clear();
        var templateList = AccountBookSql.getTemplateList();
        for (var i = 0; i < templateList.length; i++) {
            templateListModel.append({
                "templateName": templateList[i]
            });
        }
    }

    property string selectedTemplateName: ""

    // 页面加载时自动加载模板列表
    Component.onCompleted: {
        loadTemplateList();
    }

    Rectangle {
        id: homeGridLayout
        anchors.fill: parent
        color: '#f8f1f1'
        radius: 10
        Rectangle {
            anchors.fill: parent
            anchors.margins: 10
            color: 'transparent'
            Flickable {
                id: homeScrollView
                anchors.fill: parent
                contentWidth: homeGridLayoutGrid.width
                contentHeight: homeGridLayoutGrid.height
                interactive: true
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {
                    position: ScrollBar.AsNeeded
                }
                GridLayout {
                    id: homeGridLayoutGrid
                    columns: homeGridLayout.width / 220

                    // 使用Repeater动态加载模板按钮
                    Repeater {
                        model: templateListModel
                        delegate: Rectangle {
                            Layout.preferredWidth: 220
                            Layout.preferredHeight: 100
                            color: "#d0d0d0"
                            border.width: 1
                            border.color: "#d0d0d0"
                            radius: 10
                            Text {
                                text: templateName
                                font.family: "微软雅黑"
                                font.pointSize: 20
                                font.bold: true
                                anchors.centerIn: parent
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("模板被点击: " + templateName);
                                    // 设置当前选中的模板名称
                                    selectedTemplateName = templateName;
                                    // 打开创建账本弹窗
                                    createBillListPopup.open();
                                }
                            }
                        }
                    }

                    // 新建模板按钮
                    Rectangle {
                        Layout.preferredWidth: 220
                        Layout.preferredHeight: 100
                        color: "#d0d0d0"
                        border.width: 1
                        border.color: "#d0d0d0"
                        radius: 10
                        Text {
                            text: qsTr("新建模板")
                            font.family: "微软雅黑"
                            font.pointSize: 20
                            font.bold: true
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("新建模板被点击");
                                newTemplatePopup.open();
                            }
                        }
                    }
                }
            }
        }
    }

    // 新建模板弹窗
    Popup {
        id: newTemplatePopup
        width: 400
        height: 300
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 10
            border.width: 1
            border.color: "#FF8A5C"
        }
        anchors.centerIn: parent

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: "新建模板"
                font.family: "微软雅黑"
                font.pointSize: 18
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // 模板名称输入框
            Rectangle {
                width: parent.width
                height: 40
                color: "white"
                radius: 5
                border.width: 1
                border.color: "#cccccc"

                TextField {
                    id: templateNameInput
                    width: parent.width - 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 14
                    color: "#333333"
                    placeholderText: qsTr("请输入模板名称")
                    background: null
                }
            }

            // 模板类型选择框
            Rectangle {
                width: parent.width
                height: 40
                color: "white"
                radius: 5
                border.width: 1
                border.color: "#cccccc"

                ComboBox {
                    id: templateTypeComboBox
                    width: parent.width - 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 14
                    model: ["日常记账", "购物清单", "旅行预算", "项目支出", "其他"]
                    background: null
                }
            }
            // 按钮区域
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Rectangle {
                    width: 80
                    height: 35
                    color: cancelBtnArea.pressed ? '#cec3c3' : (cancelBtnArea.containsMouse ? "#ffffff" : "#FF8A5C")
                    border.width: 1
                    border.color: "#FF8A5C"
                    radius: 5

                    Text {
                        text: qsTr("取消")
                        color: cancelBtnArea.pressed ? '#000000' : (cancelBtnArea.containsMouse ? "#FF8A5C" : "#ffffff")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: cancelBtnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            newTemplatePopup.close();
                        }
                    }
                }

                Rectangle {
                    width: 80
                    height: 35
                    color: confirmBtnArea.pressed ? '#cec3c3' : (confirmBtnArea.containsMouse ? "#ffffff" : "#FF8A5C")
                    border.width: 1
                    border.color: "#FF8A5C"
                    radius: 5

                    Text {
                        text: qsTr("确认")
                        color: confirmBtnArea.pressed ? '#000000' : (confirmBtnArea.containsMouse ? "#FF8A5C" : "#ffffff")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: confirmBtnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            // 检查模板名称是否为空
                            if (templateNameInput.text.trim() === "") {
                                emptyFieldsPopup.open();
                                return;
                            }

                            // 检查模板类型是否已选择
                            if (templateTypeComboBox.currentIndex < 0) {
                                emptyFieldsPopup.open();
                                return;
                            }

                            // 获取选中的模板类型
                            var selectedType = templateTypeComboBox.model[templateTypeComboBox.currentIndex];

                            // 调用创建模板函数
                            if (AccountBookSql.createTemplate(templateNameInput.text, selectedType)) {
                                successPopup.open();
                                templateNameInput.text = "";
                                templateTypeComboBox.currentIndex = 0;
                                newTemplatePopup.close();
                                // 创建模板后重新加载模板列表
                                loadTemplateList();
                            } else {
                                failPopup.open();
                            }
                        }
                    }
                }
            }
        }
    }

    //创建账本
    Popup {
        id: createBillListPopup
        width: 400
        height: 250
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 10
            border.width: 1
            border.color: "#4CAF50"
        }
        anchors.centerIn: parent

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: "创建账本"
                font.family: "微软雅黑"
                font.pointSize: 18
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // 显示选中的模板名称
            Rectangle {
                width: parent.width
                height: 40
                color: "#f0f0f0"
                radius: 5
                border.width: 1
                border.color: "#cccccc"

                Text {
                    text: "模板: " + selectedTemplateName
                    width: parent.width - 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 14
                    color: "#333333"
                }
            }

            // 账本名称输入框
            Rectangle {
                width: parent.width
                height: 40
                color: "white"
                radius: 5
                border.width: 1
                border.color: "#cccccc"

                TextField {
                    id: billListNameInput
                    width: parent.width - 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 14
                    color: "#333333"
                    placeholderText: qsTr("请输入账本名称")
                    background: null
                }
            }

            // 按钮区域
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Rectangle {
                    width: 80
                    height: 35
                    color: createBillCancelBtnArea.pressed ? '#cec3c3' : (createBillCancelBtnArea.containsMouse ? "#ffffff" : "#4CAF50")
                    border.width: 1
                    border.color: "#4CAF50"
                    radius: 5

                    Text {
                        text: qsTr("取消")
                        color: createBillCancelBtnArea.pressed ? '#000000' : (createBillCancelBtnArea.containsMouse ? "#4CAF50" : "#ffffff")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: createBillCancelBtnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            createBillListPopup.close();
                        }
                    }
                }

                Rectangle {
                    width: 80
                    height: 35
                    color: createBillConfirmBtnArea.pressed ? '#cec3c3' : (createBillConfirmBtnArea.containsMouse ? "#ffffff" : "#4CAF50")
                    border.width: 1
                    border.color: "#4CAF50"
                    radius: 5

                    Text {
                        text: qsTr("确认")
                        color: createBillConfirmBtnArea.pressed ? '#000000' : (createBillConfirmBtnArea.containsMouse ? "#4CAF50" : "#ffffff")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        id: createBillConfirmBtnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            // 检查账本名称是否为空
                            if (billListNameInput.text.trim() === "") {
                                emptyFieldsPopup.open();
                                return;
                            }

                            // 调用创建账本函数
                            if (AccountBookSql.createBillList(selectedTemplateName, billListNameInput.text)) {
                                billListSuccessPopup.open();
                                billListNameInput.text = "";
                                createBillListPopup.close();
                            } else {
                                billListFailPopup.open();
                            }
                        }
                    }
                }
            }
        }
    }

    // 成功提示弹窗
    Popup {
        id: successPopup
        width: 200
        height: 80
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 5
            border.width: 1
            border.color: "#4CAF50"
        }
        anchors.centerIn: parent

        Text {
            text: "模板创建成功"
            font.pixelSize: 14
            font.family: "微软雅黑"
            font.bold: true
            color: "#4CAF50"
            anchors.centerIn: parent
        }

        Timer {
            id: successTimer
            interval: 2000
            onTriggered: successPopup.close()
        }

        onOpened: successTimer.start()
    }

    // 失败提示弹窗
    Popup {
        id: failPopup
        width: 200
        height: 80
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 5
            border.width: 1
            border.color: "#F44336"
        }
        anchors.centerIn: parent

        Text {
            text: "模板创建失败"
            font.pixelSize: 14
            font.family: "微软雅黑"
            font.bold: true
            color: "#F44336"
            anchors.centerIn: parent
        }

        Timer {
            id: failTimer
            interval: 2000
            onTriggered: failPopup.close()
        }

        onOpened: failTimer.start()
    }

    // 空字段提示弹窗
    Popup {
        id: emptyFieldsPopup
        width: 200
        height: 80
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 5
            border.width: 1
            border.color: "#FF9800"
        }
        anchors.centerIn: parent

        Text {
            text: "请填写所有字段"
            font.pixelSize: 14
            font.family: "微软雅黑"
            font.bold: true
            color: "#FF9800"
            anchors.centerIn: parent
        }

        Timer {
            id: emptyFieldsTimer
            interval: 2000
            onTriggered: emptyFieldsPopup.close()
        }

        onOpened: emptyFieldsTimer.start()
    }

    // 账本创建成功提示弹窗
    Popup {
        id: billListSuccessPopup
        width: 200
        height: 80
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 5
            border.width: 1
            border.color: "#4CAF50"
        }
        anchors.centerIn: parent

        Text {
            text: "账本创建成功"
            font.pixelSize: 14
            font.family: "微软雅黑"
            font.bold: true
            color: "#4CAF50"
            anchors.centerIn: parent
        }

        Timer {
            id: billListSuccessTimer
            interval: 2000
            onTriggered: billListSuccessPopup.close()
        }

        onOpened: billListSuccessTimer.start()
    }

    // 账本创建失败提示弹窗
    Popup {
        id: billListFailPopup
        width: 200
        height: 80
        modal: true
        dim: true
        background: Rectangle {
            color: "white"
            radius: 5
            border.width: 1
            border.color: "#F44336"
        }
        anchors.centerIn: parent

        Text {
            text: "账本创建失败"
            font.pixelSize: 14
            font.family: "微软雅黑"
            font.bold: true
            color: "#F44336"
            anchors.centerIn: parent
        }

        Timer {
            id: billListFailTimer
            interval: 2000
            onTriggered: billListFailPopup.close()
        }

        onOpened: billListFailTimer.start()
    }
}
