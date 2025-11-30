import QtQuick
import QtQuick.Controls

Item {
    id: settingItem
    anchors.fill: parent

    Popup {
        id: popup
        width: parent.width
        height: parent.height
        modal: true
        dim: true
        anchors.centerIn: parent
        background: Rectangle {
            color: '#f8f1f1'
            anchors.fill: parent
        }
        Text {
            text: qsTr("告诉你没有了还点！！！")
            font.family: "微软雅黑"
            font.pointSize: 20
            font.bold: false
            anchors.centerIn: parent
        }
        AnimatedImage {
            id: popupAnimation
            source: "qrc:/image/cat.gif"
            anchors.centerIn: parent
            anchors.fill: parent
            NumberAnimation {
                target: popup
                property: "opacity"
                duration: 200
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: '#f8f1f1'
        radius: 10
        Text {
            text: qsTr("没有设置呢")
            font.family: "微软雅黑"
            font.pointSize: 20
            font.bold: true
            anchors.centerIn: parent
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                popup.open();
            }
        }
    }
}
