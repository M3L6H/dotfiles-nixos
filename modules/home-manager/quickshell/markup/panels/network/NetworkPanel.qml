import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io

import "../.."
import "../../services" as Services

PopupWindow {
    id: panelRoot

    readonly property int coverage: 4
    readonly property int defaultHeight: 400
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

    implicitWidth: 300
    implicitHeight: defaultHeight
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
        anchors.right: parent.right

        y: panelRoot.anchorItem.height - panelRoot.coverage
        implicitWidth: panelRoot.anchorItem.width
        implicitHeight: 2 * panelRoot.coverage

        color: Colors.md3.surface_container
    }

    Rectangle {
        color: "transparent"
        clip: true

        y: panelRoot.anchorItem.height + panelRoot.coverage
        implicitWidth: parent.width
        implicitHeight: panelRoot.defaultHeight - panelRoot.coverage

        Rectangle {
            id: panel

            readonly property int hPadding: 16
            readonly property int vPadding: 12

            y: -implicitHeight
            implicitWidth: parent.width
            implicitHeight: panelRoot.defaultHeight - (panelRoot.radius * 2) - panelRoot.coverage

            radius: panelRoot.radius
            topRightRadius: 0

            color: Colors.md3.surface_container

            Behavior on y {
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

                NetworkControl {}
                NetworkList {}
                Rectangle {
                    color: Colors.md3.on_surface

                    radius: Layout.preferredHeight / 2

                    Layout.leftMargin: panel.hPadding
                    Layout.preferredWidth: parent.width - (2 * panel.hPadding)
                    Layout.preferredHeight: 4
                }
                NetworkSummary {}
            }
        }
    }

    Shape {
        x: parent.width - panelRoot.anchorItem.width - width
        y: panelRoot.anchorItem.height - height + panelRoot.coverage
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
        target: panel
        property: "y"
        from: -panel.implicitHeight
        to: 0
        easing.type: Easing.OutQuad
        duration: 500
    }

    NumberAnimation {
        id: closeAnim
        target: panel
        property: "y"
        from: 0
        to: -panel.implicitHeight
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
