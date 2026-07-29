pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: networkSvc

    readonly property var strengthIcons: ['󰤨', '󰤥', '󰤢', '󰤟']

    property alias fn: fn
    property alias networksModel: networksModel

    property bool isWifiOn: true
    property bool isWifiChanging: false
    property bool isWifiListing: false

    ListModel {
        id: networksModel
    }

    Process {
        id: isWifiOnProc
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                networkSvc.isWifiOn = text.trim() === 'enabled';
            }
        }
    }

    Process {
        id: toggleWifiProc
        onRunningChanged: {
            networkSvc.isWifiChanging = running;

            if (running) {
                networkSvc.isWifiOn = !networkSvc.isWifiOn;

                if (!networkSvc.isWifiOn) {
                    networksModel.clear();
                }
            }
        }
    }

    Process {
        id: listNetworksProc
        onRunningChanged: networkSvc.isWifiListing = running
        stdout: StdioCollector {
            onStreamFinished: () => {
                const lines = text.split('\n');

                let i = 0;

                for (const line of lines) {
                    const [ssid, _, rate, signal, security] = line.split(/  +/);

                    if (!ssid) {
                        continue;
                    }

                    const rateParts = rate.split(" ");
                    const rateNum = rateParts[0];

                    const network = {
                        ssid,
                        rate: `${rateNum > 1000 ? Math.round(rateNum / 100) / 10 : rateNum} ${rateNum > 1000 ? 'Gbs' : 'Mbs'}`,
                        signal,
                        security
                    };

                    if (networksModel.count <= i) {
                        networksModel.append(network);
                    } else {
                        networksModel.set(i, network);
                    }

                    ++i;
                }

                while (networksModel.count > i) {
                    networksModel.remove(i);
                }
            }
        }
    }

    IpcHandler {
        id: fn

        target: "networkSvc"

        function checkIsWifiOn() {
            if (networkSvc.isWifiChanging) {
                return;
            }

            isWifiOnProc.exec(["sh", "-c", "nmcli radio wifi"]);
        }

        function getStrengthIcon(strength: int): string {
            const step = 100 / networkSvc.strengthIcons.length;
            let currPct = 100 - step;
            for (const icon of networkSvc.strengthIcons) {
                if (strength > currPct) {
                    return icon;
                }
                currPct -= step;
            }

            return '󰤯';
        }

        function getSecurityIcon(security: string): string {
            return {
                wpa1: '󰣮',
                wpa2: '󱎚',
                wpa3: '󰗻'
            }[security.toLowerCase()] ?? '󰣯';
        }

        function listNetworks() {
            if (!networkSvc.isWifiOn || networkSvc.isWifiListing) {
                return;
            }

            listNetworksProc.exec(["sh", "-c", "nmcli -f SSID,MODE,RATE,SIGNAL,SECURITY dev wifi | awk '$1!=\"--\" && $2==\"Infra\" && !seen[$1]++{ print; }'"]);
        }

        function toggleWifi() {
            if (networkSvc.isWifiChanging) {
                return;
            }

            toggleWifiProc.exec(["sh", "-c", `nmcli radio wifi ${networkSvc.isWifiOn ? "off" : "on"}`]);
        }
    }
}
