pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: stats

    readonly property int systemInterval: 2000

    property real cpu: 0
    property real ram: 0
    property var disks: 0
    property real temp: 0
    property string uptime: "0h 0m"

    property int brightness: 0
    property int lastBrightness: -1

    Timer {
        interval: stats.systemInterval
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            ramProc.running = true;
            diskProc.running = true;
            tempProc.running = true;
            uptimeProc.running = true;
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            brightnessProc.running = true;
        }
    }

    Process {
        id: cpuProc
        command: ["zsh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print 100-$8}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: stats.cpu = parseFloat(text) || 0
        }
    }

    Process {
        id: ramProc
        command: ["zsh", "-c", "free | awk '/Mem:/ {print $3/$2 * 100.0}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: stats.ram = parseFloat(text) || 0
        }
    }

    Process {
        id: diskProc
        command: ["zsh", "-c", "df -h / /mnt/files | awk 'NR>1 {print $5}' | sed 's/%//'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: stats.disks = text.split(/\s+/).filter(s => !!s.trim()).map(s => parseFloat(s)) || [0]
        }
    }

    Process {
        id: tempProc
        command: ["zsh", "-c", "acpi --thermal | awk 'NR==1{ print $4; }'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: stats.temp = parseFloat(text) || 0
        }
    }

    Process {
        id: uptimeProc
        command: ["zsh", "-c", "cat /proc/uptime | awk '{print int($1)}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                let seconds = parseInt(text) || 0;
                let hours = Math.floor(seconds / 3600);
                let minutes = Math.floor((seconds % 3600) / 60);
                stats.uptime = hours + "h " + minutes + "m";
            }
        }
    }

    Process {
        id: brightnessProc
        command: ["zsh", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let v = parseInt(text) || 0;
                stats.brightness = v;
            }
        }
    }
}
