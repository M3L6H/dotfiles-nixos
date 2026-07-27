import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../.."

Item {
    id: batteryRoot

    property bool charging
    property int percentage

    Layout.alignment: Qt.AlignCenter
    Layout.fillHeight: true
    Layout.preferredWidth: batText.implicitWidth
    Layout.rightMargin: 16
    Layout.leftMargin: 16

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

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: batProc.running = true
    }

    Text {
        id: batText

        font {
            family: "VictorMono Nerd Font Propo 10"
            pointSize: 12
        }

        color: Colors.md3.tertiary
        text: {
            if (batteryRoot.charging) {
                if (batteryRoot.percentage > 95) {
                    return Icons.batteryChg100;
                } else if (batteryRoot.percentage > 85) {
                    return Icons.batteryChg90;
                } else if (batteryRoot.percentage > 75) {
                    return Icons.batteryChg80;
                } else if (batteryRoot.percentage > 65) {
                    return Icons.batteryChg70;
                } else if (batteryRoot.percentage > 55) {
                    return Icons.batteryChg60;
                } else if (batteryRoot.percentage > 45) {
                    return Icons.batteryChg50;
                } else if (batteryRoot.percentage > 35) {
                    return Icons.batteryChg40;
                } else if (batteryRoot.percentage > 25) {
                    return Icons.batteryChg30;
                } else if (batteryRoot.percentage > 15) {
                    return Icons.batteryChg20;
                } else if (batteryRoot.percentage > 5) {
                    return Icons.batteryChg10;
                } else {
                    return Icons.batteryChg00;
                }
            } else {
                if (batteryRoot.percentage > 95) {
                    return Icons.battery100;
                } else if (batteryRoot.percentage > 85) {
                    return Icons.battery90;
                } else if (batteryRoot.percentage > 75) {
                    return Icons.battery80;
                } else if (batteryRoot.percentage > 65) {
                    return Icons.battery70;
                } else if (batteryRoot.percentage > 55) {
                    return Icons.battery60;
                } else if (batteryRoot.percentage > 45) {
                    return Icons.battery50;
                } else if (batteryRoot.percentage > 35) {
                    return Icons.battery40;
                } else if (batteryRoot.percentage > 25) {
                    return Icons.battery30;
                } else if (batteryRoot.percentage > 15) {
                    return Icons.battery20;
                } else if (batteryRoot.percentage > 5) {
                    return Icons.battery10;
                } else {
                    return Icons.battery00;
                }
            }
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
