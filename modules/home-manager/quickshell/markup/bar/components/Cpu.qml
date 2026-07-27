import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../services" as Services

import "../.."

Item {
    id: cpuRoot

    Layout.alignment: Qt.AlignCenter
    Layout.fillHeight: true
    Layout.preferredWidth: cpuText.implicitWidth
    Layout.leftMargin: 4

    Text {
        id: cpuText

        font {
            family: "VictorMono Nerd Font Propo 10"
            pointSize: 12
        }

        color: Services.System.cpu > 80 ? Colors.md3.tertiary : Colors.md3.secondary
        text: {
            ` ${Math.floor(Services.System.cpu)}%`;
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
