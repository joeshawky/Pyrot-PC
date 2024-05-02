import QtQuick 2.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0

import QGroundControl.Controls      1.0
import QtQuick.Controls 1.2


Row {
    id:                 indicatorRow
    anchors{
        fill: parent
        margins: _toolIndicatorMargins
        bottomMargin: 0
        topMargin: 0
    }
    // spacing: ScreenTools.defaultFontPixelWidth

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

    property bool recordToggleExists: controller.parameterExists(-1, "RECORDING_TOGGLE")
    property Fact recordToggle: recordToggleExists ? controller.getParameterFact(-1, "RECORDING_TOGGLE") : null

    property bool captureImageExists: controller.parameterExists(-1, "CAPTURE_IMAGE")
    property Fact captureImage: captureImageExists ? controller.getParameterFact(-1, "CAPTURE_IMAGE") : null

    property Fact rangeFinderDistance: controller.vehicle.getFact("apmSubInfo.rangefinderDistance")

    property real itemWidth: ScreenTools.defaultFontPointSize * 8

    property real textSizeMultiplier: 1

    function temperatureValue(){
        return (temperatureTwo.value) ? temperatureTwo.value.toFixed(1) : "0"
    }

    function getLightsColor(lightsVal){
        return (lightsVal > 0) ? qgcPal.colorGreen : "red"
    }

    function normalize(minimumNum, maximumNum, input){
        return (input-minimumNum)/(maximumNum-minimumNum) * 100
    }

    Timer{
        repeat: true
        running: indicatorRow.recordToggleExists ? true : false
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

    Timer{
        repeat: true
        running: indicatorRow.captureImageExists ? true : false
        interval: 500
        onTriggered: {
            if(!indicatorRow.captureImageExists){
                return;
            }
            if(indicatorRow.captureImage.value === 0){
                return;
            }

            QGroundControl.videoManager.grabImage();
            indicatorRow.captureImage.value = 0;
            indicatorRow.captureImage.valueChanged(indicatorRow.captureImage.value);
        }
    }


    // //Messsage indicator
    // Loader {
    //     anchors.top:        parent.top
    //     anchors.bottom:     parent.bottom
    //     anchors.margins: _toolIndicatorMargins

    //     source:             "qrc:/toolbar/MessageIndicator.qml"
    //     visible:            item.showIndicator
    // }


    //Mode & Arm indicator
    Item{
        width: parent.itemWidth * 1.65
        height: parent.height
        Loader {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            source:             "qrc:/toolbar/ModeIndicator.qml"
            visible:            item.showIndicator
        }

        // Loader {
        //    anchors.bottom: parent.bottom
        //    anchors.bottomMargin: 1
        //    width: parent.width
        //    // height: 25
        //    height: parent.height * 0.45
        //    source:             "qrc:/toolbar/ArmedIndicator.qml"
        //    visible:            item.showIndicator
        // }

    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.5
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.5
        height: parent.height
    }

    Item{
        width: parent.itemWidth * 1.65
        height: parent.height
        Loader {
            anchors.centerIn: parent
           width: parent.width
           // height: 25
           // height: parent.height * 0.45
           height: parent.height
           source:             "qrc:/toolbar/ArmedIndicator.qml"
           visible:            item.showIndicator
        }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.5
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    //Battery stat
    Item{
        width: parent.itemWidth * 1.25
        height: parent.height

       Text{
           id: battValText
           anchors {
               left: parent.left
               verticalCenter: parent.verticalCenter
           }

           font.pointSize:     ScreenTools.defaultFontPointSize
           font.family:    ScreenTools.normalFontFamily
           color: "white";
           text: `${_activeVehicle.batteries.get(0).voltage.value.toFixed(2)}v`;
       }

        Loader {
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            height: parent.height * 0.7
            source:             "qrc:/toolbar/BatteryIndicator.qml"
            visible:            item.showIndicator
        }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    //Battery stat
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //    Text{
    //        id: battValText
    //        anchors {
    //            bottom: parent.bottom
    //            bottomMargin: 12
    //            horizontalCenter: parent.horizontalCenter
    //        }

    //        // font.pixelSize: ScreenTools.smallFontPointSize;
    //        font.pointSize:     ScreenTools.defaultFontPointSize
    //        font.family:    ScreenTools.normalFontFamily
    //        color: "white";
    //        text: `${_activeVehicle.batteries.get(0).voltage.value.toFixed(2)}v`;
    //    }

    //     Loader {
    //         // anchors {
    //         //     bottom:     parent.bottom
    //         //     top: parent.top
    //         //     horizontalCenter: parent.horizontalCenter
    //         //     margins: _toolIndicatorMargins
    //         //     topMargin: 5
    //         //     // bottomMargin: 40
    //         // }

    //         height: parent.height * 0.4
    //         anchors{
    //             // bottom: parent.verticalCenter
    //             top: parent.top
    //             horizontalCenter: parent.horizontalCenter
    //             margins: _toolIndicatorMargins * 0.5
    //         }

    //         source:             "qrc:/toolbar/BatteryIndicator.qml"
    //         visible:            item.showIndicator
    //     }
    // }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    //L1
    Item{
        width: parent.itemWidth * 1.5
        height: parent.height
        Item{
            width: parent.width
            height: parent.height * 0.85
            anchors.centerIn: parent

            Text{
                id: lOneValue
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                color: "white";
                // text: `${Number(indicatorRow.lightsOne.value)-}% L1`;
                text: `${Math.round(indicatorRow.normalize(-137, 138, Number(indicatorRow.lightsOne.value)))}% L1`
                font.family:    ScreenTools.normalFontFamily
                font.pointSize:     ScreenTools.defaultFontPointSize
            }

            Image{
                anchors{
                    verticalCenter: parent.verticalCenter
                    // left: lOneValue.right
                    right: parent.right
                    rightMargin: ScreenTools.defaultFontPointSize
                }
                height: parent.height * 0.75
                fillMode: Image.PreserveAspectFit
                source:             "/qmlimages/headlightsicon.svg"
                visible:            true
                 Rectangle{
                    anchors.fill: parent
                    opacity: 0.5
                    color: indicatorRow.getLightsColor(indicatorRow.lightsOne.value)
                    radius: width * 0.5
                }
            }
        }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.5
        height: parent.height
    }

    //L2
    Item{
        width: parent.itemWidth * 1.5
        height: parent.height

        Item{
            width: parent.width
            height: parent.height * 0.85
            anchors.centerIn: parent

            Text{
                id: lTwoValue
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: ScreenTools.defaultFontPixelWidth * 0.25
                }
                color: "white";
                // text: `${indicatorRow.lightsTwo.value}% L2`;
                text: `${Math.round(indicatorRow.normalize(-137, 138, Number(indicatorRow.lightsTwo.value)))}% L2`
                font.family:    ScreenTools.normalFontFamily
                font.pointSize:     ScreenTools.defaultFontPointSize
            }

            Image{
                anchors{
                    verticalCenter: parent.verticalCenter
                    // left: lTwoValue.right
                    // leftMargin: ScreenTools.defaultFontPixelWidth * 0.25
                    right: parent.right
                    rightMargin: ScreenTools.defaultFontPointSize
                }
                height: parent.height * 0.75
                fillMode: Image.PreserveAspectFit
                source:             "/qmlimages/headlightsicon.svg"
                visible:            true
                 Rectangle{
                     anchors.fill: parent
                     opacity: 0.5
                     color: indicatorRow.getLightsColor(indicatorRow.lightsTwo.value)
                     radius: width * 0.5
                 }
            }
        }
    }

    //L1 & L2
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height
    //     Item{
    //         width: parent.width
    //         height: parent.height / 2
    //         anchors.top: parent.top

    //         Text{
    //             color: "white";
    //             text: `${indicatorRow.lightsOne.value}%`;
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.left: parent.left
    //             font.family:    ScreenTools.normalFontFamily
    //             font.pointSize:     ScreenTools.defaultFontPointSize
    //         }

    //         Image{
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.right: parent.right
    //             height: parent.height * 0.75
    //             fillMode: Image.PreserveAspectFit
    //             source:             "/qmlimages/headlightsicon.svg"
    //             visible:            true
    //              Rectangle{
    //                 anchors.fill: parent
    //                 opacity: 0.5
    //                 color: indicatorRow.getLightsColor(indicatorRow.lightsOne.value)
    //                 radius: width * 0.5
    //             }
    //         }
    //     }

    //     Item{
    //         width: parent.width
    //         height: parent.height / 2
    //         anchors.bottom: parent.bottom
    //         Text{
    //             color: "white";
    //             text: `${indicatorRow.lightsTwo.value}%`;
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.left: parent.left
    //             font.family:    ScreenTools.normalFontFamily
    //             font.pointSize:     ScreenTools.defaultFontPointSize
    //         }

    //         Image{
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.right: parent.right
    //             height: parent.height * 0.75
    //             fillMode: Image.PreserveAspectFit
    //             source:             "/qmlimages/headlightsicon.svg"
    //             visible:            true
    //              Rectangle{
    //                  anchors.fill: parent
    //                  opacity: 0.40
    //                  color: indicatorRow.getLightsColor(indicatorRow.lightsTwo.value)
    //                  radius: 30
    //              }
    //         }
    //     }
    // }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    //Cam angle
    Item{
        width: parent.itemWidth
        height: parent.height

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: parent.top;
                topMargin: parent.height * 0.01
            }

            color: "white";
            text: "Cam Angle";
            font.family:    ScreenTools.normalFontFamily
            font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
        }

        Text{
            id: depthDisplayText
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            color: "white";
            text: `${indicatorRow.cameraTilt.value}°`;
            font.family:    ScreenTools.normalFontFamily
            font.pointSize:     ScreenTools.defaultFontPointSize
        }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    //depth
    Item{
        width: parent.itemWidth
        height: parent.height

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: parent.top;
                topMargin: parent.height * 0.01
            }
            font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
            color: "white";
            text: "Depth";
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            font.pointSize:     ScreenTools.defaultFontPointSize
            color: "white";
            text: `${_activeVehicle.altitudeRelative.rawValue.toFixed(1)} M`;
            font.family:    ScreenTools.normalFontFamily

        }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    //Echosounder
    Item{
        width: parent.itemWidth * 1.25
        height: parent.height

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: parent.top;
                topMargin: parent.height * 0.01
            }
            font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
            color: "white";
            text: "Echosounder";
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            font.pointSize:     ScreenTools.defaultFontPointSize
            color: "white";
            text: `${indicatorRow.rangeFinderDistance.value.toFixed(1)} M`;
            font.family:    ScreenTools.normalFontFamily
        }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    //pilot gain
    Item{
        width: parent.itemWidth * 0.7
        height: parent.height

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: parent.top;
                topMargin: parent.height * 0.01
            }
            font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
            color: "white";
            text: "Gain";
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            font.pointSize:     ScreenTools.defaultFontPointSize
            color: "white";
            text: `${indicatorRow.pilotGain.value} %`;
            font.family:    ScreenTools.normalFontFamily
        }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth * 0.25
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    //temperature
    Item{
        width: parent.itemWidth * 1.25
        height: parent.height


        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: parent.top;
                topMargin: parent.height * 0.01
            }
            font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
            color: "white";
            text: "Temperature";
            font.family:    ScreenTools.normalFontFamily
        }

       Text{
           anchors{
               horizontalCenter: parent.horizontalCenter
               bottom: parent.bottom
           }
           id: tempValText
           font.pointSize:     ScreenTools.defaultFontPointSize
           color: "white";
           text: `${indicatorRow.temperatureValue()}c`;
           font.family:    ScreenTools.normalFontFamily
       }

       // Image{
       //      anchors{
       //          horizontalCenter: parent.horizontalCenter
       //          top: parent.top
       //          topMargin: _toolIndicatorMargins * 0.25
       //      }
       //      height: parent.height * 0.35
       //      source:             "/qmlimages/thermometer_light.svg"
       //      fillMode: Image.PreserveAspectFit
       // }
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    //roll
    // Item{
    //     width: parent.itemWidth * 0.7
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
    //         color: "white";
    //         text: "Roll";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    //     Text{
    //         id: rollDisplayText
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //         color: "white";
    //         text: `${_activeVehicle.roll.rawValue.toFixed(1)}°`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    //dive time
    Item{
        width: parent.itemWidth * 1.25
        height: parent.height

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: parent.top;
                topMargin: parent.height * 0.01
            }
            font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
            color: "white";
            text: "Dive time";
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            font.pointSize:     ScreenTools.defaultFontPointSize
            color: "white";
            text: `${indicatorRow.flightTime.enumOrValueString}`;
            font.family:    ScreenTools.normalFontFamily

        }

    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    Rectangle{
        width: 1
        height: parent.height
        color: "white"
    }

    Item{
        width: ScreenTools.defaultFontPixelWidth
        height: parent.height
    }

    //Tethern turns
    Item{
        width: parent.itemWidth * 0.75
        height: parent.height

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter;
                top: parent.top;
                topMargin: parent.height * 0.01
            }
            font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
            color: "white";
            text: "Turns";
            font.family:    ScreenTools.normalFontFamily
        }

        Text{
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            font.pointSize:     ScreenTools.defaultFontPointSize
            color: "white";
            text: `${indicatorRow.tetherTurns.value}`;
            font.family:    ScreenTools.normalFontFamily
        }
    }


    // //Messsage indicator
    // Loader {
    //     anchors.top:        parent.top
    //     anchors.bottom:     parent.bottom
    //     anchors.margins: _toolIndicatorMargins
    //     anchors.leftMargin: 0

    //     source:             "qrc:/toolbar/MessageIndicator.qml"
    //     visible:            item.showIndicator
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //Mode & Arm indicator
    // Item{
    //     width: parent.itemWidth * 1.5
    //     height: parent.height
    //     Loader {
    //         anchors.top: parent.top
    //         anchors.topMargin: 1
    //         width: parent.width
    //         // height: 25
    //         height: parent.height * 0.45
    //         source:             "qrc:/toolbar/ModeIndicator.qml"
    //         visible:            item.showIndicator
    //     }

    //     Loader {
    //        anchors.bottom: parent.bottom
    //        anchors.bottomMargin: 1
    //        width: parent.width
    //        // height: 25
    //        height: parent.height * 0.45
    //        source:             "qrc:/toolbar/ArmedIndicator.qml"
    //        visible:            item.showIndicator
    //     }

    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //Battery stat
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //    Text{
    //        id: battValText
    //        anchors {
    //            bottom: parent.bottom
    //            bottomMargin: 20
    //            horizontalCenter: parent.horizontalCenter
    //        }

    //        // font.pixelSize: ScreenTools.smallFontPointSize;
    //        font.pointSize:     ScreenTools.defaultFontPointSize
    //        font.family:    ScreenTools.normalFontFamily
    //        color: "white";
    //        text: `${_activeVehicle.batteries.get(0).voltage.value.toFixed(2)}v`;
    //    }

    //     Loader {
    //         anchors {
    //             bottom:     parent.verticalCenter
    //             top: parent.top
    //             horizontalCenter: parent.horizontalCenter
    //             margins: _toolIndicatorMargins
    //             topMargin: 5
    //             // bottomMargin: 40
    //         }
    //         source:             "qrc:/toolbar/BatteryIndicator.qml"
    //         visible:            item.showIndicator
    //     }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //L1 & L2
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height
    //     Item{
    //         width: parent.width
    //         height: parent.height / 2
    //         anchors.top: parent.top

    //         Text{
    //             color: "white";
    //             text: `${indicatorRow.lightsOne.value}%`;
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.left: parent.left
    //             font.family:    ScreenTools.normalFontFamily
    //             font.pointSize:     ScreenTools.defaultFontPointSize
    //         }

    //         Image{
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.right: parent.right
    //             height: parent.height * 0.75
    //             fillMode: Image.PreserveAspectFit
    //             source:             "/qmlimages/headlightsicon.svg"
    //             visible:            true
    //              Rectangle{
    //                 anchors.fill: parent
    //                 opacity: 0.5
    //                 color: indicatorRow.getLightsColor(indicatorRow.lightsOne.value)
    //                 radius: width * 0.5
    //             }
    //         }
    //     }

    //     Item{
    //         width: parent.width
    //         height: parent.height / 2
    //         anchors.bottom: parent.bottom
    //         Text{
    //             color: "white";
    //             text: `${indicatorRow.lightsTwo.value}%`;
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.left: parent.left
    //             font.family:    ScreenTools.normalFontFamily
    //             font.pointSize:     ScreenTools.defaultFontPointSize
    //         }

    //         Image{
    //             anchors.verticalCenter: parent.verticalCenter
    //             anchors.right: parent.right
    //             height: parent.height * 0.75
    //             fillMode: Image.PreserveAspectFit
    //             source:             "/qmlimages/headlightsicon.svg"
    //             visible:            true
    //             Rectangle{
    //                 anchors.fill: parent
    //                 opacity: 0.5
    //                 color: indicatorRow.getLightsColor(indicatorRow.lightsTwo.value)
    //                 radius: width * 0.5
    //             }
    //         }
    //     }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //Cam angle
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //     Text{
    //         color: "white";
    //         text: "Cam Angle";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //     }

    //     Text{
    //         id: depthDisplayText
    //         color: "white";
    //         text: `${indicatorRow.cameraTilt.value}°`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //     }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //Depth
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //         color: "white";
    //         text: "Depth";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily

    //     }

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //         color: "white";
    //         text: `${_activeVehicle.altitudeRelative.rawValue.toFixed(1)} M`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily

    //     }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //Echosounder
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //         color: "white";
    //         text: "Echosounder";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //         color: "white";
    //         text: `${indicatorRow.rangeFinderDistance.value.toFixed(1)} M`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily

    //     }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //pilot gain
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //         color: "white";
    //         text: "Gain";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //         color: "white";
    //         text: `${indicatorRow.pilotGain.value}%`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily
    //     }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //temperature
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //         color: "white";
    //         text: "Temperature";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    //    Text{
    //        id: tempValText
    //        font.pointSize:     ScreenTools.defaultFontPointSize
    //        color: "white";
    //        text: `${indicatorRow.temperatureValue()}C`;
    //        anchors.bottom: parent.bottom
    //        anchors.bottomMargin: 12
    //        anchors.horizontalCenter: parent.horizontalCenter

    //        font.family:    ScreenTools.normalFontFamily
    //    }

    //    // Image{
    //    //      anchors{
    //    //          horizontalCenter: parent.horizontalCenter
    //    //          top: parent.top
    //    //          topMargin: _toolIndicatorMargins * 0.25
    //    //      }
    //    //      height: parent.height * 0.35
    //    //      source:             "/qmlimages/thermometer_light.svg"
    //    //      fillMode: Image.PreserveAspectFit
    //    // }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //roll
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //         color: "white";
    //         text: "Roll";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    //     Text{
    //         id: rollDisplayText
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //         color: "white";
    //         text: `${_activeVehicle.roll.rawValue.toFixed(1)}°`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily
    //     }
    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //dive time
    // Item{
    //     width: parent.itemWidth * 1.5
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //         color: "white";
    //         text: "Dive time";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //         color: "white";
    //         text: `${indicatorRow.flightTime.enumOrValueString}`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily

    //     }

    // }

    // Rectangle{
    //     width: 1
    //     height: parent.height
    //     color: "white"
    // }

    // //Tethern turns
    // Item{
    //     width: parent.itemWidth
    //     height: parent.height

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize * 0.5
    //         font.bold: true
    //         color: "white";
    //         text: "Turns";
    //         anchors.horizontalCenter: parent.horizontalCenter;
    //         anchors.top: parent.top;
    //         anchors.topMargin: 3
    //         font.family:    ScreenTools.normalFontFamily
    //     }

    //     Text{
    //         font.pointSize:     ScreenTools.defaultFontPointSize
    //         color: "white";
    //         text: `${indicatorRow.tetherTurns.value}`;
    //         anchors.bottom: parent.bottom
    //         anchors.bottomMargin: 12
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         font.family:    ScreenTools.normalFontFamily
    //     }
    // }

}



