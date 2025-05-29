pragma Singleton

import Quickshell
import QtQuick

Singleton {
    property alias clock: sysclock
    SystemClock {
        id: sysclock

        enabled: true
        precision: SystemClock.Seconds
    }
}
