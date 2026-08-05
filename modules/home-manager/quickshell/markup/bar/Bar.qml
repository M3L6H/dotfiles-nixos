import QtQuick
import QtQuick.Layouts

import "components" as Components

Item {
    id: bar

    property alias externalNetworkId: networkPill.externalId

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    implicitHeight: 36

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }

        Components.Tags {}
        Components.System {}
    }

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        Components.Battery {}
        Components.Network {
            id: networkPill
        }
        Components.DateTime {}
    }
}