// Row {
//     id:                 indicatorRow
//     anchors.top:        parent.top
//     anchors.bottom:     parent.bottom
//     anchors.left: parent.left
//     anchors.right: parent.right
//     anchors.margins:    _toolIndicatorMargins
//     anchors.bottomMargin: 0
//     anchors.topMargin: 0
//     spacing: ScreenTools.defaultFontPixelWidth
//     FactPanelController { id: controller; }

//     property var  _activeVehicle:           QGroundControl.multiVehicleManager.activeVehicle
//     property real _toolIndicatorMargins:    ScreenTools.defaultFontPixelHeight * 0.66

//     property Fact lightsOne: controller.vehicle.getFact("apmSubInfo.lights1")
//     property Fact lightsTwo: controller.vehicle.getFact("apmSubInfo.lights2")

//     property Fact flightTime: controller.vehicle.getFact("FlightTime")
//     property Fact temperatureTwo: controller.vehicle.getFact("temperature.temperature2")

//     property Fact cameraTilt: controller.vehicle.getFact("apmSubInfo.cameraTilt")

//     property Fact pilotGain: controller.vehicle.getFact("apmSubInfo.pilotGain")
//     property Fact tetherTurns: controller.vehicle.getFact("apmSubInfo.tetherTurns")
//     property Fact inputHold: controller.vehicle.getFact("apmSubInfo.inputHold")

