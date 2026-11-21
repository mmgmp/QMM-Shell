import Quickshell
import QtQuick

import "../../config.js" as Config

Text {
	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

	color: Config.colors.text

	font {
		pixelSize: Config.bar.fontSize
		bold: true
		family: Config.global.fontFamily
	}

	text: Qt.formatDateTime(clock.date, "d MMM HH:mm")
}
