import Quickshell // for PanelWindow
import QtQuick // for Text

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

        implicitHeight: 30

        Bar.Bar {}
    }
}
