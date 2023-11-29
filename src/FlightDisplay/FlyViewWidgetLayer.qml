/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Airmap        1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

// This is the ui overlay layer for the widgets/tools for Fly View
Item {
    id: _root

    property var    parentToolInsets
    property var    totalToolInsets:        _totalToolInsets
    property var    mapControl

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _planMasterController:  globals.planMasterControllerFlyView
    property var    _missionController:     _planMasterController.missionController
    property var    _geoFenceController:    _planMasterController.geoFenceController
    property var    _rallyPointController:  _planMasterController.rallyPointController
    property var    _guidedController:      globals.guidedControllerFlyView
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30

    QGCToolInsets {
        id:                     _totalToolInsets
        leftEdgeTopInset:       toolStrip.leftInset
        leftEdgeCenterInset:    toolStrip.leftInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  mapScale.centerInset
        bottomEdgeRightInset:   0
    }

    FlyViewMissionCompleteDialog {
        missionController:      _missionController
        geoFenceController:     _geoFenceController
        rallyPointController:   _rallyPointController
    }

    Row {
        id:                 multiVehiclePanelSelector
        anchors.margins:    _toolsMargin
        anchors.top:        parent.top
        anchors.right:      parent.right
        width:              _rightPanelWidth
        spacing:            ScreenTools.defaultFontPixelWidth
        visible:            QGroundControl.multiVehicleManager.vehicles.count > 1 && QGroundControl.corePlugin.options.flyView.showMultiVehicleList

        property bool showSingleVehiclePanel:  !visible || singleVehicleRadio.checked

        QGCMapPalette { id: mapPal; lightColors: true }

        QGCRadioButton {
            id:             singleVehicleRadio
            text:           qsTr("Single")
            checked:        true
            textColor:      mapPal.text
        }

        QGCRadioButton {
            text:           qsTr("Multi-Vehicle")
            textColor:      mapPal.text
        }
    }

    MultiVehicleList {
        anchors.margins:    _toolsMargin
        anchors.top:        multiVehiclePanelSelector.bottom
        anchors.right:      parent.right
        width:              _rightPanelWidth
        height:             parent.height - y - _toolsMargin
        visible:            !multiVehiclePanelSelector.showSingleVehiclePanel
    }

    /*
    The following component is the
    fly view instrument panel at the
    top right of the main screen.
    it shows roll, pitch on the left
    side and heading on the right side.
    */
//     FlyViewInstrumentPanel {
//         id:                         instrumentPanel
//         anchors.margins:            _toolsMargin
//         anchors.top:                multiVehiclePanelSelector.visible ? multiVehiclePanelSelector.bottom : parent.top
//         anchors.right:              parent.right
//         width:                      _rightPanelWidth
//         spacing:                    _toolsMargin
//         visible:                    QGroundControl.corePlugin.options.flyView.showInstrumentPanel && multiVehiclePanelSelector.showSingleVehiclePanel
//         availableHeight:            parent.height - y - _toolsMargin

//         property real rightInset: visible ? parent.width - x : 0
//     }

    /*
    The following component is the video control block
    from which you can start recording, and capture 
    pictures.
    */

    // PhotoVideoControl {
    //     id:                     photoVideoControl
    //     anchors.margins:        _toolsMargin
    //     anchors.right:          parent.right
    //     width:                  _rightPanelWidth * 0.55
    //     anchors.bottom: parent.bottom
    //     states: [
    //         State {
    //             name: "verticalCenter"
    //             AnchorChanges {
    //                 target:                 photoVideoControl
    //                 anchors.top:            undefined
    //                 anchors.verticalCenter: _root.verticalCenter
    //             }
    //         },
    //         State {
    //             name: "topAnchor"
    //             AnchorChanges {
    //                 target:                 photoVideoControl
    //                 anchors.verticalCenter: undefined
    //                 anchors.top:            instrumentPanel.bottom
    //             }
    //         }
    //     ]

    //     property bool _verticalCenter: !QGroundControl.settingsManager.flyViewSettings.alternateInstrumentPanel.rawValue
    // }

    /*
    The following component shows parameters values in a
    small block on the main screen.
    */

    // TelemetryValuesBar {
    //     id:                 telemetryPanel
    //     x:                  recalcXPosition()
    //     anchors.margins:    _toolsMargin
        
    //     // States for custom layout support
    //     states: [
    //         State {
    //             name: "bottom"
    //             when: telemetryPanel.bottomMode

    //             AnchorChanges {
    //                 target: telemetryPanel
    //                 anchors.top: undefined
    //                 anchors.bottom: parent.bottom
    //                 anchors.right: undefined
    //                 anchors.verticalCenter: undefined
    //             }

    //             PropertyChanges {
    //                 target: telemetryPanel
    //                 x: recalcXPosition()
    //             }
    //         },

    //         State {
    //             name: "right-video"
    //             when: !telemetryPanel.bottomMode && photoVideoControl.visible

    //             AnchorChanges {
    //                 target: telemetryPanel
    //                 anchors.top: photoVideoControl.bottom
    //                 anchors.bottom: undefined
    //                 anchors.right: parent.right
    //                 anchors.verticalCenter: undefined
    //             }
    //         },

    //         State {
    //             name: "right-novideo"
    //             when: !telemetryPanel.bottomMode && !photoVideoControl.visible

    //             AnchorChanges {
    //                 target: telemetryPanel
    //                 anchors.top: undefined
    //                 anchors.bottom: undefined
    //                 anchors.right: parent.right
    //                 anchors.verticalCenter: parent.verticalCenter
    //             }
    //         }
    //     ]

    //     function recalcXPosition() {
    //         // First try centered
    //         var halfRootWidth   = _root.width / 2
    //         var halfPanelWidth  = telemetryPanel.width / 2
    //         var leftX           = (halfRootWidth - halfPanelWidth) - _toolsMargin
    //         var rightX          = (halfRootWidth + halfPanelWidth) + _toolsMargin
    //         if (leftX >= parentToolInsets.leftEdgeBottomInset || rightX <= parentToolInsets.rightEdgeBottomInset ) {
    //             // It will fit in the horizontalCenter
    //             return halfRootWidth - halfPanelWidth
    //         } else {
    //             // Anchor to left edge
    //             return parentToolInsets.leftEdgeBottomInset + _toolsMargin
    //         }
    //     }
    // }

    //-- Virtual Joystick
    Loader {
        id:                         virtualJoystickMultiTouch
        z:                          QGroundControl.zOrderTopMost + 1
        width:                      parent.width  - (_pipOverlay.width / 2)
        height:                     Math.min(parent.height * 0.25, ScreenTools.defaultFontPixelWidth * 16)
        visible:                    _virtualJoystickEnabled && !QGroundControl.videoManager.fullScreen && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)
        anchors.bottom:             parent.bottom
        anchors.bottomMargin:       parentToolInsets.leftEdgeBottomInset + ScreenTools.defaultFontPixelHeight * 2
        anchors.horizontalCenter:   parent.horizontalCenter
        source:                     "qrc:/qml/VirtualJoystick.qml"
        active:                     _virtualJoystickEnabled && !(_activeVehicle ? _activeVehicle.usingHighLatencyLink : false)

        property bool autoCenterThrottle: QGroundControl.settingsManager.appSettings.virtualJoystickAutoCenterThrottle.rawValue

        property bool _virtualJoystickEnabled: QGroundControl.settingsManager.appSettings.virtualJoystick.rawValue
    }

    /*
    The next component is the 3 buttons on the top left 
    of the main screen. if you want it to be shown then
    uncomment the following component.
    */
    // FlyViewToolStrip {
    //     id:                     toolStrip
    //     anchors.leftMargin:     _toolsMargin + parentToolInsets.leftEdgeCenterInset
    //     anchors.topMargin:      _toolsMargin + parentToolInsets.topEdgeLeftInset
    //     anchors.left:           parent.left
    //     anchors.top:            parent.top
    //     z:                      QGroundControl.zOrderWidgets
    //     maxHeight:              parent.height - y - parentToolInsets.bottomEdgeLeftInset - _toolsMargin
    //     visible:                !QGroundControl.videoManager.fullScreen

    //     onDisplayPreFlightChecklist: mainWindow.showPopupDialogFromComponent(preFlightChecklistPopup)

    //     property real leftInset: x + width
    // }

    FlyViewAirspaceIndicator {
        anchors.top:                parent.top
        anchors.topMargin:          ScreenTools.defaultFontPixelHeight * 0.25
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderWidgets
        show:                       mapControl.pipState.state !== mapControl.pipState.pipState
    }

    VehicleWarnings {
        anchors.centerIn:   parent
        z:                  QGroundControl.zOrderTopMost
    }

    MapScale {
        id:                 mapScale
        anchors.margins:    _toolsMargin
        anchors.left:       toolStrip.right
        anchors.top:        parent.top
        mapControl:         _mapControl
        buttonsOnLeft:      false
        visible:            !ScreenTools.isTinyScreen && QGroundControl.corePlugin.options.flyView.showMapScale && mapControl.pipState.state === mapControl.pipState.fullState

        property real centerInset: visible ? parent.height - y : 0
    }

    Component {
        id: preFlightChecklistPopup
        FlyViewPreFlightChecklistPopup {
        }
    }


    /*
    This timer runs every 2.5 seconds and 
    sets loadCustomAddedLentaComponents variable
    to true when all the parameters are loaded.
    this is needed because if we try to load all custom
    components without all the parameters loaded then
    we get errors and none of our components would appear.
    So we must add our custom components after all the
    parameters are loaded
    */
    Timer{
        interval: 2500
        running: true
        repeat: true
        property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
        property bool   _paramsLoaded: _activeVehicle ? _activeVehicle.initialConnectComplete : false
        property bool _toggle_btns_initialized : false

        onTriggered: {
            if (_communicationLost && _toggle_btns_initialized){
                _activeVehicle.loadCustomAddedLentaComponents = false;
                _toggle_btns_initialized = false;

            } else if (_paramsLoaded && !_toggle_btns_initialized && !_communicationLost){
                _activeVehicle.loadCustomAddedLentaComponents = true;
                _toggle_btns_initialized = true;
                _activeVehicle.sayWelcome();
            }
        }
    }

     Loader{
        id: videoLoader
        sourceComponent: lentaVideoRecordingState
        anchors.right: _root.right
        anchors.top: _root.top
    }

    Component{
        id: lentaVideoRecordingState

        Item{
            id: lentaVideoRecordingItem
            height: 150
            width: 250
            visible: (QGroundControl.videoManager.recording)

            Rectangle{
                id: recordingTimer
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                width: 40
                height: 40
                radius: 40

                color: "red"

                opacity: 0

            }

            Text{
                anchors.left: recordingTimer.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 15
                color: "white"
                font.pixelSize: 25
                text: "Recording"
                font.family:    ScreenTools.normalFontFamily
            }

            Timer{
                interval: 500
                running: true
                repeat: true

                onTriggered: {

                    if(recordingTimer.opacity == 0){
                        recordingTimer.opacity = 1;
                    }else{
                        recordingTimer.opacity = 0;
                    }
                }
            }
        }
    }



    Loader{
        id: headingBarComponentLoader
        width: 1200
        height: 150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top : parent.top
        sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? headingBarComponent : null

    }

    Component{
        id: headingBarComponent

        //Heading bar item and arrow
        Item{
            anchors.fill: parent
            clip: true
            id: barFuncs
            function headingBarOffset(headingVal){
                return -headingVal * 34.2;
            }


            Image{

                source: "/qmlimages/headingBar.svg"
                anchors.verticalCenter: _root.verticalCenter
                fillMode: Image.Pad
                smooth: true
                x: -655
                transform: Translate{
                    x: barFuncs.headingBarOffset(_activeVehicle.heading.rawValue.toFixed(1))
                }


            }

            Item{
                width: 100
                height: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -30
                Item{
                    id: headingBarArrow
                    height: 50
                    width: 50
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: -35
                    Image{
                        source: "/qmlimages/vehicleArrowOpaque.svg"
                        anchors.fill: parent
                    }




                }
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 25
                    color: "white"
                    text: `${_activeVehicle.heading.rawValue.toFixed(0)}°`
                    font.family:    ScreenTools.normalFontFamily
                }

            }
        }


    }

    Loader{
            id: twoMainBarsLoader
            width: 900
            height: 600
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? twoMainBars : null

    }

    Component{
        id: twoMainBars
        Item{
            id: mainBars
            opacity: 1
            anchors.fill: parent

            function pitchBarOffset(pitchVal){
                return pitchVal * 30;
            }

            function depthBarOffset(depthVal){

                if(depthVal < -5){
                    return (depthVal * 30) + 150;
                }

                return 0;
            }

            function depthBarArrowOffset(depthVal){
                if(depthVal >= -5){
                    return -depthVal * 30;
                }

                return 150;
            }


            function crossHairAngle(rollVal){
                return rollVal;
            }

            //Pitch bar item
            Item{
                id: clipItem
                anchors.left: parent.left
                height: parent.height
                width: 150
                clip: true


                Image{
                    id: leftSidePitchBar

                    source: "/qmlimages/pitchBar.svg"
                    anchors.verticalCenter: _root.verticalCenter
                    fillMode: Image.Pad
                    smooth: true
                    y: -2450
                    transform: Translate{
                        y: mainBars.pitchBarOffset(_activeVehicle.pitch.rawValue.toFixed(1))
                    }

                }

            }

            //Pitch bar top horizon line
            Rectangle{
                width: 45
                height: 5
                color: "#00FF38"
                anchors.bottom: clipItem.top
                anchors.horizontalCenter: clipItem.horizontalCenter
                z: 3
                visible: _activeVehicle.pitch.rawValue.toFixed(1) <= -10

            }

            //Pitch bar bottom horizon line
            Rectangle{
                width: 45
                height: 5
                color: "#00FF38"
                anchors.top: clipItem.bottom
                anchors.horizontalCenter: clipItem.horizontalCenter
                z: 3
                visible: _activeVehicle.pitch.rawValue.toFixed(1) >= 10.5
            }


            //Pitch bar arrow
            Item{
                id: pitchBarArrow
                width: 70
                height: 100
                anchors.horizontalCenter: clipItem.right
                anchors.verticalCenter: clipItem.verticalCenter
                anchors.verticalCenterOffset: 5
                Item{
                    height: 35
                    width: 35
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image{
                        source: "/qmlimages/vehicleArrowOpaque.svg"
                        anchors.fill: parent
                        transform: Rotation{
                            angle: 270

                        }
                    }




                }
                Text{
                    anchors.bottom: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 25
                    color: "white"
                    text: `${_activeVehicle.pitch.rawValue.toFixed(1)}°`
                    font.family:    ScreenTools.normalFontFamily
                }

            }


            //Depth bar item
            Item{
                id: clipItemDepthBar
                anchors.right: parent.right
                height: parent.height
                width: 150
                clip: true


                Image{

                    source: "/qmlimages/depthBar.svg"
                    anchors.verticalCenter: _root.verticalCenter
                    fillMode: Image.Pad
                    smooth: true
                    transform: Translate{
                        y: mainBars.depthBarOffset(_activeVehicle.altitudeRelative.rawValue.toFixed(1))
                    }

                }

            }

            //Depth bar arrow
            Item{
                id: depthBarArrow
                width: 70
                height: 100
                anchors.horizontalCenter: clipItemDepthBar.left
                anchors.verticalCenter: clipItemDepthBar.top
                Item{
                    id: depthBarArrowMovable

                    height: 35
                    width: 35
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: 30
                    transform: Translate{
                        y: mainBars.depthBarArrowOffset(_activeVehicle.altitudeRelative.rawValue.toFixed(1))
                    }
                    Image{
                        source: "/qmlimages/vehicleArrowOpaque.svg"
                        anchors.fill: parent
                        transform: Rotation{
                            angle: 90
                        }
                    }

                }

                Text{
                    anchors.bottom: depthBarArrowMovable.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: -5
                    anchors.verticalCenterOffset: -5
                    font.pixelSize: 25
                    color: "white"
                    text: `${_activeVehicle.altitudeRelative.rawValue.toFixed(1)}M`
                    font.family:    ScreenTools.normalFontFamily

                    transform: Translate{
                        y: mainBars.depthBarArrowOffset(_activeVehicle.altitudeRelative.rawValue.toFixed(1))
                    }
                }
            }

            //Cross hair item
            Item{
                id: crossHairItem
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                height: 100
                width: 100

                Image{
                    id: crossHairIcon
                    source: "/qmlimages/lentaCrossHair.svg"
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.horizontalCenter: _root.horizontalCenter
                    fillMode: Image.Pad
                    smooth: true
                    transform: Rotation{
                        angle: mainBars.crossHairAngle(_activeVehicle.roll.rawValue.toFixed(1))
                        origin.x: crossHairIcon.width/2
                        origin.y: crossHairIcon.height/2
                    }

                }
            }

            //Cross hair roll value
            Item{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -110
                anchors.verticalCenterOffset: -25
                Text{
                    font.pixelSize: 25
                    color: "white"
                    text: `${_activeVehicle.roll.rawValue.toFixed(1)}°`
                    font.family:    ScreenTools.normalFontFamily
                }
            }



        }
    }


    Loader{
        id: miniValuesBarLoader
        width: 50
        height: _root.height * 0.57
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 5
        anchors.left: parent.left
        anchors.leftMargin: 6
        sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? miniValuesBar : null
    }

    Component{
        id: miniValuesBar
        Rectangle{
            anchors.fill: parent
            color: "#80000000"

            Column{
                id: valueBarPrimary
                anchors.fill: parent
                spacing: ScreenTools.defaultFontPixelWidth

                FactPanelController { id: controller; }

                property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
                property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.66

                property Fact lightsOne: controller.vehicle.getFact("apmSubInfo.lights1")
                property Fact lightsTwo: controller.vehicle.getFact("apmSubInfo.lights2")
                property Fact heading_hold_toggle: controller.getParameterFact(-1, "HEADING_HOLD_TOG")
                property Fact heading_hold_toggle_exists: controller.parameterExists(-1, "HEADING_HOLD_TOG")

                property Fact altitude_hold_toggle: controller.getParameterFact(-1, "ALTITUDE_HOLD_TO")
                property Fact altitude_hold_toggle_exists: controller.parameterExists(-1, "ALTITUDE_HOLD_TO")

                property Fact flightTime: controller.vehicle.getFact("FlightTime")
                property Fact temperatureTwo: controller.vehicle.getFact("temperature.temperature2")

                property Fact cameraTilt: controller.vehicle.getFact("apmSubInfo.cameraTilt")

                property Fact pilotGain: controller.vehicle.getFact("apmSubInfo.pilotGain")
                property Fact tetherTurns: controller.vehicle.getFact("apmSubInfo.tetherTurns")
                property Fact inputHold: controller.vehicle.getFact("apmSubInfo.inputHold")

                property Fact recordToggle: controller.getParameterFact(-1, "RECORDING_TOGGLE")



                property real itemSize: miniValuesBarLoader.width * 0.20
                property real valueSize: (itemSize * 0.15)
                property real titleSize: valueSize + 5

                property real itemHeight: 50

                function getTitleSize(){
                    return miniValuesBarLoader.width * 0.01
                }


                function altHldValue(){

                }
                function distHldValue(){

                }

                function getInputHoldColor(val){
                    return (val === 1) ? "#00ff55" : "#FF0000";
                }

                function getHdgToggleValue(){
                    return (valueBarPrimary.heading_hold_toggle.value === 1) ? "ACTIVE" : "NOT ACTIVE";
                }

                function getHdgToggleColor(){
                    if(!valueBarPrimary.heading_hold_toggle_exists){
                        return "#FF0000";
                    }
                    if (valueBarPrimary.heading_hold_toggle.value === 1){
                        _activeVehicle.sayHdgHoldState(true);
                        return "#00ff55";
                    }
                    _activeVehicle.sayHdgHoldState(false);
                    return "#FF0000";

                }

                function getAltToggleColor(){
                    if(!valueBarPrimary.altitude_hold_toggle_exists){
                        return "#FF0000";
                    }
                    if (valueBarPrimary.altitude_hold_toggle.value === 1){
                        _activeVehicle.sayAltHoldState(true);
                        return "#00ff55";
                    }
                    _activeVehicle.sayAltHoldState(false);
                    return "#FF0000";

                }

                //hdg hold
                Item{
                    width: parent.width
                    height: valueBarPrimary.itemHeight


                    Text {
                        id: hdgHoldFirstValText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("HEADING")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily

                    }
                    Text{
                        id: hdgHoldSecondValText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("HOLD")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: hdgHoldFirstValText.bottom
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily

                    }

                    Rectangle{
                        width: 15
                        height: 15
                        radius: 15
                        color: valueBarPrimary.getHdgToggleColor()
                        opacity: 1
                        anchors.top: hdgHoldSecondValText.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 5
                    }

                }

                Rectangle{
                    width: parent.width
                    height: 1
                    color: "white"
                    anchors.right: parent.right
                }

                //alt hold
                Item{
                    width: parent.width
                    height: valueBarPrimary.itemHeight

                    Text {
                        id: altHoldFirstValueText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("ALTITUDE")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily
                    }


                    Text{
                        id: altHoldSecondValueText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("HOLD")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: altHoldFirstValueText.bottom
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily
                    }

                    Rectangle{
                        width: 15
                        height: 15
                        radius: 15
                        color: valueBarPrimary.getAltToggleColor()
                        opacity: 1
                        anchors.top: altHoldSecondValueText.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 5
                    }

                }

                Rectangle{
                    width: parent.width
                    height: 1
                    color: "white"
                    anchors.right: parent.right
                }


                //dist hold
                Item{
                    width: parent.width
                    height: valueBarPrimary.itemHeight

                    Text {
                        id: distHoldFirstValueText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("DISTANCE")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily
                    }

                    Text{
                        id: distHoldSecondValueText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("HOLD")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: distHoldFirstValueText.bottom
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily
                    }

                    Rectangle{
                        width: 15
                        height: 15
                        radius: 15
                        color: "#ff0000"
                        opacity: 1
                        anchors.top: distHoldSecondValueText.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 5
                    }

                }

                Rectangle{
                    width: parent.width
                    height: 1
                    color: "white"
                    anchors.right: parent.right
                }


                //Input hold
                Item{
                    width: parent.width
                    height: valueBarPrimary.itemHeight

                    Text {
                        id: inputHoldFirstValueText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("INPUT")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily
                    }

                    Text{
                        id: inputHoldSecondValueText
                        font.pixelSize: 8
                        font.bold: true
                        text: qsTr("HOLD")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: inputHoldFirstValueText.bottom
                        color: "white"
                        font.family:    ScreenTools.normalFontFamily
                    }

                    Rectangle{
                        width: 15
                        height: 15
                        radius: 15
                        color: valueBarPrimary.getInputHoldColor(valueBarPrimary.inputHold.value)
                        opacity: 1
                        anchors.top: inputHoldSecondValueText.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.topMargin: 5
                    }


                }


                Rectangle{
                    width: parent.width
                    height: 1
                    color: "white"
                    anchors.right: parent.right
                }


                //Joystick stat
                Item{
                    width: parent.width
                    height: valueBarPrimary.itemHeight
                   Text{
                       id: joystickLabel
                       font.pixelSize: 8;
                       font.bold: true
                       color: "white";
                       text: "JOYSTICK";
                       anchors.horizontalCenter: parent.horizontalCenter;
                       anchors.top: parent.top;
                       anchors.topMargin: 3
                       font.family:    ScreenTools.normalFontFamily
                   }


                    Loader {
                        anchors.bottom:     parent.bottom
                        anchors.top: joystickLabel.top
                        anchors.topMargin: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                        source:             "qrc:/toolbar/JoystickIndicator.qml"
                        visible:            item.showIndicator
                    }
                }


                Rectangle{
                    width: parent.width
                    height: 1
                    color: "white"
                    anchors.right: parent.right
                }

                //Video record
                Item{
                    id: videoRecordToggle


                    // The following properties relate to a simple camera
                    property var    _flyViewSettings:                           QGroundControl.settingsManager.flyViewSettings
                    property bool   _simpleCameraAvailable:                     !_mavlinkCamera && _activeVehicle && _flyViewSettings.showSimpleCameraControl.rawValue
                    property bool   _onlySimpleCameraAvailable:                 !_anyVideoStreamAvailable && _simpleCameraAvailable
                    property bool   _simpleCameraIsShootingInCurrentMode:       _onlySimpleCameraAvailable && !_simplePhotoCaptureIsIdle

                    // The following properties relate to a simple video stream
                    property bool   _videoStreamAvailable:                      _videoStreamManager.hasVideo
                    property var    _videoStreamSettings:                       QGroundControl.settingsManager.videoSettings
                    property var    _videoStreamManager:                        QGroundControl.videoManager
                    property bool   _videoStreamAllowsPhotoWhileRecording:      true
                    property bool   _videoStreamIsStreaming:                    _videoStreamManager.streaming
                    property bool   _simplePhotoCaptureIsIdle:             true
                    property bool   _videoStreamRecording:                      _videoStreamManager.recording
                    property bool   _videoStreamCanShoot:                       _videoStreamIsStreaming
                    property bool   _videoStreamIsShootingInCurrentMode:        _videoStreamInPhotoMode ? !_simplePhotoCaptureIsIdle : _videoStreamRecording
                    property bool   _videoStreamInPhotoMode:                    false

                    // The following properties relate to a mavlink protocol camera
                    property var    _mavlinkCameraManager:                      _activeVehicle ? _activeVehicle.cameraManager : null
                    property int    _mavlinkCameraManagerCurCameraIndex:        _mavlinkCameraManager ? _mavlinkCameraManager.currentCamera : -1
                    property bool   _noMavlinkCameras:                          _mavlinkCameraManager ? _mavlinkCameraManager.cameras.count === 0 : true
                    property var    _mavlinkCamera:                             !_noMavlinkCameras ? (_mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex) && _mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex).paramComplete ? _mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex) : null) : null
                    property bool   _multipleMavlinkCameras:                    _mavlinkCameraManager ? _mavlinkCameraManager.cameras.count > 1 : false
                    property string _mavlinkCameraName:                         _mavlinkCamera && _multipleMavlinkCameras ? _mavlinkCamera.modelName : ""
                    property bool   _noMavlinkCameraStreams:                    _mavlinkCamera ? _mavlinkCamera.streamLabels.length : true
                    property bool   _multipleMavlinkCameraStreams:              _mavlinkCamera ? _mavlinkCamera.streamLabels.length > 1 : false
                    property int    _mavlinCameraCurStreamIndex:                _mavlinkCamera ? _mavlinkCamera.currentStream : -1
                    property bool   _mavlinkCameraHasThermalVideoStream:        _mavlinkCamera ? _mavlinkCamera.thermalStreamInstance : false
                    property bool   _mavlinkCameraModeUndefined:                _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_UNDEFINED : true
                    property bool   _mavlinkCameraInVideoMode:                  _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_VIDEO : false
                    property bool   _mavlinkCameraInPhotoMode:                  _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_PHOTO : false
                    property bool   _mavlinkCameraElapsedMode:                  _mavlinkCamera && _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_PHOTO && _mavlinkCamera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE
                    property bool   _mavlinkCameraHasModes:                     _mavlinkCamera && _mavlinkCamera.hasModes
                    property bool   _mavlinkCameraVideoIsRecording:             _mavlinkCamera && _mavlinkCamera.videoStatus === QGCCameraControl.VIDEO_CAPTURE_STATUS_RUNNING
                    property bool   _mavlinkCameraPhotoCaptureIsIdle:           _mavlinkCamera && (_mavlinkCamera.photoStatus === QGCCameraControl.PHOTO_CAPTURE_IDLE || _mavlinkCamera.photoStatus >= QGCCameraControl.PHOTO_CAPTURE_LAST)
                    property bool   _mavlinkCameraStorageReady:                 _mavlinkCamera && _mavlinkCamera.storageStatus === QGCCameraControl.STORAGE_READY
                    property bool   _mavlinkCameraBatteryReady:                 _mavlinkCamera && _mavlinkCamera.batteryRemaining >= 0
                    property bool   _mavlinkCameraStorageSupported:             _mavlinkCamera && _mavlinkCamera.storageStatus !== QGCCameraControl.STORAGE_NOT_SUPPORTED
                    property bool   _mavlinkCameraAllowsPhotoWhileRecording:    false
                    property bool   _mavlinkCameraCanShoot:                     (!_mavlinkCameraModeUndefined && ((_mavlinkCameraStorageReady && _mavlinkCamera.storageFree > 0) || !_mavlinkCameraStorageSupported)) || _videoStreamManager.streaming
                    property bool   _mavlinkCameraIsShooting:                   ((_mavlinkCameraInVideoMode && _mavlinkCameraVideoIsRecording) || (_mavlinkCameraInPhotoMode && !_mavlinkCameraPhotoCaptureIsIdle)) || _videoStreamManager.recording

                    // The following settings and functions unify between a mavlink camera and a simple video stream for simple access

                    property bool   _anyVideoStreamAvailable:                   _videoStreamManager.hasVideo
                    property string _cameraName:                                _mavlinkCamera ? _mavlinkCameraName : ""
                    property bool   _showModeIndicator:                         _mavlinkCamera ? _mavlinkCameraHasModes : _videoStreamManager.hasVideo
                    property bool   _modeIndicatorPhotoMode:                    _mavlinkCamera ? _mavlinkCameraInPhotoMode : _videoStreamInPhotoMode || _onlySimpleCameraAvailable
                    property bool   _allowsPhotoWhileRecording:                  _mavlinkCamera ? _mavlinkCameraAllowsPhotoWhileRecording : _videoStreamAllowsPhotoWhileRecording
                    property bool   _switchToPhotoModeAllowed:                  !_modeIndicatorPhotoMode && (_mavlinkCamera ? !_mavlinkCameraIsShooting : true)
                    property bool   _switchToVideoModeAllowed:                  _modeIndicatorPhotoMode && (_mavlinkCamera ? !_mavlinkCameraIsShooting : true)
                    property bool   _videoIsRecording:                          _mavlinkCamera ? _mavlinkCameraIsShooting : _videoStreamRecording
                    property bool   _canShootInCurrentMode:                     _mavlinkCamera ? _mavlinkCameraCanShoot : _videoStreamCanShoot || _simpleCameraAvailable
                    property bool   _isShootingInCurrentMode:                   _mavlinkCamera ? _mavlinkCameraIsShooting : _videoStreamIsShootingInCurrentMode || _simpleCameraIsShootingInCurrentMode

                    function toggleShooting() {
                        if (_mavlinkCamera && _mavlinkCamera.capturesVideo) {
                            if(_mavlinkCameraInVideoMode) {
                                _mavlinkCamera.toggleVideo()
                            } else {
                                if(_mavlinkCameraInPhotoMode && !_mavlinkCameraPhotoCaptureIsIdle && _mavlinkCameraElapsedMode) {
                                    _mavlinkCamera.stopTakePhoto()
                                } else {
                                    _mavlinkCamera.takePhoto()
                                }
                            }
                        } else if (_anyVideoStreamAvailable) {
                            if (_videoStreamInPhotoMode) {
                                _simplePhotoCaptureIsIdle = false
                                _videoStreamManager.grabImage()
                                simplePhotoCaptureTimer.start()
                            } else {
                                if (_videoStreamManager.recording) {
                                    _videoStreamManager.stopRecording()
                                } else {
                                    _videoStreamManager.startRecording()
                                }
                            }
                        }
                    }
                    width: parent.width
                    height: valueBarPrimary.itemHeight *1.5

                    Text {
                        id: video_rec_text
                        text: qsTr("VIDEO REC")
                        font.pixelSize: 8;
                        font.bold: true

                        color: "white";
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.top: parent.top;
                        anchors.topMargin: 3
                        font.family:    ScreenTools.normalFontFamily

                    }
                    Rectangle {
                        Layout.alignment:   Qt.AlignHCenter
                        anchors.top: video_rec_text.bottom
                        anchors.topMargin: 7
                        color:              Qt.rgba(0,0,0,0)
                        width: parent.width
                        height:             width
                        radius:             width * 0.5
                        border.color:       qgcPal.buttonText
                        border.width:       3

                        Rectangle {
                            anchors.centerIn:   parent
                            width:              parent.width * (videoRecordToggle._isShootingInCurrentMode ? 0.5 : 0.75)
                            height:             width
                            radius:             videoRecordToggle._isShootingInCurrentMode ? 0 : width * 0.5
                            color:              videoRecordToggle._canShootInCurrentMode ? qgcPal.colorRed : qgcPal.colorGrey
                        }

                        MouseArea {
                            anchors.fill:   parent
                            enabled:        videoRecordToggle._canShootInCurrentMode
                            onClicked:      videoRecordToggle.toggleShooting()
                        }
                    }


                }

                Rectangle{
                    width: parent.width
                    height: 1
                    color: "white"
                    anchors.right: parent.right
                }

                //Video Photo capture
                Item{
                    id: videoPhotoToggle



                    // The following properties relate to a simple camera
                    property var    _flyViewSettings:                           QGroundControl.settingsManager.flyViewSettings
                    property bool   _simpleCameraAvailable:                     !_mavlinkCamera && _activeVehicle && _flyViewSettings.showSimpleCameraControl.rawValue
                    property bool   _onlySimpleCameraAvailable:                 !_anyVideoStreamAvailable && _simpleCameraAvailable
                    property bool   _simpleCameraIsShootingInCurrentMode:       _onlySimpleCameraAvailable && !_simplePhotoCaptureIsIdle

                    // The following properties relate to a simple video stream
                    property bool   _videoStreamAvailable:                      _videoStreamManager.hasVideo
                    property var    _videoStreamSettings:                       QGroundControl.settingsManager.videoSettings
                    property var    _videoStreamManager:                        QGroundControl.videoManager
                    property bool   _videoStreamAllowsPhotoWhileRecording:      true
                    property bool   _videoStreamIsStreaming:                    _videoStreamManager.streaming
                    property bool   _simplePhotoCaptureIsIdle:             true
                    property bool   _videoStreamRecording:                      _videoStreamManager.recording
                    property bool   _videoStreamCanShoot:                       _videoStreamIsStreaming
                    property bool   _videoStreamIsShootingInCurrentMode:        _videoStreamInPhotoMode ? !_simplePhotoCaptureIsIdle : _videoStreamRecording
                    property bool   _videoStreamInPhotoMode:                    true

                    // The following properties relate to a mavlink protocol camera
                    property var    _mavlinkCameraManager:                      _activeVehicle ? _activeVehicle.cameraManager : null
                    property int    _mavlinkCameraManagerCurCameraIndex:        _mavlinkCameraManager ? _mavlinkCameraManager.currentCamera : -1
                    property bool   _noMavlinkCameras:                          _mavlinkCameraManager ? _mavlinkCameraManager.cameras.count === 0 : true
                    property var    _mavlinkCamera:                             !_noMavlinkCameras ? (_mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex) && _mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex).paramComplete ? _mavlinkCameraManager.cameras.get(_mavlinkCameraManagerCurCameraIndex) : null) : null
                    property bool   _multipleMavlinkCameras:                    _mavlinkCameraManager ? _mavlinkCameraManager.cameras.count > 1 : false
                    property string _mavlinkCameraName:                         _mavlinkCamera && _multipleMavlinkCameras ? _mavlinkCamera.modelName : ""
                    property bool   _noMavlinkCameraStreams:                    _mavlinkCamera ? _mavlinkCamera.streamLabels.length : true
                    property bool   _multipleMavlinkCameraStreams:              _mavlinkCamera ? _mavlinkCamera.streamLabels.length > 1 : false
                    property int    _mavlinCameraCurStreamIndex:                _mavlinkCamera ? _mavlinkCamera.currentStream : -1
                    property bool   _mavlinkCameraHasThermalVideoStream:        _mavlinkCamera ? _mavlinkCamera.thermalStreamInstance : false
                    property bool   _mavlinkCameraModeUndefined:                _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_UNDEFINED : true
                    property bool   _mavlinkCameraInVideoMode:                  _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_VIDEO : false
                    property bool   _mavlinkCameraInPhotoMode:                  _mavlinkCamera ? _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_PHOTO : false
                    property bool   _mavlinkCameraElapsedMode:                  _mavlinkCamera && _mavlinkCamera.cameraMode === QGCCameraControl.CAM_MODE_PHOTO && _mavlinkCamera.photoMode === QGCCameraControl.PHOTO_CAPTURE_TIMELAPSE
                    property bool   _mavlinkCameraHasModes:                     _mavlinkCamera && _mavlinkCamera.hasModes
                    property bool   _mavlinkCameraVideoIsRecording:             _mavlinkCamera && _mavlinkCamera.videoStatus === QGCCameraControl.VIDEO_CAPTURE_STATUS_RUNNING
                    property bool   _mavlinkCameraPhotoCaptureIsIdle:           _mavlinkCamera && (_mavlinkCamera.photoStatus === QGCCameraControl.PHOTO_CAPTURE_IDLE || _mavlinkCamera.photoStatus >= QGCCameraControl.PHOTO_CAPTURE_LAST)
                    property bool   _mavlinkCameraStorageReady:                 _mavlinkCamera && _mavlinkCamera.storageStatus === QGCCameraControl.STORAGE_READY
                    property bool   _mavlinkCameraBatteryReady:                 _mavlinkCamera && _mavlinkCamera.batteryRemaining >= 0
                    property bool   _mavlinkCameraStorageSupported:             _mavlinkCamera && _mavlinkCamera.storageStatus !== QGCCameraControl.STORAGE_NOT_SUPPORTED
                    property bool   _mavlinkCameraAllowsPhotoWhileRecording:    false
                    property bool   _mavlinkCameraCanShoot:                     (!_mavlinkCameraModeUndefined && ((_mavlinkCameraStorageReady && _mavlinkCamera.storageFree > 0) || !_mavlinkCameraStorageSupported)) || _videoStreamManager.streaming
                    property bool   _mavlinkCameraIsShooting:                   ((_mavlinkCameraInVideoMode && _mavlinkCameraVideoIsRecording) || (_mavlinkCameraInPhotoMode && !_mavlinkCameraPhotoCaptureIsIdle)) || _videoStreamManager.recording

                    // The following settings and functions unify between a mavlink camera and a simple video stream for simple access

                    property bool   _anyVideoStreamAvailable:                   _videoStreamManager.hasVideo
                    property string _cameraName:                                _mavlinkCamera ? _mavlinkCameraName : ""
                    property bool   _showModeIndicator:                         _mavlinkCamera ? _mavlinkCameraHasModes : _videoStreamManager.hasVideo
                    property bool   _modeIndicatorPhotoMode:                    _mavlinkCamera ? _mavlinkCameraInPhotoMode : _videoStreamInPhotoMode || _onlySimpleCameraAvailable
                    property bool   _allowsPhotoWhileRecording:                  _mavlinkCamera ? _mavlinkCameraAllowsPhotoWhileRecording : _videoStreamAllowsPhotoWhileRecording
                    property bool   _switchToPhotoModeAllowed:                  !_modeIndicatorPhotoMode && (_mavlinkCamera ? !_mavlinkCameraIsShooting : true)
                    property bool   _switchToVideoModeAllowed:                  _modeIndicatorPhotoMode && (_mavlinkCamera ? !_mavlinkCameraIsShooting : true)
                    property bool   _videoIsRecording:                          _mavlinkCamera ? _mavlinkCameraIsShooting : _videoStreamRecording
                    property bool   _canShootInCurrentMode:                     _mavlinkCamera ? _mavlinkCameraCanShoot : _videoStreamCanShoot || _simpleCameraAvailable
                    property bool   _isShootingInCurrentMode:                   _mavlinkCamera ? _mavlinkCameraIsShooting : _videoStreamIsShootingInCurrentMode || _simpleCameraIsShootingInCurrentMode

                    Timer {
                        id:             simplePhotoCaptureTimer
                        interval:       500
                        onTriggered:    videoPhotoToggle._simplePhotoCaptureIsIdle = true
                    }

                    function toggleShooting() {
                        if (_mavlinkCamera && _mavlinkCamera.capturesVideo) {
                            if(_mavlinkCameraInVideoMode) {
                                _mavlinkCamera.toggleVideo()
                            } else {
                                if(_mavlinkCameraInPhotoMode && !_mavlinkCameraPhotoCaptureIsIdle && _mavlinkCameraElapsedMode) {
                                    _mavlinkCamera.stopTakePhoto()
                                } else {
                                    _mavlinkCamera.takePhoto()
                                }
                            }
                        } else if (_anyVideoStreamAvailable) {
                            if (_videoStreamInPhotoMode) {
                                _simplePhotoCaptureIsIdle = false
                                _videoStreamManager.grabImage()
                                simplePhotoCaptureTimer.start()
                            } else {
                                if (_videoStreamManager.recording) {
                                    _videoStreamManager.stopRecording()
                                } else {
                                    _videoStreamManager.startRecording()
                                }
                            }
                        }
                    }

                    width: parent.width
                    height: valueBarPrimary.itemHeight *1.5

                    Text {
                        id: photo_cap_text
                        text: qsTr("PHOTO CAP")
                        font.pixelSize: 8;
                        font.bold: true

                        color: "white";
                        anchors.horizontalCenter: parent.horizontalCenter;
                        anchors.top: parent.top;
                        anchors.topMargin: 3
                        font.family:    ScreenTools.normalFontFamily
                    }   

                    Rectangle {
                        Layout.alignment:   Qt.AlignHCenter
                        color:              Qt.rgba(0,0,0,0)
                        anchors.top: photo_cap_text.bottom
                        anchors.topMargin: 7
                        width: parent.width
                        height:             width
                        radius:             width * 0.5
                        border.color:       qgcPal.buttonText
                        border.width:       3

                        Rectangle {
                            anchors.centerIn:   parent
                            width:              parent.width * (videoPhotoToggle._isShootingInCurrentMode ? 0.5 : 0.75)
                            height:             width
                            radius:             videoPhotoToggle._isShootingInCurrentMode ? 0 : width * 0.5
                            color:              videoPhotoToggle._canShootInCurrentMode ? qgcPal.text : qgcPal.colorGrey
                        }

                        MouseArea {
                            anchors.fill:   parent
                            enabled:        videoPhotoToggle._canShootInCurrentMode
                            onClicked:      videoPhotoToggle.toggleShooting()
                        }
                    }
                }
            }
        }
    }

    

}
