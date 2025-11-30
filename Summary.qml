import QtQuick
import QtQuick.Layouts
import QtCharts

Item {
    id: summary
    anchors.fill: parent

    // 存储财务数据的属性
    property variant summaryData: []
    property variant timePeriodData: []
    property variant categoryData: [] // 存储分类数据的属性

    // 加载数据的函数
    function loadData() {
        // 获取总收入、总支出、总资产
        summaryData = AccountBookSql.calculateSummary();
        // 获取周、月、年的收入和支出
        timePeriodData = AccountBookSql.calculateSummaryByTimePeriod();
        // 获取分类数据
        categoryData = AccountBookSql.calculateSummaryByCategory();
        // 打印 summaryData 调试信息
        console.log("summaryData:", summaryData);
        // 打印 timePeriodData 调试信息
        console.log("timePeriodData:", timePeriodData);
        // 打印 categoryData 调试信息
        console.log("categoryData:", categoryData);
    }

    // 页面加载时自动加载数据
    Component.onCompleted: {
        loadData();
    }

    // 主布局
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        // 资产概况部分
        Rectangle {
            id: summaryRect
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: '#ffffff'
            radius: 10
            border.width: 1
            border.color: '#e0e0e0'

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: qsTr("资产概况")
                    font.family: "微软雅黑"
                    font.pointSize: 12
                    font.bold: true
                    color: "#333333"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#e0e0e0"
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 0

                    // 资产
                    ColumnLayout {
                        Layout.preferredWidth: summaryRect.width / 3
                        Layout.fillHeight: true

                        Text {
                            text: qsTr("收入")
                            font.family: "微软雅黑"
                            font.pointSize: 14
                            color: "#666666"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        }

                        Text {
                            text: summary.summaryData.length > 0 ? "¥" + summary.summaryData[0].toFixed(2) : "¥0.00"
                            font.family: "微软雅黑"
                            font.pointSize: 15
                            font.bold: true
                            color: "#ff6b6b"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true
                        color: "#e0e0e0"
                    }

                    // 负债
                    ColumnLayout {
                        Layout.preferredWidth: summaryRect.width / 3
                        Layout.fillHeight: true

                        Text {
                            text: qsTr("支出")
                            font.family: "微软雅黑"
                            font.pointSize: 14
                            color: "#666666"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        }

                        Text {
                            text: summary.summaryData.length > 1 ? "¥" + Math.abs(summary.summaryData[1]).toFixed(2) : "¥0.00"
                            font.family: "微软雅黑"
                            font.pointSize: 20
                            font.bold: true
                            color: "#4ecdc4"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true
                        color: "#e0e0e0"
                    }

                    // 净资产
                    ColumnLayout {
                        Layout.preferredWidth: summaryRect.width / 3
                        Layout.fillHeight: true

                        Text {
                            text: qsTr("资产")
                            font.family: "微软雅黑"
                            font.pointSize: 14
                            color: "#666666"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                        }

                        Text {
                            text: summary.summaryData.length > 2 ? "¥" + summary.summaryData[2].toFixed(2) : "¥0.00"
                            font.family: "微软雅黑"
                            font.pointSize: 20
                            font.bold: true
                            color: "#333333"
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }
                    }
                }
            }
        }

        // 收支表部分
        Rectangle {
            id: incomeExpenseRect
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            color: '#ffffff'
            radius: 10
            border.width: 1
            border.color: '#e0e0e0'

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: qsTr("收支表")
                    font.family: "微软雅黑"
                    font.pointSize: 12
                    font.bold: true
                    color: "#333333"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#e0e0e0"
                }

                // 时间标题行
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Item {
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                    }

                    Text {
                        text: qsTr("本周")
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#666666"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: qsTr("本月")
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#666666"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: qsTr("本年")
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#666666"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#e0e0e0"
                }

                // 收入行
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                        Text {
                            text: qsTr("收入")
                            font.family: "微软雅黑"
                            font.pointSize: 12
                            Layout.preferredWidth: incomeExpenseRect.width / 4
                            color: "#333333"
                        }
                    }

                    Text {
                        text: summary.timePeriodData.length > 0 ? "¥" + summary.timePeriodData[0].toFixed(2) : "¥0.00"
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#ff6b6b"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: summary.timePeriodData.length > 2 ? "¥" + summary.timePeriodData[2].toFixed(2) : "¥0.00"
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#ff6b6b"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: summary.timePeriodData.length > 4 ? "¥" + summary.timePeriodData[4].toFixed(2) : "¥0.00"
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#ff6b6b"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#e0e0e0"
                }

                // 支出行
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                        Text {
                            text: qsTr("支出")
                            font.family: "微软雅黑"
                            font.pointSize: 12
                            Layout.preferredWidth: incomeExpenseRect.width / 4
                            color: "#333333"
                        }
                    }

                    Text {
                        text: summary.timePeriodData.length > 1 ? "¥" + Math.abs(summary.timePeriodData[1]).toFixed(2) : "¥0.00"
                        font.family: "微软雅黑"
                        font.pointSize: 14
                        color: "#4ecdc4"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: summary.timePeriodData.length > 3 ? "¥" + Math.abs(summary.timePeriodData[3]).toFixed(2) : "¥0.00"
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#4ecdc4"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: summary.timePeriodData.length > 5 ? "¥" + Math.abs(summary.timePeriodData[5]).toFixed(2) : "¥0.00"
                        font.family: "微软雅黑"
                        font.pointSize: 12
                        color: "#4ecdc4"
                        Layout.preferredWidth: incomeExpenseRect.width / 4
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }

        // 本月分类支出饼图部分
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: '#ffffff'
            radius: 10
            border.width: 1
            border.color: '#e0e0e0'

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: qsTr("本月分类支出")
                    font.family: "微软雅黑"
                    font.pointSize: 12
                    font.bold: true
                    color: "#333333"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: "#e0e0e0"
                }
                RowLayout {
                    Layout.fillWidth: true

                    // 饼图组件
                    ChartView {
                        id: expensePieChart
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        antialiasing: true

                        PieSeries {
                            id: pieSeries
                            name: "支出分类"

                            // 使用从数据库获取的真实数据
                            PieSlice {
                                id: foodSlice
                                label: "餐饮"
                                value: summary.timePeriodData.length > 1 ? Math.abs(summary.timePeriodData[1]).toFixed(2) : 0
                                color: "#ff6b6b"
                            }

                            PieSlice {
                                id: transportationSlice
                                label: "交通"
                                value: summary.timePeriodData.length > 2 ? Math.abs(summary.timePeriodData[2]).toFixed(2) : 0
                                color: "#4ecdc4"
                            }

                            PieSlice {
                                id: shoppingSlice
                                label: "医疗"
                                value: summary.timePeriodData.length > 3 ? Math.abs(summary.timePeriodData[3]).toFixed(2) : 0
                                color: "#45b7d1"
                            }

                            PieSlice {
                                id: othersSlice
                                label: "其他"
                                value: summary.timePeriodData.length > 4 ? Math.abs(summary.timePeriodData[4]).toFixed(2) : 0
                                color: "#feca57"
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        color: "#e0e0e0"
                    }
                    ChartView {
                        id: incomePieChart
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        antialiasing: true

                        PieSeries {
                            id: incomePieSeries
                            name: "收入分类"

                            // 使用从数据库获取的真实数据
                            PieSlice {
                                id: incomeSlice
                                label: "工资"
                                value: summary.timePeriodData.length > 4 ? Math.abs(summary.timePeriodData[4]).toFixed(2) : 0
                                color: "#ff6b6b"
                            }

                            PieSlice {
                                id: bonusSlice
                                label: "奖金"
                                value: summary.timePeriodData.length > 5 ? Math.abs(summary.timePeriodData[5]).toFixed(2) : 0
                                color: "#4ecdc4"
                            }

                            PieSlice {
                                id: investmentSlice
                                label: "投资"
                                value: summary.timePeriodData.length > 6 ? Math.abs(summary.timePeriodData[6]).toFixed(2) : 0
                                color: "#45b7d1"
                            }

                            PieSlice {
                                id: othersIncomeSlice
                                label: "其他"
                                value: summary.timePeriodData.length > 7 ? Math.abs(summary.timePeriodData[7]).toFixed(2) : 0
                                color: "#96ceb4"
                            }
                        }
                    }
                }
            }
        }
    }
}
