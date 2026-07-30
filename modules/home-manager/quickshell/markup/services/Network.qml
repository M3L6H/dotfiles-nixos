pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: networkSvc

    readonly property bool isConnected: isEthernet || isWifi
    readonly property var strengthIcons: ['󰤨', '󰤥', '󰤢', '󰤟']
    readonly property int updateInterval: 2000

    property alias fn: fn
    property alias networksModel: networksModel

    property bool isWifiOn: true
    property bool isWifiChanging: false
    property bool isWifiListing: false

    property bool isEthernet: false
    property bool isWifi: false
    property int strength: 0
    property string network: ""
    property bool isVpn: false
    property string vpnHost: ""

    ListModel {
        id: networksModel
    }

    Timer {
        interval: networkSvc.updateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            connectionProc.running = true;
            strengthProc.running = true;
            vpnProc.running = true;
        }
    }

    Process {
        id: connectionProc

        command: ["sh", "-c", "nmcli d | awk '$2==\"wifi\" || $2==\"ethernet\"{ print $2,$3,$4; }'"]

        stdout: SplitParser {
            onRead: data => {
                const [type, status, network] = data.split(" ");
                const connected = status === 'connected';
                if (type === 'wifi') {
                    networkSvc.isWifi = connected;
                    networkSvc.network = network;
                } else {
                    networkSvc.isEthernet = connected;
                }
            }
        }
    }

    Process {
        id: strengthProc

        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL d wifi | grep '^*' | awk '{ print $2; }'"]

        stdout: SplitParser {
            onRead: data => networkSvc.strength = parseInt(data)
        }
    }

    Process {
        id: vpnProc

        command: ["sh", "-c", "nordvpn status"]

        stdout: StdioCollector {
            onStreamFinished: () => {
                const lines = text.split('\n');
                const details = {};

                for (const line of lines) {
                    const [key, value] = line.split(': ');
                    details[key.toLowerCase()] = value;
                }

                networkSvc.isVpn = details.status.toLowerCase() === 'connected';
                networkSvc.vpnHost = networkSvc.isVpn ? details.hostname.split('.')[0] : '';
            }
        }
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
