/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
//-- Armed Indicator
QGCComboBox {
    anchors.verticalCenter: parent.verticalCenter
    alternateText:          _armed ? qsTr("Armed") : qsTr("Disarmed")
    model:                  [ qsTr("Arm"), qsTr("Disarm") ]
    font.pointSize:         ScreenTools.mediumFontPointSize * 0.65
    currentIndex:           -1
    sizeToContents:         true

    background: Rectangle{
        implicitWidth:  ScreenTools.implicitComboBoxWidth
        implicitHeight: ScreenTools.implicitComboBoxHeight
//        color: _qgcPal.brandingBlue
//        color: "#000099"
//        color: "#0066CC"
//        color: qgcPal.colorBlue
//        color: "#000099"
        color: "#1A4F84"
        border.color:   _qgcPal.text
    }

    property bool showIndicator: true

    property var    _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool   _armed:         _activeVehicle ? _activeVehicle.armed : false

    onActivated: {
        if (index == 0) {
            mainWindow.armVehicleRequest()
        } else {
            mainWindow.disarmVehicleRequest()
        }
        currentIndex = -1
    }
}
