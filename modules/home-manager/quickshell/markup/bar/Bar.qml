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
    }

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        Rectangle {
            id: systemRoot

            readonly property int hPadding: 4
            readonly property int vPadding: 2

            color: Colors.md3.surface_container
            radius: height / 2

            Layout.margins: 6
            Layout.preferredHeight: rightBarLayout.implicitHeight
            Layout.preferredWidth: rightBarLayout.implicitWidth
            Layout.minimumWidth: height

            RowLayout {
                id: rightBarLayout

                Components.Battery {}
            }
        }
    }
}
