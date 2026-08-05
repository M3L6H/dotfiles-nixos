pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "../.."
import "../../components" as Components
import "../../services" as Services

Rectangle {
    id: tagsRoot

    readonly property int hPadding: 8

    readonly property var tagNames: ["一", "二", "三", "四", "五", "六", "七", "八", "九"]

    readonly property var screen: Quickshell.screens[0]
    readonly property string monitor: tagsRoot.screen ? tagsRoot.screen.name : ""

    color: Colors.md3.surface_container
    radius: height / 2

    Layout.margins: 6
    Layout.fillHeight: true
    Layout.preferredWidth: tagsLayout.implicitWidth + (2 * hPadding)

    RowLayout {
        id: tagsLayout

        x: parent.hPadding
        spacing: 4

        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: tagsModel

            delegate: Rectangle {
                id: tagsRect

                readonly property int hPadding: 4
                readonly property int vPadding: 2

                required property int index
                required property bool isActive
                required property bool isAlive
                required property var tags

                property bool isReady: false

                clip: !Services.Listener.showBadges
                color: isActive ? Colors.md3.primary : Colors.md3.surface_bright

                radius: height / 2

                Behavior on color {
                    ColorAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on Layout.preferredWidth {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic

                        onRunningChanged: {
                            if (!running && !tagsRect.isAlive) {
                                tagsModel.remove(tagsRect.index);
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    tagsRect.isReady = true;
                }

                Layout.preferredHeight: tagLayout.implicitHeight + (2 * vPadding)
                Layout.preferredWidth: isReady && isAlive ? tagLayout.implicitWidth + (2 * hPadding) : 0

                RowLayout {
                    id: tagLayout

                    x: parent.hPadding
                    y: parent.vPadding
                    spacing: 2

                    Repeater {
                        model: tagsRect.tags

                        delegate: Text {
                            id: tagText

                            readonly property real finalWidth: 16

                            required property int index
                            required property int tagIndex
                            required property bool isAlive

                            property bool isReady

                            font {
                                family: "VictorMono Nerd Font Propo 10"
                                pointSize: 8
                            }

                            clip: !Services.Listener.showBadges
                            color: tagsRect.isActive ? Colors.md3.on_primary : Colors.md3.on_surface
                            text: tagsRoot.tagNames[tagIndex]

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            Behavior on color {
                                ColorAnimation {
                                    duration: 300
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Behavior on Layout.preferredWidth {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.OutCubic

                                    onRunningChanged: {
                                        if (!running && !tagText.isAlive) {
                                            tagsRect.tags.remove(tagText.index);
                                        }
                                    }
                                }
                            }

                            Component.onCompleted: {
                                tagText.isReady = true;
                            }

                            Layout.alignment: Qt.AlignCenter
                            Layout.preferredWidth: isReady && isAlive ? finalWidth : 0

                            Components.Badge {
                                key: `${tagText.tagIndex + 1}`
                                show: Services.Listener.showBadges
                            }
                        }
                    }
                }
            }
        }
    }

    Process {
        id: tagsWatcher
        command: ["mmsg", "watch", "all-tags"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (!line || line.trim() === "") {
                    return;
                }

                try {
                    tagsRoot.parseTagsLine(JSON.parse(line));
                } catch (e) {
                    console.error("Failed to parse tags line", e);
                }
            }
        }
    }

    ListModel {
        id: tagsModel
    }

    function parseTagsLine(data) {
        const {
            all_tags: allTags
        } = data;

        if (!allTags || !monitor) {
            return;
        }

        const tags = allTags.filter(({
                monitor: m
            }) => m === monitor)[0]?.tags ?? [];

        if (!tags) {
            return;
        }

        let activeIndex = -1;
        const groupedTags = [];

        for (let i = 0; i < tags.length; ++i) {
            if (tags[i].is_active) {
                if (activeIndex === -1) {
                    activeIndex = groupedTags.length;
                    groupedTags.push([i]);
                } else {
                    groupedTags[activeIndex].push(i);
                }
            } else if (tags[i].client_count > 0) {
                groupedTags.push([i]);
            }
        }

        let i = 0;

        for (const tagGroup of groupedTags) {
            const grp = tagGroup[0];

            const isActive = grp === groupedTags[activeIndex][0];
            i = getMatchingIdx(tagsModel, i, grp, () => mkTagGrp(grp, isActive));
            tagsModel.get(i).isActive = isActive;
            const tagModel = tagsModel.get(i).tags;

            let j = 0;
            for (const tag of tagGroup) {
                j = getMatchingIdx(tagModel, j, tag, () => mkTag(tag));
                ++j;
            }

            for (; j < tagModel.count; ++j) {
                tagModel.get(j).isAlive = false;
            }

            ++i;
        }

        for (; i < tagsModel.count; ++i) {
            tagsModel.get(i).isAlive = false;
            tagsModel.get(i).isActive = false;
        }
    }

    function getMatchingIdx(listModel, i, tagIndex, maker, updater) {
        while (true) {
            if (i >= listModel.count) {
                listModel.append(maker());
                return i;
            } else if (listModel.get(i).tagIndex === tagIndex) {
                return i;
            } else if (listModel.get(i).tagIndex > tagIndex) {
                listModel.insert(i, maker());
                return i;
            } else {
                listModel.get(i).isAlive = false;
            }

            ++i;
        }
    }

    function mkTag(tagIndex) {
        return {
            tagIndex,
            isAlive: true,
            tagIndex
        };
    }

    function mkTagGrp(tagIndex, isActive) {
        return {
            tagIndex,
            isAlive: true,
            isActive,
            tags: []
        };
    }
}