//     property Fact recordToggle: controller.getParameterFact(-1, "RECORDING_TOGGLE")
//     property bool recordToggleExists: controller.parameterExists(-1, "RECORDING_TOGGLE")

//     property Fact captureImage: controller.getParameterFact(-1, "CAPTURE_IMAGE")
//     property bool captureImageExists: controller.parameterExists(-1, "CAPTURE_IMAGE")

//     property Fact rangeFinderDistance: controller.vehicle.getFact("apmSubInfo.rangefinderDistance")

//     // property real itemWidth: width * 0.1
//     // property real itemWidth: 65

//     property real itemWidth:  ScreenTools.defaultFontPointSize * 10

//     property real textSizeMultiplier: 1

//     function temperatureValue(){
//         return (temperatureTwo.value) ? temperatureTwo.value.toFixed(1) : "0"
//     }

//     function getLightsColor(lightsVal){
//         return (lightsVal > 0) ? qgcPal.colorGreen : "red"
//     }



//     Timer{
//         repeat: true
//         running: true
//         interval: 500
//         onTriggered: {
//             if(!indicatorRow.recordToggleExists){
//                 return;
//             }
//             if(indicatorRow.recordToggle.value === 0){
//                 return;
//             }
//             if(QGroundControl.videoManager.recording){
//                 QGroundControl.videoManager.stopRecording();
//                 indicatorRow.recordToggle.value = 0;
//                 indicatorRow.recordToggle.valueChanged(indicatorRow.recordToggle.value);
//             }else{
//                 QGroundControl.videoManager.startRecording();
//                 indicatorRow.recordToggle.value = 0;
//                 indicatorRow.recordToggle.valueChanged(indicatorRow.recordToggle.value);
//             }


