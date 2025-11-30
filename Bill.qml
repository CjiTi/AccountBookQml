import QtQuick
import QtQuick.Layouts

Item {
    id: billItem


    Rectangle {
        id: billRect
        anchors.fill: parent
        color: '#f8f1f1'
        radius: 10
        ColumnLayout {
            anchors.fill: parent
            spacing: 10
            // 标题栏
            Rectangle {
                id: tabBarRect
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: "#f0f0f0"
                border.width: 1
                border.color: "#d0d0d0"

                property var selected: null

                Row {
                    anchors.centerIn: parent
                    Rectangle {
                        id: personalRect
                        height: 35
                        width: 80
                        color: "transparent"
                        Text {
                            text: "概况"
                            font.pointSize: 16
                            color: tabBarRect.selected === personalRect ? "#000000" : "#808080"
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("概况被点击");
                                tabBarRect.setSelected();
                                tabBarRect.selected = personalRect;
                                contentLoader.source = "Summary.qml";
                            }
                        }
                    }
                    Rectangle {
                        id: familyRect
                        height: 35
                        width: 80
                        color: "transparent"
                        Text {
                            text: "记一笔"
                            font.pointSize: 16
                            color: tabBarRect.selected === familyRect ? "#000000" : "#808080"
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("记帐被点击");
                                tabBarRect.setSelected();
                                tabBarRect.selected = familyRect;
                                contentLoader.source = "Bookkeeping.qml";
                            }
                        }
                    }
                }
                function setSelected() {
                    tabBarRect.selected = null;
                }
            }
            Item {
                id: billContentItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Loader {
                    id: contentLoader
                    source: "Summary.qml"
                    anchors.fill: parent
                }
            }
        }
    }
}
