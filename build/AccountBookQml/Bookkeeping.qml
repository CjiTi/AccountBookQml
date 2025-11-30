pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: bookkeeping
    anchors.fill: parent

    // 添加一个函数来刷新账单列表
    function refreshBillList() {
        billListView.model = AccountBookSql.getBillItems();
    }

    // 修改弹窗相关变量
    property var editingItem: null
    property bool editMode: false

    // 组件加载时获取数据
    Component.onCompleted: {
        refreshBillList();
    }

    // 上半部分：记账功能区域
    Rectangle {
        id: bookkeepingArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        height: parent.height * 0.3
        color: "#ffffff"
        border.width: 1.5
        border.color: "#FF8A5C"
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            // 记账表单区域
            RowLayout {
                id: bookkeepingrow1
                Layout.fillWidth: true
                Layout.preferredHeight: 20

                // 类型选择
                Text {
                    text: qsTr("类型:")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 16
                }

                ComboBox {
                    id: typeComboBox
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: bookkeepingArea.width / 4
                    model: [qsTr("支出"), qsTr("收入")]
                }

                // 金额
                Text {
                    text: qsTr("金额:")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 16
                }

                TextField {
                    id: amountField
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: bookkeepingArea.width / 4
                    placeholderText: qsTr("请输入金额")
                }

                // 分类
                Text {
                    text: qsTr("分类:")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 16
                }

                ComboBox {
                    id: categoryComboBox
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: bookkeepingArea.width / 4
                    model: typeComboBox.currentText === qsTr("支出") ? [qsTr("餐饮"), qsTr("交通"), qsTr("医疗"), qsTr("其他")] : [qsTr("工资"), qsTr("奖金"), qsTr("投资"), qsTr("其他")]
                }
            }
            RowLayout {
                id: bookkeepingrow2
                Layout.fillWidth: true
                Layout.preferredHeight: 20
                //方式
                Text {
                    text: qsTr("方式:")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 16
                }

                ComboBox {
                    id: wayComboBox
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: bookkeepingArea.width / 4
                    model: [qsTr("现金"), qsTr("银行卡"), qsTr("支付宝"), qsTr("微信"), qsTr("其他")]
                }

                // 日期
                Text {
                    text: qsTr("日期:")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 16
                }

                TextField {
                    id: dateField
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: bookkeepingArea.width / 4
                    placeholderText: qsTr("YYYY-MM-DD")
                }
            }
            RowLayout {
                id: bookkeepingrow3
                Layout.fillWidth: true
                Layout.preferredHeight: 20
                // 备注
                Text {
                    text: qsTr("备注:")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 16
                }

                TextField {
                    id: noteField
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: bookkeepingArea.width - 80
                    placeholderText: qsTr("请输入备注")
                }
            }

            // 按钮区域
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10
                Rectangle {
                    id: customButton
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 30
                    color: "#FF8A5C"
                    border.width: 1
                    border.color: "#FF8A5C"
                    radius: 3

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("保存")
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked:
                        // 按钮点击处理逻辑
                        {
                            // 调用 C++ 函数保存数据
                            if (AccountBookSql.addBillItem(typeComboBox.currentText, wayComboBox.currentText, dateField.text, amountField.text, categoryComboBox.currentText, noteField.text)) {
                                // 保存成功后刷新列表
                                bookkeeping.refreshBillList();
                                // 清空表单
                                amountField.text = "";
                                noteField.text = "";
                                dateField.text = "";
                            }
                        }
                    }
                }
            }
        }
    }

    //下半部分：账目清单区域
    Rectangle {
        id: listArea
        anchors.top: bookkeepingArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        anchors.topMargin: 5
        color: "#ffffff"
        border.width: 1.5
        border.color: "#FF8A5C"
        radius: 5

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            // 标题和筛选区域
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: qsTr("账目清单")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 20
                    font.bold: true
                    color: "#000000"
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            //账目列表:
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: billListView
                    delegate: Component {
                        Rectangle {
                            id: billItemRect
                            required property int index
                            required property var modelData
                            width: billListView.width
                            height: 60
                            color: index % 2 === 0 ? "#f9f9f9" : "#ffffff"
                            border.width: 0.5
                            border.color: "#e0e0e0"
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    // 设置当前编辑的项
                                    bookkeeping.editingItem = billItemRect.modelData;
                                    // 打开编辑弹窗
                                    editPopup.open();
                                }
                            }
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 15

                                // 类型图标
                                Rectangle {
                                    Layout.preferredWidth: 30
                                    Layout.preferredHeight: 30
                                    color: billItemRect.modelData.type === qsTr("支出") ? "#ff6b6b" : "#51cf66"
                                    radius: 15

                                    Text {
                                        anchors.centerIn: parent
                                        text: billItemRect.modelData.type === qsTr("支出") ? "支" : "收"
                                        color: "white"
                                        font.family: "Microsoft YaHei"
                                        font.pixelSize: 14
                                        font.bold: true
                                    }
                                }

                                // 分类
                                Text {
                                    Layout.preferredWidth: 80
                                    text: billItemRect.modelData.category || ""
                                    font.family: "Microsoft YaHei"
                                    font.pixelSize: 14
                                }

                                // 备注
                                Text {
                                    Layout.fillWidth: true
                                    text: billItemRect.modelData.notes || ""
                                    font.family: "Microsoft YaHei"
                                    font.pixelSize: 14
                                }

                                // 金额
                                Text {
                                    Layout.preferredWidth: 100
                                    text: (billItemRect.modelData.type === qsTr("支出") ? "-￥" : "+￥") + (billItemRect.modelData.amount || 0).toFixed(2)
                                    font.family: "Microsoft YaHei"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: billItemRect.modelData.type === qsTr("支出") ? "#ff6b6b" : "#51cf66"
                                }

                                // 日期
                                Text {
                                    Layout.preferredWidth: 100
                                    text: billItemRect.modelData.transaction_time || ""
                                    font.family: "Microsoft YaHei"
                                    font.pixelSize: 14
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Popup {
        id: editPopup
        width: parent.width * 0.8
        height: parent.height * 0.6
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Rectangle {
            anchors.fill: parent
            color: "#ffffff"
            border.width: 1.5
            border.color: "#FF8A5C"
            radius: 5

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                // 标题
                Text {
                    text: qsTr("修改账目")
                    font.family: "Microsoft YaHei"
                    font.pixelSize: 18
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                // 记账表单区域
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20

                    // 类型选择
                    Text {
                        text: qsTr("类型:")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 16
                    }

                    ComboBox {
                        id: editTypeComboBox
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: editPopup.width / 5
                        model: [qsTr("支出"), qsTr("收入")]
                    }

                    // 金额
                    Text {
                        text: qsTr("金额:")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 16
                    }

                    TextField {
                        id: editAmountField
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: editPopup.width / 5
                        placeholderText: qsTr("请输入金额")
                    }

                    // 分类
                    Text {
                        text: qsTr("分类:")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 16
                    }

                    ComboBox {
                        id: editCategoryComboBox
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: editPopup.width / 5
                        model: editTypeComboBox.currentText === qsTr("支出") ? [qsTr("餐饮"), qsTr("交通"), qsTr("医疗"), qsTr("其他")] : [qsTr("工资"), qsTr("奖金"), qsTr("投资"), qsTr("其他")]
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20

                    // 方式
                    Text {
                        text: qsTr("方式:")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 16
                    }

                    ComboBox {
                        id: editWayComboBox
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: editPopup.width / 5
                        model: [qsTr("现金"), qsTr("银行卡"), qsTr("支付宝"), qsTr("微信"), qsTr("其他")]
                    }

                    // 日期
                    Text {
                        text: qsTr("日期:")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 16
                    }

                    TextField {
                        id: editDateField
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: editPopup.width / 5
                        placeholderText: qsTr("YYYY-MM-DD")
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 20

                    // 备注
                    Text {
                        text: qsTr("备注:")
                        font.family: "Microsoft YaHei"
                        font.pixelSize: 16
                    }

                    TextField {
                        id: editNoteField
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: editPopup.width - 100
                        placeholderText: qsTr("请输入备注")
                    }
                }

                // 按钮区域
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 20

                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 30
                        color: "#FF8A5C"
                        border.width: 1
                        border.color: "#FF8A5C"
                        radius: 3

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("保存")
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (bookkeeping.editingItem) {
                                    if (AccountBookSql.updateBillItem(editTypeComboBox.currentText, editWayComboBox.currentText, editDateField.text, editAmountField.text, editCategoryComboBox.currentText, editNoteField.text)) {
                                        // 保存成功后刷新列表
                                        bookkeeping.refreshBillList();
                                        editPopup.close();
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 30
                        color: "#f44336"
                        border.width: 1
                        border.color: "#f44336"
                        radius: 3

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("删除")
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (bookkeeping.editingItem) {
                                    if (AccountBookSql.deleteBillItem()) {
                                        // 删除成功后刷新列表
                                        bookkeeping.refreshBillList();
                                        editPopup.close();
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 30
                        color: "#9e9e9e"
                        border.width: 1
                        border.color: "#9e9e9e"
                        radius: 3

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("取消")
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                editPopup.close();
                            }
                        }
                    }
                }
            }
        }

        // 打开弹窗时填充数据
        onOpened: {
            if (bookkeeping.editingItem) {
                editTypeComboBox.currentIndex = editTypeComboBox.model.indexOf(bookkeeping.editingItem.type);
                editWayComboBox.currentIndex = editWayComboBox.model.indexOf(bookkeeping.editingItem.payment_method);
                editDateField.text = bookkeeping.editingItem.transaction_time;
                editAmountField.text = bookkeeping.editingItem.amount;
                editCategoryComboBox.currentIndex = editCategoryComboBox.model.indexOf(bookkeeping.editingItem.category);
                editNoteField.text = bookkeeping.editingItem.notes;
            }
        }
    }
}
