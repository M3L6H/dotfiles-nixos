import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io

import ".."
import "../services" as Services

PopupWindow {
    id: panelRoot

    readonly property int defaultHeight: 300
    readonly property int controlBarHeight: 50
    readonly property real radius: anchorItem.height / 2

    required property var anchorWin
    required property Item anchorItem

    property bool opened: false

    onOpenedChanged: {
        if (opened) {
            Services.Network.fn.checkIsWifiOn();
            Services.Network.fn.listNetworks();

            visible = true;
            anchorItem.bottomLeftRadius = 0;
            anchorItem.bottomRightRadius = 0;

            openAnim.restart();
        } else {
            closeAnim.restart();
        }
    }

    function close() {
        opened = false;
    }

    anchor.window: anchorWin
    anchor.item: anchorItem
    anchor.rect.x: anchorItem.width
    anchor.rect.y: 0
    // qmllint disable missing-type
    anchor.gravity: Edges.Bottom | Edges.Left

    color: "transparent"

    implicitWidth: 250
    implicitHeight: 1
    visible: false

    MouseArea {
        anchors.top: parent.top
        anchors.right: parent.right

        cursorShape: Qt.PointingHandCursor
        implicitWidth: panelRoot.anchorItem.width
        implicitHeight: panelRoot.anchorItem.height

        onClicked: panelRoot.close()
    }

    IpcHandler {
        target: "panelRoot"

        function toggleOpen() {
            panelRoot.opened = !panelRoot.opened;
        }
    }

    // Filler
    Rectangle {
        readonly property int coverage: 4

        anchors.right: parent.right

        y: panelRoot.anchorItem.height - 4
        implicitWidth: panelRoot.anchorItem.width
        implicitHeight: 2 * coverage

        color: Colors.md3.surface_container
    }

    Rectangle {
        id: panel

        readonly property int hPadding: 16
        readonly property int vPadding: 12

        y: panelRoot.anchorItem.height
        implicitWidth: parent.width
        implicitHeight: Services.Network.isWifiOn ? panelRoot.defaultHeight - (panelRoot.radius * 2) : panelRoot.controlBarHeight + (2 * vPadding)

        radius: panelRoot.radius
        topRightRadius: 0

        color: Colors.md3.surface_container

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InQuad
            }
        }

        ColumnLayout {
            x: panel.hPadding
            y: panel.vPadding

            width: parent.implicitWidth - (2 * panel.hPadding)
            height: parent.implicitHeight - (2 * panel.vPadding)

            spacing: 12

            Rectangle {
                id: controlBar

                readonly property int hPadding: 8
                readonly property int vPadding: 8

                color: Colors.md3.surface_container_high
                radius: height / 2

                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                Layout.preferredHeight: panelRoot.controlBarHeight

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

                            onClicked: Services.Network.fn.listNetworks()
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

                            color: Services.Network.isWifiListing ? Colors.md3.surface_bright : Colors.md3.on_primary
                            text: Icons.refresh
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

            NetworkList {}
        }
    }

    Shape {
        x: parent.width - panelRoot.anchorItem.width - width
        y: panelRoot.anchorItem.height - height
        implicitWidth: panelRoot.radius
        implicitHeight: panelRoot.radius
        ShapePath {
            fillColor: Colors.md3.surface_container
            strokeColor: "transparent"
            startX: panelRoot.radius
            startY: 0
            PathLine {
                x: panelRoot.radius
                y: panelRoot.radius
            }
            PathLine {
                x: 0
                y: panelRoot.radius
            }
            // Create the concave inward curve using an arc or quad/cubic bezier
            PathArc {
                x: panelRoot.radius
                y: 0
                radiusX: panelRoot.radius
                radiusY: panelRoot.radius
                direction: PathArc.Counterclockwise
            }
        }
    }

    NumberAnimation {
        id: openAnim
        target: panelRoot
        property: "implicitHeight"
        from: 1
        to: panelRoot.defaultHeight
        easing.type: Easing.OutQuad
        duration: 500
    }

    NumberAnimation {
        id: closeAnim
        target: panelRoot
        property: "implicitHeight"
        from: panelRoot.defaultHeight
        to: 1
        easing.type: Easing.InQuad
        duration: 500

        onRunningChanged: {
            if (!running) {
                panelRoot.visible = false;
                panelRoot.anchorItem.bottomLeftRadius = panelRoot.anchorItem.height / 2;
                panelRoot.anchorItem.bottomRightRadius = panelRoot.anchorItem.height / 2;
            }
        }
    }
}
