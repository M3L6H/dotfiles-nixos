import QtQuick
import QtQuick.Layouts

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
    }
}
