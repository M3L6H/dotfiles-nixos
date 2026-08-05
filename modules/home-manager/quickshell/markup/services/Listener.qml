pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: listenerSvc

    property bool showBadges: false

    Timer {
        interval: 10000
        running: listenerSvc.showBadges
        onRunningChanged: {
            if (!running) {
                listenerSvc.showBadges = false;
            }
        }
    }

    IpcHandler {
        id: fn

        target: "listenerSvc"

        function setShowBadges(shouldShowBadges: bool) {
            listenerSvc.showBadges = shouldShowBadges;
            console.log("showBadges");
        }
    }
}
