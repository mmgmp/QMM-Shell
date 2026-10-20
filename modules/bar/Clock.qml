import Quickshell
import QtQuick

import "../../config.js" as Config

Text {
	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

    color: Config.colors.text
    font { pixelSize: Config.bar.fontSize; bold: true }

	text: Qt.formatDateTime(clock.date, "d MMM HH:mm")
}
