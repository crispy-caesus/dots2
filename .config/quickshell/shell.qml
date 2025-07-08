import Quickshell
import QtQuick
import Quickshell.Hyprland

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            right: true
            bottom: true
        }

        implicitWidth: 30

        Text {
            id: clockText

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            text: Qt.formatDateTime(Clock.clock.date, "hh\nmm")
            font.pointSize: 10
            font.bold: true
            anchors.margins: 5
        }
        Text {
            id: dateText

            text: Qt.formatDateTime(Clock.clock.date, "dd")
            font.pointSize: 10
            font.bold: true

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
        }

        Text {
            id: workspaceText

            text: Hyprland.focusedWorkspace.id

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            font.bold: true
        }
    }
}
