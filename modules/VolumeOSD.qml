import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import "../config.js" as Config

Scope {
	id: root

	readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false
	readonly property color fg: muted ? Config.colors.disabled : Config.colors.text

	property bool shouldShowOsd: false

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio

		function onVolumeChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}

		function onMutedChanged() {
			root.shouldShowOsd = true;
			hideTimer.restart();
		}
	}

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			anchors.bottom: true
			margins.bottom: screen.height / 8
			exclusiveZone: 0

			implicitWidth: 400
			implicitHeight: 50
			color: "transparent"

			mask: Region {}

			Rectangle {
				anchors.fill: parent
				radius: Config.global.borderRadius
				color: Config.colors.background
				border.color: Config.colors.border
				border.width: Config.global.borderWidth

				RowLayout {
					anchors {
						fill: parent
						leftMargin: 10
						rightMargin: 15
					}

					Text {
						text: " "
						color: root.fg
						font.pixelSize: 30
						Layout.preferredWidth: 36
						horizontalAlignment: Text.AlignHCenter
					}

					Rectangle {
						Layout.fillWidth: true
						implicitHeight: 10
						radius: 20
						color: "#50ffffff"

						Rectangle {
							anchors {
								left: parent.left
								top: parent.top
								bottom: parent.bottom
							}

							implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
							radius: parent.radius
							color: root.fg
						}
					}
				}
			}
		}
	}
}
