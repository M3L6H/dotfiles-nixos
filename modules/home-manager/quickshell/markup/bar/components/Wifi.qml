import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../.."

Rectangle {
    color: Colors.md3.surface_container
    radius: height / 2

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

            readonly property int updateInterval: 5000
            readonly property bool connected: ethernet || wifi

            property bool ethernet
            property bool wifi
            property int strength
            property string network

            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.preferredWidth: wifiText.width
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

            Timer {
                interval: wifiRoot.updateInterval
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    wifiProc.running = true;
                    strengthProc.running = true;
                    ethernetProc.running = true;
                }
            }

            Text {
                id: wifiText

                font {
                    family: "VictorMono Nerd Font Propo 10"
                    pointSize: 12
                }

                color: wifiRoot.connected ? Colors.md3.secondary : Colors.md3.error
                elide: wifiRoot.wifi ? Text.ElideRight : Text.ElideNone
                width: wifiRoot.wifi ? 100 : 16
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
        }
    }
}
