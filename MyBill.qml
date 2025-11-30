import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: myBill
    anchors.fill: parent

    signal templateShow
    signal billShow

    // 账单列表数据模型
    ListModel {
        id: billListModel
    }

    // 加载账单列表的函数
    function loadBillList() {
        billListModel.clear();
        var billList = AccountBookSql.getBillList();
        for (var i = 0; i < billList.length; i++) {
            billListModel.append({
                "billName": billList[i]
            });
        }
    }

    // 页面加载时自动加载账单列表
    Component.onCompleted: {
        loadBillList();
    }
    Rectangle {
        id: myBillRect
        anchors.fill: parent
        color: '#f8f1f1'
        radius: 10
        ColumnLayout {
            anchors.fill: parent
            spacing: 10
            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                Layout.preferredHeight: 60
                Text {
                    text: qsTr("我的账本")
                    font.family: "微软雅黑"
                    font.pointSize: 20
                    font.bold: true
                }
                Item {
                    Layout.fillWidth: true
                }
                Button {
                    icon.source: "qrc:/icons/refresh.svg"
                }
            }
            Rectangle {
                id: homeGridLayout
                Layout.fillWidth: true
                Layout.fillHeight: true
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

                            Repeater {
                                model: billListModel
                                delegate: Rectangle {
                                    Layout.preferredWidth: 220
                                    Layout.preferredHeight: 100
                                    color: "#d0d0d0"
                                    border.width: 1
                                    border.color: "#d0d0d0"
                                    radius: 10
                                    Text {
                                        text: billName
                                        font.family: "微软雅黑"
                                        font.pointSize: 16
                                        font.bold: true
                                        anchors.centerIn: parent
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            console.log("账单被点击: " + billName);
                                            AccountBookSql.billNameChanged(billName);
                                            myBill.billShow();
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredWidth: 220
                                Layout.preferredHeight: 100
                                color: "#d0d0d0"
                                border.width: 1
                                border.color: "#d0d0d0"
                                radius: 10
                                Text {
                                    text: qsTr("新建账单")
                                    font.family: "微软雅黑"
                                    font.pointSize: 20
                                    font.bold: true
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        console.log("新建账单被点击");
                                        myBill.templateShow();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
