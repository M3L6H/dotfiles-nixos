pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: batterySvc

    readonly property int maxSamples: 10

    property bool hasBattery: false
    property int percentage: 0
    property bool charging: false
    property var remainingSamples: []
    property int remaining: 0

    Process {
        id: hasBat

        command: ["sh", "-c", "file /sys/class/power_supply/BAT0"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                batterySvc.hasBattery = !data.includes("cannot open");
            }
        }
    }

    Process {
        id: batProc

        command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT0/capacity) $(cat /sys/class/power_supply/BAT0/status)"]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ");
                if (parts.length >= 2) {
                    batterySvc.percentage = parseInt(parts[0]) || 0;
                    batterySvc.charging = parts[1] !== "Discharging";
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

                batterySvc.remainingSamples.push(remainingRaw);

                if (batterySvc.remainingSamples.length > batterySvc.maxSamples) {
                    batterySvc.remainingSamples.shift();
                }

                batterySvc.remaining = batterySvc.remainingSamples.reduce((acc, curr) => acc + curr, 0) / batterySvc.remainingSamples.length;
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
}
