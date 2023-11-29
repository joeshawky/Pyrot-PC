/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Layouts  1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

RowLayout {
    id:         _root
    spacing:    0

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property var    _vehicleInAir:      _activeVehicle ? _activeVehicle.flying || _activeVehicle.landing : false
    property bool   _vtolInFWDFlight:   _activeVehicle ? _activeVehicle.vtolInFwdFlight : false
    property bool   _armed:             _activeVehicle ? _activeVehicle.armed : false
    property real   _margins:           ScreenTools.defaultFontPixelWidth
    property real   _spacing:           ScreenTools.defaultFontPixelWidth / 2

    QGCLabel {
        id:             mainStatusLabel
        text:           mainStatusText()
        font.pointSize: _vehicleInAir ? ScreenTools.defaultFontPointSize : ScreenTools.largeFontPointSize

        property string _commLostText:      qsTr("Communication Lost")
        property string _readyToFlyText:    qsTr("Ready To Dive")
        property string _notReadyToFlyText: qsTr("Not Ready")
        property string _disconnectedText:  qsTr("Disconnected")
        property string _armedText:         qsTr("Armed")
        property string _flyingText:        qsTr("Diving")
        property string _landingText:       qsTr("Landing")

        function mainStatusText() {
            var statusText
            if (_activeVehicle) {
                if (_communicationLost) {
                    return mainStatusLabel._commLostText
                }
                if (_activeVehicle.armed) {
                    if (_activeVehicle.flying) {
                        return mainStatusLabel._flyingText
                    } else if (_activeVehicle.landing) {
                        return mainStatusLabel._landingText
                    } else {
                        return mainStatusLabel._armedText
                    }
                } else {
                    if (_activeVehicle.readyToFlyAvailable) {
                        if (_activeVehicle.readyToFly) {
                            return mainStatusLabel._readyToFlyText
                        } else {
                            return mainStatusLabel._notReadyToFlyText
                        }
                    } else {
                        // Best we can do is determine readiness based on AutoPilot component setup and health indicators from SYS_STATUS
                        if (_activeVehicle.allSensorsHealthy && _activeVehicle.autopilot.setupComplete) {
                            return mainStatusLabel._readyToFlyText
                        } else {
                            return mainStatusLabel._notReadyToFlyText
                        }
                    }
                }
            } else {
                return mainStatusLabel._disconnectedText
            }
        }

        MouseArea {
            anchors.left:           parent.left
            anchors.right:          parent.right
            anchors.verticalCenter: parent.verticalCenter
            height:                 _root.height
            enabled:                _activeVehicle
            onClicked:              mainWindow.showIndicatorPopup(mainStatusLabel, sensorStatusInfoComponent)
        }
    }

    Item {
        Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * ScreenTools.largeFontPointRatio * 1.5
        height:                 1
    }

}

