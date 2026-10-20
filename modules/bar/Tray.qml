import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Row {
	id: root
	spacing: 15

	Repeater {
		model: SystemTray.items

		delegate: Item {
			id: trayItem
			required property var modelData

			width: 16
			height: 16

			// Ocultar entradas sin icono o en estado Passive (udiskie en modo auto)
			visible: modelData.icon !== "" && modelData.status !== Status.Passive

			Image {
				anchors.fill: parent
				source: trayItem.modelData.icon
				sourceSize: Qt.size(32, 32)
				smooth: true
				fillMode: Image.PreserveAspectFit
			}
		}
	}
}
