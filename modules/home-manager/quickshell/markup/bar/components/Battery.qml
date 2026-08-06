import QtQuick
import QtQuick.Layouts

import "../.."
import "../../services" as Services

Rectangle {
    id: batteryContainer

    color: Colors.md3.surface_container
    radius: height / 2
    visible: Services.Battery.hasBattery

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

            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.preferredWidth: batText.implicitWidth
            Layout.leftMargin: 2
            Layout.rightMargin: 2

            Text {
                id: batText

                readonly property var chgIcons: [Icons.batteryChg100, Icons.batteryChg90, Icons.batteryChg80, Icons.batteryChg70, Icons.batteryChg60, Icons.batteryChg50, Icons.batteryChg40, Icons.batteryChg30, Icons.batteryChg20, Icons.batteryChg10, Icons.batteryChg00]
                readonly property var dischgIcons: [Icons.battery100, Icons.battery90, Icons.battery80, Icons.battery70, Icons.battery60, Icons.battery50, Icons.battery40, Icons.battery30, Icons.battery20, Icons.battery10, Icons.battery00]

                font {
                    family: "VictorMono Nerd Font Propo 10"
                    pointSize: 12
                }

                color: Services.Battery.percentage < 20 ? Colors.md3.tertiary : Colors.md3.secondary
                text: {
                    if (Services.Battery.charging) {
                        return `${getIcon(Services.Battery.percentage, chgIcons)} ${Services.Battery.percentage}%`;
                    } else {
                        return `${getIcon(Services.Battery.percentage, dischgIcons)} ${Services.Battery.remaining}m`;
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
                        currPct -= 10;
                    }
                }
            }
        }
    }
}
