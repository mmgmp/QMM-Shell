import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
	id: osd

	// Se muestra al cambiar el volumen y se oculta solo tras `timeout` ms
	property int timeout: 1500
	property bool shown: false

	function show() {
		shown = true
		hideTimer.restart()
	}

	// La ventana sigue visible mientras dura el fade-out
	visible: shown || card.opacity > 0
	color: "transparent"

	implicitWidth: 260
	implicitHeight: 56

	// Solo anclado abajo => centrado horizontalmente
	anchors.bottom: true
	margins.bottom: 80

	// No reserva espacio ni captura clics
	exclusionMode: ExclusionMode.Ignore
	mask: Region {}

	Timer {
		id: hideTimer
		interval: osd.timeout
		onTriggered: osd.shown = false
	}

	Connections {
		target: Audio
		function onVolumeChanged() { osd.show() }
	}

	Rectangle {
		id: card
		anchors.fill: parent
		radius: 10
		border.width: 2
		border.color: "#505050"
		opacity: osd.shown ? 1 : 0

		Behavior on opacity {
			NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
		}

		gradient: Gradient {
			orientation: Gradient.Vertical
			GradientStop { position: 0.0; color: "#8a8a90" }
			GradientStop { position: 0.3; color: "#18181a" }
			GradientStop { position: 1.0; color: "#18181a" }
		}

		RowLayout {
			anchors.fill: parent
			anchors.leftMargin: 16
			anchors.rightMargin: 16
			spacing: 12

			Text {
				text: "Vol"
				color: "white"
			}

			// Barra de progreso
			Rectangle {
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignVCenter
				implicitHeight: 6
				radius: 3
				color: "#303034"

				Rectangle {
					height: parent.height
					radius: parent.radius
					width: parent.width * Math.min(Audio.volume, 1)
					color: "white"

					Behavior on width {
						NumberAnimation { duration: 80 }
					}
				}
			}

			Text {
				text: Math.round(Audio.volume * 100) + "%"
				color: "white"
				Layout.minimumWidth: 36
				horizontalAlignment: Text.AlignRight
			}
		}
	}
}
