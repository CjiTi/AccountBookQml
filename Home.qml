import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: home
    anchors.fill: parent

    signal billShow
    signal templateShow

    // 最近使用的账本数据模型
    ListModel {
        id: homeModel
    }

    // 加载账单列表的函数
    function loadList() {
        homeModel.clear();
        var List = AccountBookSql.Recentusagebill();
        for (var i = 0; i < List.length; i++) {
            homeModel.append({
                "billName": List[i]
            });
        }
    }

    // 页面加载时自动加载账单列表
    Component.onCompleted: {
        loadList();
    }

    ColumnLayout {
        id: homeColumnLayout
        anchors.fill: parent
        RowLayout {
            spacing: 10
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.preferredHeight: 60
            Text {
                text: qsTr("最近使用的账本")
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
                        model: homeModel
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
                                    home.billShow();
                                }
                            }
                        }
                    }
                }
            }
        }
        RowLayout {
            spacing: 10
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.preferredHeight: 60
            Text {
                text: qsTr("记账攻略")
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
            id: homeGridLayout2
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: '#f8f1f1'
            radius: 10
            Flickable {
                id: homeScrollView2
                anchors.fill: parent
                contentWidth: homeGridLayout2Grid.width
                contentHeight: homeGridLayout2Grid.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {
                    position: ScrollBar.AsNeeded
                }
                GridLayout {
                    id: homeGridLayout2Grid
                    columns: homeGridLayout2.width / 220
                    Rectangle {
                        Layout.preferredWidth: 220
                        Layout.preferredHeight: 200
                        color: "#d0d0d0"
                        border.width: 1
                        border.color: "#d0d0d0"
                        radius: 10
                        Text {
                            text: qsTr("默认攻略")
                            font.family: "微软雅黑"
                            font.pointSize: 20
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }
}