//         }

//     }

//     Timer{
//         repeat: true
//         running: true
//         interval: 500
//         onTriggered: {
//             if(!indicatorRow.captureImageExists){
//                 return;
//             }
//             if(indicatorRow.captureImage.value === 0){
//                 return;
//             }

//             QGroundControl.videoManager.grabImage();
//             indicatorRow.captureImage.value = 0;
//             indicatorRow.captureImage.valueChanged(indicatorRow.captureImage.value);
//         }

//     }

//     //Messsage indicator
//     Loader {
//         anchors.top:        parent.top
//         anchors.bottom:     parent.bottom
//         anchors.margins: _toolIndicatorMargins

//         source:             "qrc:/toolbar/MessageIndicator.qml"
//         visible:            item.showIndicator
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //Mode & Arm indicator
//     Item{
//         width: parent.itemWidth * 1.5
//         height: parent.height
//         Loader {
//             anchors.top: parent.top
//             anchors.topMargin: 1
//             width: parent.width
//             // height: 25
//             height: parent.height * 0.45
//             source:             "qrc:/toolbar/ModeIndicator.qml"
//             visible:            item.showIndicator
//         }

//         Loader {
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 1
//            width: parent.width
//            // height: 25
//            height: parent.height * 0.45
//            source:             "qrc:/toolbar/ArmedIndicator.qml"
//            visible:            item.showIndicator
//         }

