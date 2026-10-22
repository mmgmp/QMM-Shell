import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Polkit
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../config.js" as Config

Scope {
    id: root

    PolkitAgent {
        id: agent
    }

    PanelWindow {
        visible: agent.isActive

        implicitWidth: 420
        implicitHeight: col.implicitHeight + 40
        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        exclusionMode: ExclusionMode.Ignore

        Rectangle {
            anchors.fill: parent
            radius: Config.global.borderRadius
            color: Config.colors.background
            border.color: Config.colors.border
		    border.width: Config.global.borderWidth

            ColumnLayout {
                id: col
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                Label {
                    text: agent.flow?.message ?? ""
                    color: "white"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Label {
                    visible: text !== ""
                    text: agent.flow?.supplementaryMessage ?? ""
                    color: agent.flow?.supplementaryIsError ? "#f38ba8" : "#a6adc8"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                TextField {
                    id: pass
                    Layout.fillWidth: true
                    placeholderText: agent.flow?.inputPrompt ?? "Contraseña"
                    echoMode: agent.flow?.responseVisible ? TextInput.Normal : TextInput.Password
                    focus: true
                    onAccepted: {
                        agent.flow.submit(text)
                        text = ""
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    Button {
                        text: "Cancelar"
                        onClicked: agent.flow.cancelAuthenticationRequest()
                    }
                    Button {
                        text: "Autenticar"
                        onClicked: {
                            agent.flow.submit(pass.text)
                            pass.text = ""
                        }
                    }
                }
            }
        }
    }
}
