import QtQuick
import QtQuick.Layouts

import Quickshell

import "bar" as Bar

ShellRoot {
    // qmllint disable uncreatable-type
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }

        color: "transparent"

        implicitHeight: 36

        Bar.Bar {}
    }
}
