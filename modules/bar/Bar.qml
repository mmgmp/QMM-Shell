import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../config.js" as Config

PanelWindow {
	id: bar

	implicitHeight: Config.bar.height
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
			anchors.leftMargin: 16
			anchors.rightMargin: 16

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
					spacing: 15

					Tray {}

					Volume {}

				}
			}
		}
	}
}
