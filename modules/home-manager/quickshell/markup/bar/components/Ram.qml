import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../../services" as Services

import "../.."

Item {
    id: ramRoot

    Layout.alignment: Qt.AlignCenter
    Layout.fillHeight: true
    Layout.preferredWidth: ramText.implicitWidth

    Text {
        id: ramText

        font {
            family: "VictorMono Nerd Font Propo 10"
            pointSize: 12
        }

        color: Services.System.ram > 80 ? Colors.md3.tertiary : Colors.md3.secondary
        text: {
            ` ${Math.floor(Services.System.ram)}%`;
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
