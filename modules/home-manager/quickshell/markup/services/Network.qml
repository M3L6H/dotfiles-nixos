pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

Singleton {
    id: networkSvc

    readonly property bool isConnected: isEthernet || isWifi
    readonly property int maxSamples: 10
    readonly property var strengthIcons: ['󰤨', '󰤥', '󰤢', '󰤟']
    readonly property int updateInterval: 2000

    property alias fn: fn
    property alias networksModel: networksModel

    property string panelOpen: ""
    property bool showBadges: false

    property bool isWifiOn: true
    property bool isWifiChanging: false
    property bool isWifiListing: false

    property var upSamples: []
    property var downSamples: []
    property var timestamps: []

    property double upBpS: 0
    property double downBpS: 0
    property double maxUpBpS: 0
    property double maxDownBpS: 0

    property string latency: ""

    property bool isEthernet: false
    property bool isWifi: false
    property string device: ""

    property int strength: 0
    property string network: ""
    property string privateIp: ""
    property bool isVpn: false
    property string vpnHost: ""

    onIsConnectedChanged: privateIpProc.running = true

    onPanelOpenChanged: {
        if (!panelOpen) {
            showBadges = false;
        }
    }

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

            if (networkSvc.isConnected) {
                latencyProc.running = true;
                speedsProc.running = true;
            }
        }
    }

    Process {
        id: connectProc
        onRunningChanged: {
            networkSvc.isWifiChanging = running;
        }
    }

    Process {
        id: connectionProc

        command: ["sh", "-c", "nmcli d | awk '$2==\"wifi\" || $2==\"ethernet\"{ print $1,$2,$3,$4; }'"]

        stdout: StdioCollector {
            onStreamFinished: () => {
                let isWifi = false;
                let network = "";
                let isEthernet = false;
                let device = "";

                for (const data of text.split("\n")) {
                    const [d, type, status, n] = data.split(" ");
                    const connected = status === 'connected';
                    if (type === 'wifi') {
                        isWifi = isWifi || connected;
                        network = (network === "") ? n : network;
                    } else {
                        isEthernet = isEthernet || connected;
                    }

                    if (connected && device === "") {
                        device = d;
                    }
                }

                networkSvc.isWifi = isWifi;
                networkSvc.isEthernet = isEthernet;
                networkSvc.device = device;

                networkSvc.network = network;
            }
        }
    }

    Process {
        id: latencyProc
        command: ["sh", "-c", "ping -c 1 -W 1 1.1.1.1 | awk -F'/' 'END{print ($5 ? int($5) \" ms\" : \"Timeout\")}'"]
        stdout: StdioCollector {
            onStreamFinished: networkSvc.latency = this.text.trim()
        }
    }

    Process {
        id: privateIpProc
        command: ["sh", "-c", "hostname -I | awk '{ print $1; }'"]
        running: true

        stdout: SplitParser {
            onRead: data => networkSvc.privateIp = data
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
        id: speedsProc
        command: ["sh", "-c", `cat /proc/net/dev | awk -v interface="${networkSvc.device}" '$1 ~ interface{ print $2, $10, systime(); }'`]
        stdout: StdioCollector {
            onStreamFinished: () => {
                const [down, up, timestamp] = text.split(" ");

                networkSvc.downSamples.push(parseInt(down));
                networkSvc.upSamples.push(parseInt(up));
                networkSvc.timestamps.push(parseInt(timestamp));

                if (networkSvc.downSamples.length > networkSvc.maxSamples) {
                    networkSvc.downSamples.shift();
                }

                if (networkSvc.upSamples.length > networkSvc.maxSamples) {
                    networkSvc.upSamples.shift();
                }

                if (networkSvc.timestamps.length > networkSvc.maxSamples) {
                    networkSvc.timestamps.shift();
                }

                if (networkSvc.timestamps.length < 2) {
                    return;
                }

                let downAvg = 0;
                let upAvg = 0;

                for (let i = 1; i < networkSvc.timestamps.length; ++i) {
                    const deltaS = networkSvc.timestamps[i] - networkSvc.timestamps[i - 1];
                    downAvg += (networkSvc.downSamples[i] - networkSvc.downSamples[i - 1]) / deltaS;
                    upAvg += (networkSvc.upSamples[i] - networkSvc.upSamples[i - 1]) / deltaS;
                }

                networkSvc.downBpS = downAvg / networkSvc.timestamps.length;
                networkSvc.upBpS = upAvg / networkSvc.timestamps.length;

                networkSvc.maxDownBpS = Math.max(networkSvc.maxDownBpS, networkSvc.downBpS);
                networkSvc.maxUpBpS = Math.max(networkSvc.maxUpBpS, networkSvc.upBpS);
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

        function connect(ssid: string) {
            if (networkSvc.isWifiChanging) {
                return;
            }

            connectProc.exec(["sh", "-c", `nmcli d wifi connect ${ssid}`]);
        }

        function disconnect() {
            if (networkSvc.isWifiChanging) {
                return;
            }

            connectProc.exec(["sh", "-c", "nmcli d disconnect $(nmcli -f TYPE,DEVICE d | awk '$1==\"wifi\"{ print $2; }')"]);
        }

        function formatBpS(bps: double): string {
            const suffixes = ["B/s", "KB/s", "MB/s", "GB/s"];

            let prefix = bps;
            let i = 0;

            for (; i < suffixes.length; ++i) {
                if (prefix < 1000) {
                    break;
                }
                prefix /= 1000;
            }

            return `${prefix >= 100 ? Math.round(prefix) : Math.round(prefix * 10) / 10} ${suffixes[i]}`;
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

        // Open the network panel on the specified monitor
        function setPanelOpen(isOpen: string) {
            networkSvc.panelOpen = isOpen;

            if (isOpen) {
                networkSvc.showBadges = true;
            }
        }

        function toggleWifi() {
            if (networkSvc.isWifiChanging) {
                return;
            }

            toggleWifiProc.exec(["sh", "-c", `nmcli radio wifi ${networkSvc.isWifiOn ? "off" : "on"}`]);
        }
    }
}
