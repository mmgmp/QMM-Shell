import Quickshell
import QtQuick

Text {
	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}

    color: "white"
    font { pixelSize: 14; bold: true }

	text: Qt.formatDateTime(clock.date, "d MMM HH:mm")
}
