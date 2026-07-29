import QtQuick
import QtQuick.Layouts

import "../.."
import "../../services" as Services

Rectangle {
    id: controlBar

    readonly property int barHeight: 50

    readonly property int hPadding: 8
    readonly property int vPadding: 8

    color: Colors.md3.surface_container_high
    radius: height / 2

    Layout.alignment: Qt.AlignTop
    Layout.fillWidth: true
    Layout.preferredHeight: controlBar.barHeight

    RowLayout {
        x: controlBar.hPadding
        y: controlBar.vPadding
        width: parent.width - (2 * controlBar.hPadding)
        height: parent.height - (2 * controlBar.vPadding)

        Rectangle {
            color: Services.Network.isWifiChanging ? Colors.md3.surface_container_low : Services.Network.isWifiOn ? Colors.md3.error_container : Colors.md3.primary
            radius: height / 2

            Layout.fillHeight: true
            Layout.preferredWidth: height

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: !Services.Network.isWifiChanging
            }

            Behavior on color {
                ColorAnimation {
                    duration: 250
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                anchors.centerIn: parent

                font {
                    family: "VictorMono Nerd Font Propo 10"
                    pointSize: 16
                }

                color: Services.Network.isWifiChanging ? Colors.md3.surface_bright : Services.Network.isWifiOn ? Colors.md3.on_error_container : Colors.md3.on_primary
                text: Icons.power
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Rectangle {
            color: Services.Network.isWifiListing ? Colors.md3.surface_container_low : Colors.md3.primary
            radius: height / 2

            Layout.fillHeight: true
            Layout.preferredWidth: height

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: !Services.Network.isWifiChanging

                onClicked: {
                    Services.Network.fn.listNetworks();
                    spin.start();
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 250
                    easing.type: Easing.OutQuad
                }
            }

            Text {
                id: icon
                anchors.centerIn: parent

                font {
                    family: "VictorMono Nerd Font Propo 10"
                    pointSize: 16
                }

                color: Services.Network.isWifiListing ? Colors.md3.surface_bright : Colors.md3.on_primary
                text: Icons.refresh

                NumberAnimation {
                    id: spin
                    from: 0
                    to: 360
                    target: icon
                    property: "rotation"
                    easing.type: Easing.InQuad
                    duration: 500
                }
            }
        }
        Item {
            Layout.fillWidth: true
        }
        Rectangle {
            color: Colors.md3.primary
            radius: height / 2

            Layout.fillHeight: true
            Layout.preferredWidth: height
        }
    }
}
