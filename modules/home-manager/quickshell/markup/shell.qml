import QtQuick

import Quickshell

import "bar" as Bar
import "panels/network" as Network

ShellRoot {
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

        Network.NetworkPanel {
            anchorWin: barWin
            anchorItem: bar.externalNetworkId
        }
    }
}