//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //Battery stat
//     Item{
//         width: parent.itemWidth
//         height: parent.height

//        Text{
//            id: battValText
//            anchors {
//                bottom: parent.bottom
//                bottomMargin: 12
//                horizontalCenter: parent.horizontalCenter
//            }

//            // font.pixelSize: ScreenTools.smallFontPointSize;
//            font.pointSize:     ScreenTools.defaultFontPointSize
//            font.family:    ScreenTools.normalFontFamily
//            color: "white";
//            text: `${_activeVehicle.batteries.get(0).voltage.value.toFixed(2)}v`;
//        }

//         Loader {
//             // anchors {
//             //     bottom:     parent.bottom
//             //     top: parent.top
//             //     horizontalCenter: parent.horizontalCenter
//             //     margins: _toolIndicatorMargins
//             //     topMargin: 5
//             //     // bottomMargin: 40
//             // }

//             height: parent.height * 0.4
//             anchors{
//                 // bottom: parent.verticalCenter
//                 top: parent.top
//                 horizontalCenter: parent.horizontalCenter
//                 margins: _toolIndicatorMargins * 0.5
//             }

//             source:             "qrc:/toolbar/BatteryIndicator.qml"
//             visible:            item.showIndicator
//         }
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //L1 & L2
//     Item{
//         width: parent.itemWidth
//         height: parent.height
//         Item{
//             width: parent.width
//             height: parent.height / 2
//             anchors.top: parent.top

