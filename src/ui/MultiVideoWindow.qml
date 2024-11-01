import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.Palette           1.0
import QGroundControl.Vehicle           1.0
import QGroundControl.Controllers       1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0

import org.freedesktop.gstreamer.GLVideoItem 1.0

import "." as QGroundMain;

ApplicationWindow {
    id:             multiVideoWindow
    title:          "Multi-Video Context"
    width:          1280
    height:         720
//    minimumWidth:   width
//    minimumHeight:  height
//    maximumWidth:   width
//    maximumHeight:  height
    visible:        true

    onClosing: function() {
        QGroundControl.videoManager.stopMultiCamRecording();
    }

    Item {
        anchors.fill: parent
        Rectangle {
            id:             noVideo0
            width:          parent.width
            height:         parent.height
            color:          Qt.rgba(0,0,0,0.75)
            visible:        !(QGroundControl.videoManager.decoding0)
            QGCLabel {
                text:               qsTr("Loading video")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.centerIn:   parent
            }
        }
        GstGLVideoItem {
            objectName: "videoContent0"
            width: parent.width
            height: parent.height
            property var receiver
            visible: QGroundControl.videoManager.decoding0
        }
    }
}
