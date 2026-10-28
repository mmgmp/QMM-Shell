import Quickshell
import Quickshell.Io
import QtQuick
import "modules/"
import "modules/bar"


ShellRoot {
	FileView {
		path: Quickshell.shellPath("config.js")
		watchChanges: true
		onFileChanged: Quickshell.reload(true)
	}

	Variants {
		model: Quickshell.screens

		Bar {
			required property var modelData
			screen: modelData
		}
	}

	NotificationService {}
	VolumeOSD {}
	Polkit {}
}
