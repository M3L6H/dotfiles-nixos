pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: dateTimeSvc

    readonly property string altTz: "Asia/Singapore"
    readonly property int updateInterval: 1000

    property string date
    property int hour
    property int minute
    property int second
    property int altHour

    Process {
        id: dateTimeProc

        command: ["zsh", "-c", "date '+%d %H:%M:%S'"]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.split(" ");
                dateTimeSvc.date = parts[0];
                const [hour, minute, second] = parts[1].split(":");
                dateTimeSvc.hour = parseInt(hour);
                dateTimeSvc.minute = parseInt(minute);
                dateTimeSvc.second = parseInt(second);
            }
        }
    }

    Process {
        id: altDtProc

        command: ["zsh", "-c", "date '+%H'"]
        // qmllint disable incompatible-type
        environment: ({
                TZ: dateTimeSvc.altTz
            })

        stdout: SplitParser {
            onRead: data => {
                dateTimeSvc.altHour = parseInt(data.trim());
            }
        }
    }

    Timer {
        interval: dateTimeSvc.updateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            altDtProc.running = true;
            dateTimeProc.running = true;
        }
    }
}
