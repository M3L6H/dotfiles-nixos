import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../.."

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

            readonly property int updateInterval: 2000
            readonly property bool connected: ethernet || wifi

            property bool ethernet
            property bool wifi
            property int strength
            property string network
            property bool vpn
            property string vpnHost

            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.preferredWidth: innerLayout.implicitWidth
            Layout.leftMargin: 2
            Layout.rightMargin: 2

            Process {
                id: wifiProc

                command: ["sh", "-c", "nmcli d | awk '$2==\"wifi\"{ print $3 \" \" $4; }'"]

                stdout: SplitParser {
                    onRead: data => {
                        const parts = data.split(" ");
                        wifiRoot.wifi = parts[0] === 'connected';
                        wifiRoot.network = parts[1];
                    }
                }
            }

            Process {
                id: strengthProc

                command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL d wifi | grep '^*' | awk '{ print $2; }'"]

                stdout: SplitParser {
                    onRead: data => wifiRoot.strength = parseInt(data)
                }
            }

            Process {
                id: ethernetProc

                command: ["sh", "-c", "nmcli d | awk '$2==\"ethernet\"{ print $3; }'"]

                stdout: SplitParser {
                    onRead: data => {
                        wifiRoot.ethernet = data === 'connected';
                    }
                }
            }

            Process {
                id: vpnProc

                command: ["sh", "-c", "nordvpn status"]

                stdout: StdioCollector {
                    onStreamFinished: () => {
                        const lines = text.split('\n');
                        const details = {};

                        for (const line of lines) {
                            const [key, value] = line.split(': ');
                            details[key.toLowerCase()] = value;
                        }

                        wifiRoot.vpn = details.status === 'Connected';
                        wifiRoot.vpnHost = wifiRoot.vpn ? details.hostname.split('.')[0] : '';
                    }
                }
            }

            Timer {
                interval: wifiRoot.updateInterval
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    wifiProc.running = true;
                    strengthProc.running = true;
                    ethernetProc.running = true;
                    vpnProc.running = true;
                }
            }

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

                    color: wifiRoot.connected ? Colors.md3.secondary : Colors.md3.error
                    clip: true
                    elide: wifiRoot.wifi ? Text.ElideRight : Text.ElideNone
                    text: {
                        if (wifiRoot.ethernet) {
                            return '󰈀 ';
                        } else if (wifiRoot.wifi) {
                            return `${getIcon(wifiRoot.strength, ['󰤨', '󰤥', '󰤢', '󰤟'])} ${wifiRoot.network}`;
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

                    Layout.preferredWidth: wifiRoot.wifi ? 100 : 16

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: togglePanel.running = true
                    }

                    function getIcon(strength, icons) {
                        const step = 100 / icons.length;
                        let currPct = 100 - step;
                        for (const icon of icons) {
                            if (strength > currPct) {
                                return icon;
                            }
                            currPct -= step;
                        }

                        return '󰤯';
                    }
                }

                Text {
                    id: vpnText

                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 12
                    }

                    color: wifiRoot.vpn ? Colors.md3.secondary : Colors.md3.error
                    clip: true

                    text: {
                        return `󰖂 ${wifiRoot.vpn ? wifiRoot.vpnHost : ''}`;
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
        command: ["qs", "-p", "/etc/nixos/modules/home-manager/quickshell/markup", "ipc", "call", "panelRoot", "toggleOpen"]
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
