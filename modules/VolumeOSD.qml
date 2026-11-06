import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Wayland

import "../config.js" as Config

Scope {
	id: root

	readonly property var audio: Pipewire.defaultAudioSink?.audio
	readonly property color fg: audio?.muted ? Config.colors.disabled : Config.colors.text

	property bool shouldShowOsd: false

	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}

	// Periodo de gracia: ignora los cambios iniciales y los de cambio de sink
	Timer {
		id: graceTimer
		interval: 1500
		running: true
	}

	Timer {
		id: hideTimer
		interval: 1000
		onTriggered: root.shouldShowOsd = false
	}

	function show() {
		if (graceTimer.running) return;
		shouldShowOsd = true;
		hideTimer.restart();
	}

	Connections {
		target: Pipewire
		function onDefaultAudioSinkChanged() { graceTimer.restart() }
	}

	Connections {
		target: root.audio
		function onVolumeChanged() { root.show() }
		function onMutedChanged() { root.show() }
	}

	LazyLoader {
		active: root.shouldShowOsd

		PanelWindow {
			anchors.bottom: true
			margins.bottom: screen.height / 8
			exclusiveZone: 0
			WlrLayershell.layer: WlrLayer.Overlay

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

							implicitWidth: parent.width * (root.audio?.volume ?? 0)
							radius: parent.radius
							color: root.fg
						}
					}
				}
			}
		}
	}
}
