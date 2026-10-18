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
        margins { top: 5; right: 15 }

        implicitWidth: 340
        implicitHeight: Math.max(1, column.implicitHeight + 8)

        color: "transparent"

        ColumnLayout {
            id: column

			anchors {
				top: parent.top
		        left: parent.left
		        right: parent.right
		        topMargin: 12
			}

            width: parent.width
            spacing: 20

            Repeater {
                model: server.trackedNotifications
				
				delegate: Rectangle {
					id: card

				    required property var modelData
				    readonly property int pad: 10

				    Layout.fillWidth: true
				    Layout.preferredHeight: Math.max(icon.visible ? icon.height : 0, textCol.implicitHeight) + pad * 2

				    radius: 10
				    color: "#20232b"
				    border.color: "#454957"
				    border.width: 2

				    Image {
				        id: icon
				        visible: source != ""
				        source: card.modelData.image || (card.modelData.appIcon ? Quickshell.iconPath(card.modelData.appIcon, true) : "")
						width: 36
				        height: 36
				        sourceSize.width: 64
				        sourceSize.height: 64
						fillMode: Image.PreserveAspectFit

				        anchors {
				            left: parent.left
				            top: parent.top
				            margins: card.pad
						}
					}

					Column {
						id: textCol
						spacing: 5
			
						anchors {
				            left: icon.visible ? icon.right : parent.left
							leftMargin: icon.visible ? 10 : card.pad
						    right: parent.right
							rightMargin: card.pad
							top: parent.top
							topMargin: card.pad
						}

						Text {
							width: parent.width
							text: card.modelData.summary
				            color: "white"
							font.bold: true
						    wrapMode: Text.Wrap
						}

					    Text {
							width: parent.width
							text: card.modelData.body
							color: "#c0c4d0"
				            wrapMode: Text.Wrap
							maximumLineCount: 10
				            elide: Text.ElideRight
						}
					}

				    // Etiqueta con borde propio sobre el borde superior
				    Rectangle {
				        anchors.right: parent.right
				        anchors.rightMargin: 16
				        y: -height / 2 + card.border.width / 2

				        width: label.implicitWidth + 16
				        height: label.implicitHeight + 8
				        radius: 10
				        color: card.color
				        border.color: "#454957"
				        border.width: 2

				        Text {
				            id: label
				            anchors.centerIn: parent
				            text: card.modelData.appName
				            color: "#c0c4d0"
				            font.pixelSize: 11
				            font.bold: true
				        }
					}

					TapHandler {
						onTapped: card.modelData.dismiss()
					}

					Timer {
						interval: 3000
				        running: true
				        onTriggered: card.modelData.expire()
				    }
				}
			}
        }
    }
}