//             Text{
//                 color: "white";
//                 text: `${indicatorRow.lightsOne.value}%`;
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.left: parent.left
//                 font.family:    ScreenTools.normalFontFamily
//                 font.pointSize:     ScreenTools.defaultFontPointSize
//             }

//             Image{
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.right: parent.right
//                 height: parent.height * 0.75
//                 fillMode: Image.PreserveAspectFit
//                 source:             "/qmlimages/headlightsicon.svg"
//                 visible:            true
//                  Rectangle{
//                     anchors.fill: parent
//                     opacity: 0.5
//                     color: indicatorRow.getLightsColor(indicatorRow.lightsOne.value)
//                     radius: width * 0.5
//                 }
//             }
//         }

//         Item{
//             width: parent.width
//             height: parent.height / 2
//             anchors.bottom: parent.bottom
//             Text{
//                 color: "white";
//                 text: `${indicatorRow.lightsTwo.value}%`;
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.left: parent.left
//                 font.family:    ScreenTools.normalFontFamily
//                 font.pointSize:     ScreenTools.defaultFontPointSize
//             }

//             Image{
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.right: parent.right
//                 height: parent.height * 0.75
//                 fillMode: Image.PreserveAspectFit
//                 source:             "/qmlimages/headlightsicon.svg"
//                 visible:            true
//                  Rectangle{
//                      anchors.fill: parent
//                      opacity: 0.40
//                      color: indicatorRow.getLightsColor(indicatorRow.lightsTwo.value)
//                      radius: 30
//                  }
//             }
//         }
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //Cam angle
//     Item{
//         width: parent.itemWidth
//         height: parent.height

