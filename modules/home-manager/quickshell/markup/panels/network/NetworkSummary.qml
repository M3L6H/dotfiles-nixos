import QtQuick
import QtQuick.Layouts

import "../.."
import "../../services" as Services

RowLayout {
    ColumnLayout {
        Text {
            readonly property string down: Services.Network.fn.formatBpS(Services.Network.downBpS)
            readonly property string maxDown: Services.Network.fn.formatBpS(Services.Network.maxDownBpS)

            color: Colors.md3.on_surface

            font {
                family: "VictorMono Nerd Font Propo 10"
                pointSize: 8
            }

            text: `${Icons.download} ${Services.Network.isConnected ? down : '0 B/s'} (${Services.Network.isConnected ? maxDown : '0 B/s'})`

            horizontalAlignment: Text.AlignLeft
        }

        Text {
            readonly property string up: Services.Network.fn.formatBpS(Services.Network.upBpS)
            readonly property string maxUp: Services.Network.fn.formatBpS(Services.Network.maxUpBpS)

            color: Colors.md3.on_surface

            font {
                family: "VictorMono Nerd Font Propo 10"
                pointSize: 8
            }

            text: `${Icons.upload} ${Services.Network.isConnected ? up : '0 B/s'} (${Services.Network.isConnected ? maxUp : '0 B/s'})`

            horizontalAlignment: Text.AlignLeft
        }
    }

    Item {
        Layout.fillWidth: true
    }

    ColumnLayout {
        Text {
            color: Colors.md3.on_surface

            font {
                family: "VictorMono Nerd Font Propo 10"
                pointSize: 8
            }

            text: Services.Network.isConnected ? Services.Network.latency : "--"

            horizontalAlignment: Text.AlignRight

            Layout.fillWidth: true
        }
        Text {
            color: Colors.md3.on_surface

            font {
                family: "VictorMono Nerd Font Propo 10"
                pointSize: 8
            }

            text: Services.Network.isConnected ? Services.Network.privateIp : "--"

            horizontalAlignment: Text.AlignRight

            Layout.fillWidth: true
        }
    }
}
