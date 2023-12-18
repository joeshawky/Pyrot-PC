import QtQuick 2.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0

import QGroundControl.Controls      1.0
import QtQuick.Controls 1.2

Row {
    id:                 indicatorRow
    anchors.top:        parent.top
    anchors.bottom:     parent.bottom
    anchors.margins:    _toolIndicatorMargins
    anchors.bottomMargin: 0
    anchors.topMargin: 0
    spacing: ScreenTools.defaultFontPixelWidth

    FactPanelController { id: controller; }

    property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
    property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.66

    property Fact lightsOne: controller.vehicle.getFact("apmSubInfo.lights1")
    property Fact lightsTwo: controller.vehicle.getFact("apmSubInfo.lights2")
    property Fact heading_hold_toggle: controller.getParameterFact(-1, "HEADING_HOLD_TOG")
    property bool heading_hold_toggle_exists: controller.parameterExists(-1, "HEADING_HOLD_TOG")

    property Fact flightTime: controller.vehicle.getFact("FlightTime")
    property Fact temperatureTwo: controller.vehicle.getFact("temperature.temperature2")

    property Fact cameraTilt: controller.vehicle.getFact("apmSubInfo.cameraTilt")

    property Fact pilotGain: controller.vehicle.getFact("apmSubInfo.pilotGain")
    property Fact tetherTurns: controller.vehicle.getFact("apmSubInfo.tetherTurns")
    property Fact inputHold: controller.vehicle.getFact("apmSubInfo.inputHold")

    property Fact recordToggle: controller.getParameterFact(-1, "RECORDING_TOGGLE")
    property bool recordToggleExists: controller.parameterExists(-1, "RECORDING_TOGGLE")

    property Fact rangeFinderDistance: controller.vehicle.getFact("apmSubInfo.rangefinderDistance")

    function temperatureValue(){
        return (temperatureTwo.value) ? temperatureTwo.value : "0"
    }

    function getHdgToggleValue(){
        return (lenta_item_parent.heading_hold_toggle.value === 1) ? "ACTIVE" : "NOT ACTIVE";
    }

    function getHdgToggleColor(){
        if(!indicatorRow.heading_hold_toggle_exists){
            return "#FF0000";
        }

        if (indicatorRow.heading_hold_toggle.value === 1){
            _activeVehicle.sayHdgHoldState(true);
            return "#00ff55";
        }

        _activeVehicle.sayHdgHoldState(false);
        return "#FF0000";
    }

    function getLightsColor(lightsVal){
        return (lightsVal > 0) ? qgcPal.colorGreen : "red"
    }

    function altHldValue(){

    }
    function distHldValue(){

    }

    function getInputHoldColor(val){
        return (val === 1) ? "#00ff55" : "#FF0000";
    }

    Timer{
        repeat: true
        running: true
        interval: 500
        onTriggered: {
            if(!indicatorRow.recordToggleExists){
                return;
            }
            if(indicatorRow.recordToggle.value === 0){
                return;
            }
            if(QGroundControl.videoManager.recording){
                QGroundControl.videoManager.stopRecording();
                indicatorRow.recordToggle.value = 0;
                indicatorRow.recordToggle.valueChanged(indicatorRow.recordToggle.value);
            }else{
                QGroundControl.videoManager.startRecording();
                indicatorRow.recordToggle.value = 0;
                indicatorRow.recordToggle.valueChanged(indicatorRow.recordToggle.value);
            }


        }

    }

    //Messsage indicator
    Loader {
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        anchors.margins: _toolIndicatorMargins

        source:             "qrc:/toolbar/MessageIndicator.qml"
        visible:            item.showIndicator
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //Mode & Arm indicator
    Item{
        width: 75
        height: parent.height
        Loader {
            anchors.top: parent.top
            anchors.topMargin: 1
            width: 75
            height: 25
            source:             "qrc:/toolbar/ModeIndicator.qml"
            visible:            item.showIndicator
        }

        Loader {
           anchors.bottom: parent.bottom
           anchors.bottomMargin: 1
           width: 75
           height: 25
           source:             "qrc:/toolbar/ArmedIndicator.qml"
           visible:            item.showIndicator
        }

    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //Battery stat
    Item{
        width: 65
        height: parent.height
       Text{
           id: battLabel
           font.pixelSize: 12;
           color: "white";
           text: "BATT STAT";
           anchors.horizontalCenter: parent.horizontalCenter;
           anchors.top: parent.top;
           anchors.topMargin: 3
           font.family:    ScreenTools.normalFontFamily
       }

       Text{
           id: battValText
           font.pixelSize: 12;
           color: "white";
           text: `${_activeVehicle.batteries.get(0).voltage.value.toFixed(2)}v`;
           anchors.bottom: parent.bottom
           anchors.bottomMargin: 20
           anchors.left: parent.left
           font.family:    ScreenTools.normalFontFamily
       }

        Loader {
            anchors.bottom:     parent.bottom
            anchors.top: battLabel.top
            anchors.margins: _toolIndicatorMargins
            anchors.topMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.leftMargin: 10
            source:             "qrc:/toolbar/BatteryIndicator.qml"
            visible:            item.showIndicator
        }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //L1 & L2
    Item{
        width: 55
        height: parent.height

        Item{
            width: parent.width
            height: parent.height / 2
            anchors.top: parent.top

            Text{
                font.pixelSize: 12;
                color: "white";
                text: `${indicatorRow.lightsOne.value}%`;
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.family:    ScreenTools.normalFontFamily
            }

            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                height: parent.height * 0.75
                fillMode: Image.PreserveAspectFit
                source:             "/qmlimages/headlightsicon.svg"
                visible:            true
                 Rectangle{
                     anchors.fill: parent
                     opacity: 0.5
                     color: indicatorRow.getLightsColor(indicatorRow.lightsOne.value)
                     radius: 30
                 }
            }
        }

        Item{
            width: parent.width
            height: parent.height / 2
            anchors.bottom: parent.bottom
            Text{
                font.pixelSize: 12;
                color: "white";
                text: `${indicatorRow.lightsTwo.value}%`;
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                font.family:    ScreenTools.normalFontFamily
            }

            Image{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                height: parent.height * 0.75
                fillMode: Image.PreserveAspectFit
                source:             "/qmlimages/headlightsicon.svg"
                visible:            true
                 Rectangle{
                     anchors.fill: parent
                     opacity: 0.40
                     color: indicatorRow.getLightsColor(indicatorRow.lightsTwo.value)
                     radius: 30
                 }
            }
        }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //Cam angle
    Item{
        width: 55
        height: parent.height

        Text{
            font.pixelSize: 12;
            color: "white";
            text: "CAM ANGLE";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 3
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            id: depthDisplayText
            font.pixelSize: 20;
            color: "white";
            text: `${indicatorRow.cameraTilt.value}°`;
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:    ScreenTools.normalFontFamily
        }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //depth
    Item{
        width: 55
        height: parent.height

        Text{
            font.pixelSize: 12;
            color: "white";
            text: "Depth";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 3
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            font.pixelSize: 20;
            color: "white";
            text: `${_activeVehicle.altitudeRelative.rawValue.toFixed(1)} M`;
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:    ScreenTools.normalFontFamily

        }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //Echosounder
    Item{
        width: 55
        height: parent.height

        Text{
            font.pixelSize: 12;
            color: "white";
            text: "Echosounder";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 3
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            font.pixelSize: 20;
            color: "white";
            text: `${indicatorRow.rangeFinderDistance.value.toFixed(1)} M`;
//            text: `xxxx M`
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:    ScreenTools.normalFontFamily

        }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //pilot gain
    Item{
        width: 55
        height: parent.height

        Text{
            font.pixelSize: 12;
            color: "white";
            text: "Gain";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 3
            font.family:    ScreenTools.normalFontFamily
        }
        
        Text{
            font.pixelSize: 20;
            color: "white";
            text: `${indicatorRow.pilotGain.value}%`;
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:    ScreenTools.normalFontFamily
        }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //temperature
    Item{
        width: 65
        height: parent.height
       Text{
           font.pixelSize: 12;
           color: "white";
           text: "TEMP";
           anchors.horizontalCenter: parent.horizontalCenter;
           anchors.top: parent.top;
           anchors.topMargin: 3
           font.family:    ScreenTools.normalFontFamily
       }

       Text{
           id: tempValText
           font.pixelSize: 12;
           color: "white";
           text: `${indicatorRow.temperatureValue()}C`;
           anchors.verticalCenter: parent.verticalCenter
           anchors.left: parent.left
           font.family:    ScreenTools.normalFontFamily
       }

       Image{
           anchors.top:        parent.top
           anchors.bottom:     parent.bottom
           anchors.margins: _toolIndicatorMargins
           anchors.topMargin: _toolIndicatorMargins + 5
           anchors.verticalCenter: parent.verticalCenter
           anchors.right: parent.right
           anchors.rightMargin: 5
           anchors.leftMargin: 10
           source:             "/qmlimages/thermometer_light.svg"
           visible:            item.showIndicator
       }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //roll
    Item{
        width: 55
        height: parent.height

        Text{
            font.pixelSize: 12;
            color: "white";
            text: "Roll";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 3
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            id: rollDisplayText
            font.pixelSize: 20;
            color: "white";
            text: `${_activeVehicle.roll.rawValue.toFixed(1)}`;
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            anchors.left: rollDisplayText.right
            font.pixelSize: 20;
            color: "white";
            text: "°"
            anchors.verticalCenter: parent.verticalCenter
            font.family:    ScreenTools.normalFontFamily
        }
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //dive time
    Item{
        width: 70
        height: parent.height

        Text{
            font.pixelSize: 12;
            color: "white";
            text: "Dive time";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 3
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            font.pixelSize: 20;
            color: "white";
            text: `${indicatorRow.flightTime.enumOrValueString}`;
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:    ScreenTools.normalFontFamily

        }

    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    //Tethern turns
    Item{
        width: 55
        height: parent.height

        Text{
            font.pixelSize: 12;
            color: "white";
            text: "Turns";
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 3
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            font.pixelSize: 20;
            color: "white";
            text: `${indicatorRow.tetherTurns.value}`;
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            font.family:    ScreenTools.normalFontFamily
        }
    }
}

