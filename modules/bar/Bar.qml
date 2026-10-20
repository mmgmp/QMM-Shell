import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
	id: bar

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
		radius: 10
		border.width: 2
        border.color: "#505050"
		anchors.fill: parent

		gradient: Gradient {
		    orientation: Gradient.Vertical
			GradientStop { position: 0.0; color: "#8a8a90" }
			GradientStop { position: 0.3; color: "#18181a" }
			GradientStop { position: 1.0; color: "#18181a" }
		}

		RowLayout {

			anchors.fill: parent
			anchors.margins: 8

			Item {
				Layout.fillWidth: true

				NiriWorkspaces {
				    anchors.left: parent.left
			        anchors.verticalCenter: parent.verticalCenter
			        output: bar.screen ? bar.screen.name : ""
			    }
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
