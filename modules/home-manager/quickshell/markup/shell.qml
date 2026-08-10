import QtQuick

import Quickshell

import "bar"
import "panels/network" as Network

ShellRoot {
    Variants {
        model: Quickshell.screens

        // qmllint disable uncreatable-type
        PanelWindow {
            id: barWin

            required property ShellScreen modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent"
            implicitHeight: 36

            Bar {
                id: bar
                screen: barWin.modelData
            }

            Network.NetworkPanel {
                anchorWin: barWin
                anchorItem: bar.externalNetworkId
                screen: barWin.modelData
            }
        }
    }
}
