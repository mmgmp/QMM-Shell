import Quickshell
import Quickshell.Io
import QtQuick

import "../../config.js" as Config

// Módulo de workspaces para niri. Todo en un solo archivo:
// IPC (event-stream) + lógica + vista.
Row {
    id: root

    // Nombre del monitor (ej. "DP-1"). Vacío = muestra todos.
    property string output: ""

    // { id, idx, name, output, is_active, is_focused, active_window_id }
    property var workspaces: []

    // Workspaces de este monitor
    readonly property var visibleWorkspaces:
        workspaces.filter(w => output === "" || w.output === output)

    // Píxeles que se sube el fondo (pill) respecto al texto. Ajusta a tu gusto.
    property int pillOffset: 1

    spacing: 6

    function toRoman(n) {
        const map = [[1000, "M"], [900, "CM"], [500, "D"], [400, "CD"], [100, "C"],
                     [90, "XC"], [50, "L"], [40, "XL"], [10, "X"], [9, "IX"],
                     [5, "V"], [4, "IV"], [1, "I"]];
        let s = "";
        for (const [v, r] of map)
            while (n >= v) { s += r; n -= v; }
        return s;
    }

    function focusWorkspace(idx) {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(idx)]);
    }

    function handleEvent(line) {
        // Ignorar eventos ajenos (ventanas, teclado...) sin parsear el JSON
        if (!line.startsWith('{"Workspace')) return;

        let ev;
        try { ev = JSON.parse(line); } catch (e) { return; }

        if (ev.WorkspacesChanged) {
            workspaces = ev.WorkspacesChanged.workspaces.slice().sort((a, b) =>
                a.output === b.output ? a.idx - b.idx : a.output.localeCompare(b.output));

        } else if (ev.WorkspaceActivated) {
            const { id, focused } = ev.WorkspaceActivated;
            const target = workspaces.find(w => w.id === id);
            if (!target) return;
            workspaces = workspaces.map(w => {
                const n = Object.assign({}, w);
                if (w.output === target.output) n.is_active = (w.id === id);
                if (focused) n.is_focused = (w.id === id);
                return n;
            });

        } else if (ev.WorkspaceActiveWindowChanged) {
            const { workspace_id, active_window_id } = ev.WorkspaceActiveWindowChanged;
            workspaces = workspaces.map(w => {
                if (w.id !== workspace_id) return w;
                const n = Object.assign({}, w);
                n.active_window_id = active_window_id;
                return n;
            });
        }
    }

    Process {
        id: stream
        running: true
        command: ["niri", "msg", "--json", "event-stream"]
        stdout: SplitParser {
            onRead: line => root.handleEvent(line)
        }
        onExited: restart.start()
    }

    Timer {
        id: restart
        interval: 1000
        onTriggered: stream.running = true
    }

    // El modelo es solo la cantidad: los delegados se mantienen vivos
    // y solo se actualizan sus bindings (permite animaciones).
    Repeater {
        model: root.visibleWorkspaces.length

        delegate: Item {
            id: pill
            required property int index

            readonly property var ws: root.visibleWorkspaces[index] || ({})
            readonly property bool active: ws.is_active === true
            readonly property bool occupied: ws.active_window_id !== null
                                            && ws.active_window_id !== undefined

            anchors.verticalCenter: parent.verticalCenter
            height: 17
            width: label.implicitWidth + 14
            opacity: hover.hovered && !active ? 0.75 : 1.0

            Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

            // Fondo: se desplaza hacia arriba pillOffset píxeles
            Rectangle {
                y: -root.pillOffset
                width: parent.width
                height: parent.height
                radius: height / 2
                color: pill.active ? "#ffffff" : "transparent"

                Behavior on color { ColorAnimation { duration: 150 } }
            }

            Text {
                id: label
                anchors.centerIn: parent
                text: pill.ws.idx ? root.toRoman(pill.ws.idx) : ""
                font.pixelSize: Config.bar.fontSize
                font.bold: true
                color: pill.active ? "#18181a"
                     : pill.occupied ? "#d0d0d5"
                     : "#6a6a70"

                Behavior on color { ColorAnimation { duration: 150 } }
            }

            HoverHandler { id: hover }
            TapHandler { onTapped: root.focusWorkspace(pill.ws.idx) }
        }
    }
}
