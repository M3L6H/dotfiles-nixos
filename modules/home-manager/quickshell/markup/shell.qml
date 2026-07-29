import QtQuick
import QtQuick.Layouts

import Quickshell

import "bar" as Bar
import "panels" as Panels

ShellRoot {
    Panels.NetworkPanel {
        anchorWin: barWin
        anchorItem: bar.externalNetworkId
    }

    // qmllint disable uncreatable-type
    PanelWindow {
        id: barWin

        anchors {
            top: true
            left: true
            right: true
        }

        color: "transparent"

        implicitHeight: 36

        Bar.Bar {
            id: bar
        }
    }
}
