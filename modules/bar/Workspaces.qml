import Quickshell
import QtQuick

Process {
    id: workspaceProcess
    command: ["niri", "msg", "-j", "workspaces"]

    Component.onCompleted: {
        running = true
    }
}
