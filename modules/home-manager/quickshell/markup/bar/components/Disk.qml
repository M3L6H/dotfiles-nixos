import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../services" as Services

import "../.."

Item {
    id: diskRoot

    Layout.alignment: Qt.AlignCenter
    Layout.fillHeight: true
    Layout.preferredWidth: diskLayout.implicitWidth
    Layout.rightMargin: 2

    RowLayout {
        id: diskLayout

        anchors.fill: parent

        Repeater {
            model: Services.System.disks

            delegate: Text {
                id: diskText

                required property real modelData

                font {
                    family: "VictorMono Nerd Font Propo 10"
                    pointSize: 12
                }

                color: modelData > 90 ? Colors.md3.tertiary : Colors.md3.secondary
                text: {
                    ` ${Math.floor(modelData)}%`;
                }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
