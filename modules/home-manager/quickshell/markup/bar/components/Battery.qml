import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "../.."

Rectangle {
    color: Colors.md3.surface_container
    radius: height / 2

    Layout.margins: 6
    Layout.leftMargin: 0
    Layout.fillHeight: true
    Layout.preferredWidth: batteryLayout.implicitWidth + 16
    Layout.minimumWidth: height

    RowLayout {
        id: batteryLayout

        anchors.fill: parent
        spacing: 4

        Item {
            id: batteryRoot

            readonly property int maxSamples: 10

            property bool charging
            property int percentage
            property var remainingSamples: []
            property int remaining

            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.preferredWidth: batText.implicitWidth
            Layout.leftMargin: 2
            Layout.rightMargin: 2

            Process {
                id: batProc

                command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT0/capacity) $(cat /sys/class/power_supply/BAT0/status)"]

                stdout: SplitParser {
                    onRead: data => {
                        const parts = data.trim().split(" ");
                        if (parts.length >= 2) {
                            batteryRoot.percentage = parseInt(parts[0]) || 0;
                            batteryRoot.charging = parts[1] !== "Discharging";
                        }
                    }
                }
            }

            Process {
                id: remainingProc

                command: ["sh", "-c", "acpi -i | awk 'NR==1{ print $5; }'"]

                stdout: SplitParser {
                    onRead: data => {
                        if (!data) {
                            return;
                        }
                        const parts = data.split(':');
                        const h = parseInt(parts[0]);
                        const m = parseInt(parts[1]);
                        const remainingRaw = h * 60 + m;

                        batteryRoot.remainingSamples.push(remainingRaw);

                        if (batteryRoot.remainingSamples.length > batteryRoot.maxSamples) {
                            batteryRoot.remainingSamples.shift();
                        }

                        batteryRoot.remaining = batteryRoot.remainingSamples.reduce((acc, curr) => acc + curr, 0) / batteryRoot.remainingSamples.length;
                    }
                }
            }

            Timer {
                interval: 5000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    batProc.running = true;
                    remainingProc.running = true;
                }
            }

            Text {
                id: batText

                readonly property var chgIcons: [Icons.batteryChg100, Icons.batteryChg90, Icons.batteryChg80, Icons.batteryChg70, Icons.batteryChg60, Icons.batteryChg50, Icons.batteryChg40, Icons.batteryChg30, Icons.batteryChg20, Icons.batteryChg10, Icons.batteryChg00]
                readonly property var dischgIcons: [Icons.battery100, Icons.battery90, Icons.battery80, Icons.battery70, Icons.battery60, Icons.battery50, Icons.battery40, Icons.battery30, Icons.battery20, Icons.battery10, Icons.battery00]

                font {
                    family: "VictorMono Nerd Font Propo 10"
                    pointSize: 12
                }

                color: batteryRoot.percentage < 20 ? Colors.md3.tertiary : Colors.md3.secondary
                text: {
                    if (batteryRoot.charging) {
                        return `${getIcon(batteryRoot.percentage, chgIcons)} ${batteryRoot.percentage}%`;
                    } else {
                        return `${getIcon(batteryRoot.percentage, dischgIcons)} ${batteryRoot.remaining}m`;
                    }
                }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                function getIcon(pct, icons) {
                    let currPct = 95;
                    for (const icon of icons) {
                        if (pct > currPct) {
                            return icon;
                        }
                        currPct -= 5;
                    }
                }
            }
        }
    }
}