//         Text{
//             color: "white";
//             text: "Cam Angle";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             font.bold: true
//         }

//         Text{
//             id: depthDisplayText
//             color: "white";
//             text: `${indicatorRow.cameraTilt.value}°`;
//             anchors.bottom: parent.bottom
//             anchors.bottomMargin: 12
//             anchors.horizontalCenter: parent.horizontalCenter
//             font.family:    ScreenTools.normalFontFamily
//             font.pointSize:     ScreenTools.defaultFontPointSize
//         }
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //depth
//     Item{
//         width: parent.itemWidth
//         height: parent.height

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             color: "white";
//             text: "Depth";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//             font.bold: true
//         }

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize
//             color: "white";
//             text: `${_activeVehicle.altitudeRelative.rawValue.toFixed(1)} M`;
//             anchors.bottom: parent.bottom
//             anchors.bottomMargin: 12
//             anchors.horizontalCenter: parent.horizontalCenter
//             font.family:    ScreenTools.normalFontFamily

//         }
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //Echosounder
//     Item{
//         width: parent.itemWidth
//         height: parent.height

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             color: "white";
//             text: "Echosounder";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//             font.bold: true
//         }

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize
//             color: "white";
//             text: `${indicatorRow.rangeFinderDistance.value.toFixed(1)} M`;
// //            text: `${indicatorRow.rangeFinderDistance.value.toFixed(3)} M`;
// //            text: `xxxx M`
//             anchors.bottom: parent.bottom
//             anchors.bottomMargin: 12
//             anchors.horizontalCenter: parent.horizontalCenter
//             font.family:    ScreenTools.normalFontFamily

