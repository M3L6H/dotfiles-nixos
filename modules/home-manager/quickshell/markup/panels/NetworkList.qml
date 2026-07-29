pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import ".."
import "../services" as Services

ScrollView {
    id: networksScroll

    clip: true
    visible: Services.Network.isWifiOn

    Layout.fillHeight: true
    Layout.fillWidth: true

    ListView {
        id: networksList

        spacing: 4

        model: Services.Network.networksModel

        delegate: Rectangle {
            id: networkEntry

            readonly property int hPadding: 8
            readonly property int vPadding: 4

            required property string ssid

            color: entryMouseArea.containsMouse ? Colors.md3.inverse_surface : "transparent"

            implicitWidth: networksList.width
            implicitHeight: 36
            radius: height / 2

            MouseArea {
                id: entryMouseArea

                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
            }

            RowLayout {
                id: networkLayout

                x: networkEntry.hPadding
                y: networkEntry.vPadding
                height: parent.height - (2 * networkEntry.vPadding)

                Text {
                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 10
                    }

                    color: entryMouseArea.containsMouse ? Colors.md3.inverse_on_surface : Colors.md3.on_surface
                    text: networkEntry.ssid

                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
