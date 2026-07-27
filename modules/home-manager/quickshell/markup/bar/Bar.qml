import QtQuick
import QtQuick.Layouts

import "components" as Components

Item {
    id: bar

    implicitHeight: 36
    anchors.left: parent.left
    anchors.right: parent.right

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }

        Components.Tags {}
    }
}
