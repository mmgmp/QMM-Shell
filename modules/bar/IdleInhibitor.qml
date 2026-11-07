import Quickshell
import Quickshell.Wayland
import QtQuick

import "../../config.js" as Config

Text {
    id: root

	// true = inhibido (no entra en idle ni se bloquea/suspende por inactividad)
    property bool inhibited: false

    IdleInhibitor {
        enabled: root.inhibited
        // La ventana de la barra en la que está este módulo
        window: QsWindow.window
    }

	font { pixelSize: Config.bar.fontSize }

    text: " "
    color: root.inhibited ? Config.colors.text : Config.colors.disabled

    MouseArea {
        anchors.fill: parent
		anchors.margins: -4
        cursorShape: Qt.PointingHandCursor
        onClicked: root.inhibited = !root.inhibited
    }
}
