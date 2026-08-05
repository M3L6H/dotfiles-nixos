import QtQuick

import ".."

Rectangle {
    id: badge

    required property string key
    required property bool show

    anchors.horizontalCenter: parent.right
    anchors.verticalCenter: parent.bottom
    anchors.verticalCenterOffset: -2

    implicitHeight: 16
    implicitWidth: 16
    radius: height / 2
    visible: show

    color: Colors.md3.tertiary

    Text {
        anchors.centerIn: parent

        font {
            family: "VictorMono Nerd Font Propo 10"
            pointSize: 10
        }

        color: Colors.md3.on_tertiary
        text: badge.key
    }
}
