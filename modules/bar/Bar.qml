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

	Rectangle{
		anchors.fill: parent
		color: Config.colors.background

		Rectangle {
			anchors.bottom: parent.bottom
		    anchors.left: parent.left
		    anchors.right: parent.right
		    height: Config.global.borderWidth
		    color: Config.colors.border
		}

		RowLayout {

			anchors.fill: parent
			anchors.leftMargin: 10
			anchors.rightMargin: 12

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

					IdleInhibitor {}

				}
			}
		}
	}
}
