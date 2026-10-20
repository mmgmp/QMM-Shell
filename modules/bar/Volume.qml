import Quickshell
import QtQuick
import Quickshell.Services.Pipewire

import "../../config.js" as Config

Text {
	id: root

	readonly property var sink: Pipewire.defaultAudioSink
	readonly property real volume: sink?.audio?.volume ?? 0
	readonly property bool muted: sink?.audio?.muted ?? false

	// Necesario para que PipeWire exponga volume/muted del sink
	PwObjectTracker { objects: [root.sink] }

	text: "  " + Math.round(volume * 100) + "%"
	color: muted ? "#8a8a90" : "white"

    font { pixelSize: Config.bar.fontSize; bold: true }

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		cursorShape: Qt.PointingHandCursor

        // Izquierdo: abrir pavucontrol · Derecho: silenciar / activar
        onClicked: mouse => {
			if (mouse.button === Qt.LeftButton) {
				Quickshell.execDetached(["sh", "-c", "pavucontrol"])
            } else if (root.sink?.audio) {
				root.sink.audio.muted = !root.muted
            }
		}

		// Rueda: ±5 %
		onWheel: wheel => {
			if (!root.sink?.audio) return
			const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05
			root.sink.audio.volume = Math.max(0, Math.min(1, root.volume + step))
		}
	}
}
