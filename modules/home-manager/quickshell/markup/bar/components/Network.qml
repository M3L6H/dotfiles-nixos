import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../.."
import "../../services" as Services

Rectangle {
    id: networkPill

    readonly property real defaultRadius: height / 2

    property alias externalId: networkPill

    color: Colors.md3.surface_container
    radius: defaultRadius
    bottomLeftRadius: defaultRadius
    bottomRightRadius: defaultRadius

    Layout.margins: 6
    Layout.leftMargin: 0
    Layout.fillHeight: true
    Layout.preferredWidth: wifiLayout.implicitWidth + 16
    Layout.minimumWidth: height

    RowLayout {
        id: wifiLayout

        anchors.fill: parent
        spacing: 4

        Item {
            id: wifiRoot

            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.preferredWidth: innerLayout.implicitWidth
            Layout.leftMargin: 2
            Layout.rightMargin: 2

            RowLayout {
                id: innerLayout

                anchors.fill: parent
                spacing: 12

                Text {
                    id: wifiText

                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 12
                    }

                    color: Services.Network.isConnected ? Colors.md3.secondary : Colors.md3.error
                    clip: true
                    elide: Services.Network.isWifi ? Text.ElideRight : Text.ElideNone
                    text: {
                        if (Services.Network.isEthernet) {
                            return '󰈀 ';
                        } else if (Services.Network.isWifi) {
                            return `${Services.Network.fn.getStrengthIcon(Services.Network.strength)} ${Services.Network.network}`;
                        }

                        return '󰤮 ';
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    Behavior on Layout.preferredWidth {
                        NumberAnimation {
                            easing.type: Easing.OutCubic
                            duration: 200
                        }
                    }

                    Layout.preferredWidth: Services.Network.isWifi ? 100 : 16

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: togglePanel.running = true
                    }
                }

                Text {
                    id: vpnText

                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 12
                    }

                    color: Services.Network.isVpn ? Colors.md3.secondary : Colors.md3.error
                    clip: true

                    text: {
                        return `󰖂 ${Services.Network.isVpn ? Services.Network.vpnHost : ''}`;
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    Behavior on Layout.preferredWidth {
                        NumberAnimation {
                            easing.type: Easing.OutCubic
                            duration: 200
                        }
                    }

                    Layout.preferredWidth: implicitWidth
                }
            }
        }
    }

    Process {
        id: togglePanel
        command: ["qs", "ipc", "call", "panelRoot", "toggleOpen"]
    }

    Behavior on bottomLeftRadius {
        NumberAnimation {
            easing.type: Easing.OutQuad
            duration: 100
        }
    }

    Behavior on bottomRightRadius {
        NumberAnimation {
            easing.type: Easing.OutQuad
            duration: 100
        }
    }
}
