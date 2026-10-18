import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => n.tracked = true
    }

    PanelWindow {
        id: popup

        anchors { top: true; right: true }
        margins { top: 20; right: 20 }

        implicitWidth: 340
        implicitHeight: Math.max(1, column.implicitHeight + 8)

        color: "transparent"

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                delegate: Rectangle {
                    id: card
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    radius: 10
                    color: "#20232b"
                    border.color: "#454957"
                    border.width: 2

					RowLayout{
						id: layout
						anchors.fill: parent
	                    anchors.margins: 10
						spacing: 5

						Image {
							source: card.iconSource
							sourceSize.width: 64
				            sourceSize.height: 64
							Layout.preferredHeight: 36
							Layout.preferredWidth: 36
							Layout.alignment: Qt.AlignVCenter
							visible: source.toString() !== ""
						}

						ColumnLayout {
							Layout.fillWidth: true
							spacing: 5

			                Text {
				                text: card.modelData.summary
					            color: "white"
						        font.bold: true
							    elide: Text.ElideRight
								Layout.fillWidth: true
							}

		                    Text {
								text: card.modelData.body
	                            color: "#c0c4d0"
		                        elide: Text.ElideRight
			                    Layout.fillWidth: true
				            }
					    }
					
					}

					MouseArea {
						anchors.fill: parent
	                    onClicked: card.modelData.dismiss()
		            }

					Timer {
						interval: 5000
					    running: true
						onTriggered: card.modelData.expire()
					}	
				}
			}
        }
    }
}