//         }
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //pilot gain
//     Item{
//         width: parent.itemWidth
//         height: parent.height

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             color: "white";
//             text: "Gain";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//             font.bold: true
//         }

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize
//             color: "white";
//             text: `${indicatorRow.pilotGain.value}%`;
//             anchors.bottom: parent.bottom
//             anchors.bottomMargin: 12
//             anchors.horizontalCenter: parent.horizontalCenter
//             font.family:    ScreenTools.normalFontFamily
//         }
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //temperature
//     Item{
//         width: parent.itemWidth
//         height: parent.height


//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             font.bold: true
//             color: "white";
//             text: "Temperature";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//         }

//        Text{
//            id: tempValText
//            font.pointSize:     ScreenTools.defaultFontPointSize
//            color: "white";
//            text: `${indicatorRow.temperatureValue()}C`;
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 12
//            anchors.horizontalCenter: parent.horizontalCenter

//            font.family:    ScreenTools.normalFontFamily
//        }

//        // Image{
//        //      anchors{
//        //          horizontalCenter: parent.horizontalCenter
//        //          top: parent.top
//        //          topMargin: _toolIndicatorMargins * 0.25
//        //      }
//        //      height: parent.height * 0.35
//        //      source:             "/qmlimages/thermometer_light.svg"
//        //      fillMode: Image.PreserveAspectFit
//        // }
//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //roll
//     Item{
//         width: parent.itemWidth
//         height: parent.height

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             color: "white";
//             text: "Roll";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//             font.bold: true
//         }

//         Text{
//             id: rollDisplayText
//             font.pointSize:     ScreenTools.defaultFontPointSize
//             color: "white";
//             text: `${_activeVehicle.roll.rawValue.toFixed(1)}°`;
//             anchors.bottom: parent.bottom
//             anchors.bottomMargin: 12
//             anchors.horizontalCenter: parent.horizontalCenter
//             font.family:    ScreenTools.normalFontFamily
//         }

//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //dive time
//     Item{
//         width: parent.itemWidth * 1.5
//         height: parent.height

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             color: "white";
//             text: "Dive time";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//             font.bold: true
//         }

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize
//             color: "white";
//             text: `${indicatorRow.flightTime.enumOrValueString}`;
//             anchors.bottom: parent.bottom
//             anchors.bottomMargin: 12
//             anchors.horizontalCenter: parent.horizontalCenter
//             font.family:    ScreenTools.normalFontFamily

//         }

//     }

//     Rectangle{
//         width: 1
//         height: parent.height
//         color: "white"
//     }

//     //Tethern turns
//     Item{
//         width: parent.itemWidth
//         height: parent.height

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize * indicatorRow.textSizeMultiplier
//             color: "white";
//             text: "Turns";
//             anchors.horizontalCenter: parent.horizontalCenter;
//             anchors.top: parent.top;
//             anchors.topMargin: 3
//             font.family:    ScreenTools.normalFontFamily
//             font.bold: true
//         }

//         Text{
//             font.pointSize:     ScreenTools.defaultFontPointSize
//             color: "white";
//             text: `${indicatorRow.tetherTurns.value}`;
//             anchors.bottom: parent.bottom
//             anchors.bottomMargin: 12
//             anchors.horizontalCenter: parent.horizontalCenter
//             font.family:    ScreenTools.normalFontFamily
//         }
//     }

// }



