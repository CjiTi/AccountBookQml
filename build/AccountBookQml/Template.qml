import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: template
    anchors.fill: parent

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
                color: '#e6e1e1'
                radius: 10
                Loader {
                    id: contentLoader
                    source: "Personal.qml"
                    anchors.fill: parent
                }
            }
        }
    }
}
