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

    property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.33

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

    // MapScale {
    //     id:                 mapScale
    //     anchors.margins:    _toolsMargin
    //     anchors.left:       toolStrip.right
    //     anchors.top:        parent.top
    //     mapControl:         _mapControl
    //     buttonsOnLeft:      false
    //     visible:            !ScreenTools.isTinyScreen && QGroundControl.corePlugin.options.flyView.showMapScale && mapControl.pipState.state === mapControl.pipState.fullState

    //     property real centerInset: visible ? parent.height - y : 0
    // }

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
        height: _root.height * 0.1
        width: _root.width * 0.1
        anchors{
            right: _root.right
            top: _root.top
            topMargin: height * 0.5
            rightMargin: width * 0.5
        }
    }

    Component{
        id: lentaVideoRecordingState

        Item{
            id: lentaVideoRecordingItem
            anchors.fill: parent
            visible: (QGroundControl.videoManager.recording)

            Rectangle{
                id: recordingTimer
                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                width: parent.width * 0.13
                height: width
                radius: width
                color: "red"
                opacity: 0
            }

            Text{
                anchors{
                    left: recordingTimer.right
                    leftMargin: ScreenTools.defaultFontPixelHeight * 0.5
                    verticalCenter: parent.verticalCenter
                }
                font.family:    ScreenTools.normalFontFamily
                font.pointSize: ScreenTools.defaultFontPointSize * 1.5
                color: "white"
                text: "Recording"
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
        width: _root.width * 0.9
        height: _root.height * 0.15
        anchors.horizontalCenter: parent.horizontalCenter

        sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? headingBarComponent : null
    }

    Component{
        id: headingBarComponent
        Item{
            // color: "yellow"
            id: headingBarItem
            width: parent.width
            anchors{
                top: parent.top
                bottom: parent.bottom
            }

            property real headingBarToothWidth: width * 0.1 * 0.2
            property real initialXOffset: 35

            Item{
                id: headingBarRow
                // color: "blue"
                height: parent.height * 0.2
                width: parent.width
                anchors{
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }

                ListModel {
                    id: headingBarValues
                    Component.onCompleted: {
                        let i = 0;

                        for(i = 300; i <= 359; i += 1)
                        {
                            if (i % 5 == 0){
                                headingBarValues.append({"index": i, "type": "line"})
                            }else{
                                headingBarValues.append({"index": i, "type": "no-line"});
                            }

                        }
                        for(i = 0; i <= 359; i += 1)
                        {
                            if (i % 5 == 0){
                                headingBarValues.append({"index": i, "type": "line"})
                            }else{
                                headingBarValues.append({"index": i, "type": "no-line"});
                            }
                        }
                        for(i = 0; i <= 60; i += 1)
                        {
                            if (i % 5 == 0){
                                headingBarValues.append({"index": i, "type": "line"})
                            }else{
                                headingBarValues.append({"index": i, "type": "no-line"});
                            }
                        }
                    }
                }

                ListView{
                    id: headingBarListView
                    model: headingBarValues
                    orientation: Qt.Horizontal
                    layoutDirection: Qt.LeftToRight
                    width: headingBarRow.width
                    height: headingBarRow.height
                    interactive: false


                    Component.onCompleted: {
                        let heading = _activeVehicle.heading.rawValue.toFixed(0);
                        headingBarListView.positionViewAtIndex(headingBarItem.initialXOffset + Number(heading), ListView.Beginning)
                    }

                    Connections{
                        target: _activeVehicle.heading
                        onValueChanged: {
                            let heading = _activeVehicle.heading.rawValue.toFixed(0);
                            headingBarListView.positionViewAtIndex(headingBarItem.initialXOffset + Number(heading), ListView.Beginning)
                        }
                    }


                    delegate: Item{
                        // color: model.index % 2 == 0 ? "red" : "blue"
                        height: headingBarListView.height
                        width: headingBarItem.headingBarToothWidth
                        // border.width: 2
                        // border.color: "red"


                        Text{
                            anchors{
                                top: parent.top
                                horizontalCenter: parent.left
                            }
                            font.pointSize: ScreenTools.defaultFontPointSize
                            font.bold: true
                            color: "white"
                            // text: `${index}°`
                            text: {
                                switch (model.type){
                                case "line":
                                    return `${model.index}°`;
                                default:
                                    return ``;
                                }
                            }
                        }

                        Item{
                            anchors{
                                top: parent.children[0].bottom
                                bottom: parent.bottom
                                topMargin: _toolIndicatorMargins * 0.35
                                horizontalCenter: parent.left
                            }
                            width: 3
                            Rectangle{
                                visible: model.type === "line" ? true : false
                                anchors.fill: parent
                                color: "white"
                            }
                        }
                    }
                }
            }

            Item{
                // color: "blue"
                id: headingBarArrowItem

                anchors{
                    top: headingBarRow.bottom
                    horizontalCenter: parent.horizontalCenter
                    topMargin: _toolIndicatorMargins * 0.5
                }
                height: 0.8 * parent.height - headingBarRow.height
                width: parent.width * 0.05
                y: parent.height * 0.1
                Item{
                    id: headingBarArrowIcon
                    anchors{
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    height: parent.height * 0.5
                    width: parent.width
                    Image{
                        height: parent.height
                        anchors.centerIn: parent
                        source: "/qmlimages/vehicleArrowOpaque.svg"
                        fillMode: Image.PreserveAspectFit
                    }
                }
                Text{
                    anchors{
                        top: headingBarArrowIcon.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    text: `${_activeVehicle.heading.rawValue.toFixed(0)}°`
                    color: "white"
                    font.pointSize: ScreenTools.defaultFontPointSize * 1.5
                    font.bold: true
                }
            }

        }
    }

    Loader{
        id: pitchBarComponentLoader
        anchors{
            verticalCenter: _root.verticalCenter
        }
        width: _root.width * 0.2
        height: _root.height * 0.72
        x: _root.width * 0.3 - width * 0.5
        sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? pitchBarComponent : null

        anchors.margins: 0

    }

    Component{
        id: pitchBarComponent

        Item{
            id: pitchBarItem
            clip: true

            property double pitchBarHeightMultiplier: 0.08
            property double pitchBarToothHeight: _root.height * 0.72 * 0.08 * 0.2
            property double initialYOffset: 845

            Item{
                // color: "blue"
                id: pitchBarColumn
                anchors{
                    left: parent.left
                }
                height: parent.height
                width: parent.width * 0.27

                ListModel {
                    id: pitchBarValues
                    Component.onCompleted: {

                        for(let i = 875; i >= -875; i--)
                        {
                            if (i == 875 || (i - 875) % 25 == 0){
                                pitchBarValues.append({"index": i, "type": "long-line"})
                            } else if ((i - 875) % 5 == 0)
                            {
                                pitchBarValues.append({"index": i, "type": "short-line"})
                            } else{
                                pitchBarValues.append({"index": i, "type": "no-line"});
                            }
                        }
                    }
                }

                ListView{
                    id: pitchBarListView
                    model: pitchBarValues
                    height: parent.height
                    width: parent.width
                    interactive: false

                    Component.onCompleted: {
                        let pitch = _activeVehicle.pitch.rawValue.toFixed(1);
                        pitchBarListView.positionViewAtIndex(pitchBarItem.initialYOffset + pitch * -5, ListView.Beginning)
                    }

                    Connections{
                        id: pitchConnection
                        target: _activeVehicle.pitch
                        onValueChanged: {
                            let pitch = _activeVehicle.pitch.rawValue.toFixed(1);
                            pitchBarListView.positionViewAtIndex(pitchBarItem.initialYOffset + pitch * -5, ListView.Beginning)
                        }
                    }

                    delegate: Item{
                        // color: model.index % 2 == 0 ? "red" : "blue"
                        height: pitchBarItem.pitchBarToothHeight
                        width: pitchBarColumn.width



                        Item{
                            anchors{
                                left: parent.left
                                verticalCenter: parent.top
                            }
                            width: parent.width * 0.5

                            Text{
                                anchors.centerIn: parent
                                font.pointSize: ScreenTools.defaultFontPointSize
                                font.bold: true
                                color: "white"
                                text: {
                                    // return model.index % 5 == 0 ? `${model.index}°` : ``
                                    switch (model.type){
                                    case "long-line":
                                        return `${model.index * 0.2}°`

                                    default:
                                        return ``
                                    }
                                }
                            }
                        }


                        Item{
                            anchors{
                                left: parent.children[0].right
                                leftMargin: _toolIndicatorMargins * 0.25
                                verticalCenter: parent.top
                                right: parent.right
                            }
                            height: parent.height


                            Rectangle{
                                anchors.centerIn: parent
                                height: 3
                                // width: model.index % 5 == 0 ? parent.width : parent.width * 0.75
                                width: {
                                    switch (model.type){
                                    case "long-line":
                                        return parent.width
                                    case "short-line":
                                        return parent.width * 0.75
                                    case "no-line":
                                        return 0
                                    }
                                }

                                color: "white"


                            }
                        }
                    }

                }
            }


            Item{
                // color: "blue"
                id: pitchBarArrowItem
                anchors{
                    right: parent.right
                }
                height: parent.height
                width: parent.width - pitchBarColumn.width - _toolIndicatorMargins

                Item{
                    // color: "green"
                    height: pitchBarItem.pitchBarToothHeight * 5
                    width: parent.width
                    y: pitchBarItem.pitchBarToothHeight * 30
                    Image{
                        id: pitchBarArrowIcon
                        anchors{
                            left: parent.left
                            leftMargin: _toolIndicatorMargins
                            verticalCenter: parent.top
                        }
                        height: parent.height
                        rotation: -90
                        source: "/qmlimages/vehicleArrowOpaque.svg"
                        fillMode: Image.PreserveAspectFit
                    }
                    Text{
                        anchors{
                            left: pitchBarArrowIcon.right
                            verticalCenter: parent.top
                        }
                        text: `${_activeVehicle.pitch.rawValue.toFixed(1)}°`
                        color: "white"
                        font.pointSize: ScreenTools.defaultFontPointSize * 1.5
                        font.bold: true
                    }
                }

            }
        }
    }


    Loader{
        id: depthBarComponentLoader
        anchors{
            verticalCenter: _root.verticalCenter
        }
        width: _root.width * 0.2
        // height: _root.height * 0.72
        height: _root.height * 0.864
        x: _root.width * 0.7 - width * 0.5
        sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? depthBarComponent : null
    }


    Component{
        id: depthBarComponent

        Item{
            id: depthBarItem
            anchors.fill: parent
            clip: true

            property real depthBarHeightMultiplier: 0.08
            property real depthBarToothHeight: height * 0.8 * depthBarHeightMultiplier * 0.2
            property real initialYOffset: 25 * depthBarToothHeight

            Item{
                id: depthBarColumn
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                // height: parent.height
                height: parent.height * 0.8
                // width: parent.width * 0.27
                width: parent.width * 0.405

                ListModel {
                    id: depthBarValues
                    Component.onCompleted: {
                        for(let i = 0; i <= 5000; i++)
                        {
                            if (i % 25 == 0)
                            {
                                depthBarValues.append({"index": i, "type": "long-line"});
                            }else if (i % 5 == 0){
                                depthBarValues.append({"index": i, "type": "short-line"});
                            }else {
                                depthBarValues.append({"index": i, "type": "no-line"});
                            }
                        }
                    }
                }
                ListView{
                    id: depthBarListView
                    model: depthBarValues
                    height: parent.height
                    width: parent.width
                    interactive: false

                    Component.onCompleted: {
                        let depth = -1 * _activeVehicle.altitudeRelative.rawValue.toFixed(1);
                        depthBarListView.positionViewAtIndex(depthBarItem.initialYOffset + (depth-5) * 5, ListView.Beginning)
                    }

                    Connections{
                        target: _activeVehicle.altitudeRelative
                        onValueChanged: {
                            let depth = -1 * _activeVehicle.altitudeRelative.rawValue.toFixed(1);
                            if (depth >= 5){
                                depthBarListView.positionViewAtIndex((depth-5) * 5, ListView.Beginning)
                                return;
                            }
                            depthBarListView.positionViewAtIndex(0, ListView.Beginning);
                        }
                    }

                    delegate: Item{
                        // color: model.index % 2 == 0 ? "red" : "blue"
                        height: depthBarItem.depthBarToothHeight
                        width: depthBarColumn.width

                        Item{
                            // color: "green"
                            anchors{
                                right: parent.right
                                verticalCenter: parent.top
                            }
                            width: parent.width * 0.75
                            Text{
                                // anchors.centerIn: parent
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: _toolIndicatorMargins * 2
                                }

                                font.pointSize: ScreenTools.defaultFontPointSize
                                font.bold: true
                                color: "white"
                                text: {
                                    switch (model.type){
                                    case "long-line":
                                        return `${model.index * 0.2}°`
                                        // return `850°`
                                    default:
                                        return ``
                                    }
                                }
                            }
                        }


                        Item{
                            // color: "cyan"
                            anchors{
                                right: parent.children[0].left
                                rightMargin: _toolIndicatorMargins * 0.25
                                verticalCenter: parent.top
                                left: parent.left
                            }
                            height: parent.height
                            Rectangle{
                                anchors.centerIn: parent
                                height: 3
                                width: {
                                    switch (model.type){
                                    case "long-line":
                                        return parent.width
                                    case "short-line":
                                        return parent.width * 0.75
                                    default:
                                        return 0
                                    }
                                }
                                color: "white"
                            }
                        }
                    }
                }
            }

            Item{
                // color: "purple"
                id: depthBarArrowItem
                anchors{
                    left: parent.left
                }
                height: parent.height * 0.8
                width: parent.width - depthBarColumn.width - _toolIndicatorMargins
                y: parent.height * 0.5 - height * 0.5

                Item{
                    // color: "green"
                    height: depthBarItem.depthBarToothHeight * 5
                    width: parent.width
                    y: {
                        let depth = -1 * _activeVehicle.altitudeRelative.rawValue.toFixed(1);
                        if (depth <= 5 && depth >= 0){
                            return (depth * depthBarItem.depthBarToothHeight * 5);
                        }
                        else if (depth >= 5){
                            return depthBarItem.initialYOffset
                        }
                        return 0;
                    }

                    Image{
                        id: depthBarArrowIcon
                        anchors{
                            right: parent.right
                            rightMargin: _toolIndicatorMargins
                            verticalCenter: parent.top
                        }
                        height: parent.height
                        rotation: 90
                        source: "/qmlimages/vehicleArrowOpaque.svg"
                        fillMode: Image.PreserveAspectFit
                    }
                    Text{
                        anchors{
                            right: depthBarArrowIcon.left
                            rightMargin: _toolIndicatorMargins
                            verticalCenter: parent.top
                        }
                        text: `${_activeVehicle.altitudeRelative.rawValue.toFixed(1)}M`
                        color: "white"
                        font.pointSize: ScreenTools.defaultFontPointSize * 1.5
                        font.bold: true
                    }
                }
            }
        }
    }


    Loader{
        id: rollIconComponentLoader
        anchors.centerIn: parent
        height: _root.height * 0.5
        width: height
        sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? rollIconBarComponent : null
    }

    Component{
        id: rollIconBarComponent

        //Cross hair item
        Item{
            // color: "green"
            anchors.fill: parent

            Item{
                // color: "blue"
                id: crossHairItem
                anchors.centerIn: parent
                width: parent.width * 0.2
                height: width

                Image{
                    id: crossHairIcon
                    source: "/qmlimages/lentaCrossHair.svg"
                    anchors.centerIn: parent
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    transform: Rotation{
                        angle: _activeVehicle.roll.rawValue.toFixed(1)
                        origin.x: crossHairIcon.width * 0.5
                        origin.y: crossHairIcon.height * 0.5
                    }
                }

                Text{
                    anchors{
                        left: crossHairIcon.right
                        leftMargin: ScreenTools.defaultFontPointSize
                        verticalCenter: parent.verticalCenter
                    }
                    font.pointSize: ScreenTools.defaultFontPointSize * 1.5
                    font.family:    ScreenTools.normalFontFamily
                    font.bold: true
                    color: "white"
                    text: `${_activeVehicle.roll.rawValue.toFixed(1)}°`
                }

            }
        }

    }


    Loader{
        id: miniValuesBarLoader
        width: _root.width * 0.035
        // height: _root.height * 0.5
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 5
        anchors.left: parent.left
        anchors.leftMargin: width * 0.15
        sourceComponent: (_activeVehicle.loadCustomAddedLentaComponents) ? miniValuesBar : null
    }

    Component{
        id: miniValuesBar

        Column{
            id: valueBarPrimary
            // anchors.fill: parent
            width: parent.width
            spacing: ScreenTools.defaultFontPixelWidth

            FactPanelController { id: controller; }

            property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
            property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.66

            property Fact lightsOne: controller.vehicle.getFact("apmSubInfo.lights1")
            property Fact lightsTwo: controller.vehicle.getFact("apmSubInfo.lights2")

            property Fact flightTime: controller.vehicle.getFact("FlightTime")
            property Fact temperatureTwo: controller.vehicle.getFact("temperature.temperature2")

            property Fact cameraTilt: controller.vehicle.getFact("apmSubInfo.cameraTilt")

            property Fact pilotGain: controller.vehicle.getFact("apmSubInfo.pilotGain")
            property Fact tetherTurns: controller.vehicle.getFact("apmSubInfo.tetherTurns")
            property Fact inputHold: controller.vehicle.getFact("apmSubInfo.inputHold")




            property real itemSize: miniValuesBarLoader.width * 0.20
            property real valueSize: (itemSize * 0.15)
            property real titleSize: valueSize + 5

            property real itemHeight: _root.height * 0.075

            function getTitleSize(){
                return miniValuesBarLoader.width * 0.01
            }

            //Joystick stat
            Item{
                width: parent.width
                height: valueBarPrimary.itemHeight
               Text{
                   id: joystickLabel
                   font.bold: true
                   color: "white";
                   text: "JoyStick";
                   anchors.horizontalCenter: parent.horizontalCenter;
                   anchors.top: parent.top;
                   font.family:    ScreenTools.normalFontFamily
                   font.pointSize:     ScreenTools.defaultFontPointSize * 1
               }


                Loader {
                    anchors{
                        // bottom:     parent.bottom
                        top: joystickLabel.top
                        topMargin: height * 0.35
                        horizontalCenter: parent.horizontalCenter
                    }
                    height: parent.height * 0.5



                    source:             "qrc:/toolbar/JoystickIndicator.qml"
                    visible:            item.showIndicator
                }
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
                height: valueBarPrimary.itemHeight * 1.5

                Text {
                    id: video_rec_text
                    text: qsTr("Video Rec")
                    font.bold: true
                    color: "white";
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.top: parent.top;
                    anchors.topMargin: 3
                    font.family:    ScreenTools.normalFontFamily
                    font.pointSize:     ScreenTools.defaultFontPointSize * 1

                }
                Rectangle {
                    // Layout.alignment:   Qt.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: video_rec_text.bottom
                    anchors.topMargin: 7
                    color:              Qt.rgba(0,0,0,0)
                    // height:             parent.height * 0.75
                    // width: height
                    width: parent.width * 0.7
                    height: width
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
                height: valueBarPrimary.itemHeight * 1.5

                Text {
                    id: photo_cap_text
                    text: qsTr("Photo Cap")
                    font.bold: true

                    color: "white";
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.top: parent.top;
                    anchors.topMargin: 3
                    font.family:    ScreenTools.normalFontFamily
                    font.pointSize:     ScreenTools.defaultFontPointSize * 1
                }

                Rectangle {
                    // Layout.alignment:   Qt.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color:              Qt.rgba(0,0,0,0)
                    anchors.top: photo_cap_text.bottom
                    anchors.topMargin: 7
                    // height:             parent.height * 0.75
                    // width: height
                    width: parent.width * 0.7
                    height: width
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


            Item{
                width: parent.width
                height: valueBarPrimary.itemHeight
                //Messsage indicator
                Loader {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height

                    // anchors.top:        parent.top
                    // anchors.bottom:     parent.bottom
                    // anchors.margins: _toolIndicatorMargins

                    source:             "qrc:/toolbar/MessageIndicator.qml"
                    visible:            item.showIndicator
                }
            }

        }

        // Item{
        //     anchors.fill: parent
        //     // color: "#80000000"

        // }
    }


}
