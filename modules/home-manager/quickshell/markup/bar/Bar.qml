import QtQuick
import QtQuick.Layouts

import ".."

import "components" as Components

Item {
    id: bar

    anchors.fill: parent

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }

        Components.Tags {}
        Components.System {}
    }

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        Components.Network {}
        Components.Battery {}
        Components.DateTime {}
    }
}
