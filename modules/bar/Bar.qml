import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {

	implicitHeight: 33
	color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

	margins {
		top: 5
		left: 5
		right: 5
	}

	Rectangle{
	    color: "#18181a"
		radius: 10
		border.width: 2
        border.color: "#505050"
		anchors.fill: parent

		RowLayout {

			anchors.fill: parent
			anchors.margins: 8
			Item {
				Layout.fillWidth: true
			}


			Item {
				Layout.fillWidth: true

				Clock {
					anchors.centerIn: parent
				}
			}


			Item {
				Layout.fillWidth: true

				Row  {
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					spacing: 8

					Text {
						text: '${Math.round(Audio.volume * 100)}%'
						color: "white"
					}

					Text {
						text: "Vol"
						color: "white"
					}
				}
			}
		}
	}
}
