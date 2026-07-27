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
    Layout.preferredWidth: dateTimeLayout.implicitWidth
    Layout.minimumWidth: height

    RowLayout {
        id: dateTimeLayout

        anchors.fill: parent

        Item {
            id: dateTimeRoot

            readonly property int updateInterval: 1000

            property string date
            property string time

            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.preferredWidth: innerDateTimeLayout.implicitWidth
            Layout.rightMargin: 8
            Layout.leftMargin: 8

            Process {
                id: dateTimeProc

                command: ["zsh", "-c", "date '+%d %H:%M:%S'"]

                stdout: SplitParser {
                    onRead: data => {
                        const parts = data.split(" ");
                        dateTimeRoot.date = parts[0];
                        dateTimeRoot.time = parts[1];
                    }
                }
            }

            Timer {
                interval: dateTimeRoot.updateInterval
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: dateTimeProc.running = true
            }

            RowLayout {
                id: innerDateTimeLayout

                anchors.fill: parent
                spacing: 12

                Text {
                    id: timeText

                    Layout.fillHeight: true

                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 12
                    }

                    color: Colors.md3.secondary
                    text: dateTimeRoot.time

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: dateText

                    Layout.fillHeight: true

                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 12
                    }

                    color: Colors.md3.secondary
                    text: {
                        `󰃭 ${dateTimeRoot.date}`;
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
