pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../.."
import "../../services" as Services

ScrollView {
    id: networksScroll

    clip: true

    Layout.fillHeight: true
    Layout.fillWidth: true

    ListView {
        id: networksList

        readonly property int scrollPadding: 12

        spacing: 4

        model: Services.Network.networksModel

        delegate: Rectangle {
            id: networkEntry

            readonly property int hPadding: 12
            readonly property int vPadding: 4

            required property string ssid
            required property string rate
            required property int signal
            required property string security

            color: entryMouseArea.containsMouse ? Colors.md3.inverse_surface : "transparent"

            implicitWidth: networksList.width - networksList.scrollPadding
            implicitHeight: 36
            radius: height / 2

            MouseArea {
                id: entryMouseArea
                enabled: Services.Network.isWifiOn

                anchors.fill: parent
                cursorShape: Services.Network.isWifiOn ? Qt.PointingHandCursor : Qt.ArrowCursor
                hoverEnabled: Services.Network.isWifiOn
            }

            RowLayout {
                id: networkLayout

                readonly property var textColor: {
                    if (!Services.Network.isWifiOn) {
                        return Colors.md3.surface_container_highest;
                    } else if (entryMouseArea.containsMouse) {
                        return Colors.md3.inverse_on_surface;
                    } else if (networkEntry.ssid === Services.Network.network) {
                        return Colors.md3.tertiary;
                    }
                    return Colors.md3.on_surface;
                }

                x: networkEntry.hPadding
                y: networkEntry.vPadding
                height: parent.height - (2 * networkEntry.vPadding)
                width: parent.width - (2 * networkEntry.hPadding)

                Text {
                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 10
                    }

                    color: networkLayout.textColor
                    elide: Qt.ElideRight
                    text: `${Services.Network.fn.getStrengthIcon(networkEntry.signal)}  ${networkEntry.ssid}`

                    verticalAlignment: Text.AlignVCenter

                    Layout.preferredWidth: 120
                }

                Text {
                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 10
                    }

                    color: networkLayout.textColor
                    text: networkEntry.rate

                    verticalAlignment: Text.AlignVCenter

                    Layout.preferredWidth: 50
                }

                Text {
                    font {
                        family: "VictorMono Nerd Font Propo 10"
                        pointSize: 14
                    }

                    color: networkLayout.textColor
                    text: {
                        const security = networkEntry.security.split(' ').filter(str => !!str);
                        if (security.length === 0) {
                            return '󰿆 ';
                        }

                        return security.map(s => Services.Network.fn.getSecurityIcon(s)).join(' ');
                    }

                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter

                    Layout.fillWidth: true
                }
            }
        }
    }
}
