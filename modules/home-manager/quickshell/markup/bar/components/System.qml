import QtQuick
import QtQuick.Layouts

import "../.."

Rectangle {
    id: systemRoot

    color: Colors.md3.surface_container
    radius: height / 2

    Layout.margins: 6
    Layout.leftMargin: 0
    Layout.fillHeight: true
    Layout.preferredWidth: rightBarLayout.implicitWidth + 16
    Layout.minimumWidth: height

    RowLayout {
        id: rightBarLayout

        anchors.fill: parent
        spacing: 4

        Cpu {}
        Ram {}
        Disk {}
    }
}
