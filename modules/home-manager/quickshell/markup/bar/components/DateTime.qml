import QtQuick
import QtQuick.Layouts

import "../.."
import "../../services" as Services

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

            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.preferredWidth: innerDateTimeLayout.implicitWidth
            Layout.rightMargin: 8
            Layout.leftMargin: 8

            RowLayout {
                id: innerDateTimeLayout

                anchors.fill: parent
                spacing: 12

                Text {
                    id: timeText

                    readonly property string hr: String(Services.DateTime.hour).padStart(2, "0")
                    readonly property string altHr: String(Services.DateTime.altHour).padStart(2, "0")
                    readonly property string min: String(Services.DateTime.minute).padStart(2, "0")
                    readonly property string sec: String(Services.DateTime.second).padStart(2, "0")

                    Layout.fillHeight: true

                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 12
                    }

                    color: Colors.md3.secondary
                    text: `${Icons.clock} ${hr}[<font color="${Colors.md3.tertiary}">${altHr}</font>]:${min}:${sec}`
                    textFormat: Text.StyledText

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
                        `${Icons.calendar} ${Services.DateTime.date}`;
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
