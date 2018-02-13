import QtQuick 2.9
import QtQuick.Controls 2.2
import QtMultimedia 5.8

import com.contentplayermod.filemodel 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Tabs")
    property int idx: 0
    property bool isActive: true


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        focus: true
        Keys.forwardTo: lv

        Page {

            ListView {
                id: lv
                width: 200; height: 400
                highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                focus: true
                currentIndex: 0

                Component {
                    id: fileDelegate
                    Text {

                        text: fileName
                        font.pointSize: 20

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {

                                playTimer.stop()
                                playMusic(index)
                                swipeView.setCurrentIndex(1)
                            }
                        }
                    }

                }

                model: FileModel{
                    id: myModel
                    folder: "c:\\test2"  //"/mnt/sdcard/app_pictureFrameImage"//
                    nameFilters: ["*.mp4","*.jpg"]
                }

                delegate: fileDelegate
                highlightFollowsCurrentItem: true


                Keys.onPressed: {
                         if (event.key == Qt.Key_Up) {
                             if (lv.currentIndex - 1 >= 0)
                                 lv.currentIndex -= 1;
                             event.accepted = true;
                         }

                         if (event.key == Qt.Key_Down) {
                             if (lv.currentIndex + 1 < lv.count)
                                 lv.currentIndex += 1;
                             event.accepted = true;

                         }

                         if (event.key == 16777220) {//enter
                             playTimer.stop()
                             playMusic(lv.currentIndex)
                             swipeView.setCurrentIndex(1)
                             event.accepted = true;
                         }

                         if (event.key == Qt.Key_Right) { //switch to the below button
                             button1.forceActiveFocus();
                         }
                }
            }

            Row {
                    id: controlButtons

                     height: 40
                     anchors {
                         left: parent.left
                         leftMargin: 10
                         right: parent.right
                         rightMargin: 10
                         bottom: parent.bottom
                         bottomMargin: 0
                     }

                    Button {
                        id: button1
                        width: parent.width/2
                        text: "Play"

                        background: Rectangle {
                            implicitHeight: 40
                            //border.color: "#26282a"
                            border.color: button1.activeFocus ? "yellow" : "#242424"
                            border.width: 2
                            radius: 4
                        }
                        onClicked:{
                            playTimer.start()
                            swipeView.setCurrentIndex(1)
                            playMusic(0)
                        }
                        Keys.onPressed: {
                            if (event.key == Qt.Key_Right) { //switch to the Stop button
                                button2.forceActiveFocus();
                                swipeView.setCurrentIndex(0);
                            }
                            if (event.key == Qt.Key_Left) {
                                lv.forceActiveFocus();
                            }
                            if(event.key == 16777220){ //enter
                                playTimer.start()
                                swipeView.setCurrentIndex(1)
                                playMusic(0)
                                rewindButton.forceActiveFocus();
                            }
                        }
                    }

                    Button {
                        id: button2
                        width: parent.width/2
                        text: "Stop"
                        background: Rectangle {
                            implicitHeight: 40
                            border.color: button2.activeFocus ? "yellow" : "#242424"
                            //border.color: "#26282a"
                            border.width: 2
                            radius: 4
                        }
                        onClicked:{
                            playTimer.stop()
                        }
                        Keys.onPressed: {
                            if (event.key == Qt.Key_Left) {
                                button1.forceActiveFocus();
                            }
                            if (event.key == Qt.Key_Right) {
                                rewindButton.forceActiveFocus();
                                swipeView.setCurrentIndex(1)
                            }

                            if(event.key == 16777220){ //enter
                                 playTimer.stop()
                            }
                        }
                    }
            }
        }

        Page {
            id: page2
            //focus: true
            MediaPlayer {
                id: player
               /* onStopped: {
                    if(status===MediaPlayer.EndOfMedia){                       
                        // playMusic((lv.currentIndex+1) % lv.count)
                    }
                }*/
            }

            VideoOutput {
                id: video
                anchors.fill: parent
                source: player
            }

            Row {
                    id: controlButtons2

                     height: playpauseButton.height
                     anchors {
                         left: parent.left
                         leftMargin: 10
                         right: parent.right
                         rightMargin: 10
                         bottom: parent.bottom
                         bottomMargin: 0
                     }

                     Button {
                         id: rewindButton
                         width: parent.width / 3
                         text: "previous"
                         background: Rectangle {
                             implicitHeight: 40
                             border.color: rewindButton.activeFocus ? "yellow" : "#242424"
                             //border.color: "#26282a"
                             border.width: 2
                             radius: 4
                         }
                         onClicked: {
                             idx = idx - 1;
                             if(idx < 0 ){
                                 idx = lv.count-1;
                             }
                             playMusic(idx)
                             playTimer.stop()
                         }
                         Keys.onPressed: {
                             if (event.key == Qt.Key_Left) {
                                 swipeView.setCurrentIndex(0)
                                 button2.forceActiveFocus();
                             }
                             if (event.key == Qt.Key_Right) {
                                 playpauseButton.forceActiveFocus();
                             }
                             if(event.key == 16777220){ //enter
                                 idx = idx - 1;
                                 if(idx < 0 ){
                                     idx = lv.count-1;
                                 }
                                 playMusic(idx)
                                 playTimer.stop()
                             }
                         }
                     }

                     Button {
                         id: playpauseButton

                         width: parent.width / 3
                         text: isActive ? "stop" : "play"
                         background: Rectangle {
                             implicitHeight: 40
                             border.color: playpauseButton.activeFocus ? "yellow" : "#242424"
                             //border.color: "#26282a"
                             border.width: 2
                             radius: 4
                         }
                         onClicked:{
                             if(isActive){
                                isActive = false;
                                playTimer.stop()
                                player.pause()
                             }else{
                                 isActive = true
                                 playMusic(idx)
                                 playTimer.start()
                                 player.play()
                             }
                         }
                         Keys.onPressed: {
                             if (event.key == Qt.Key_Left) {
                                 rewindButton.forceActiveFocus();
                             }
                             if (event.key == Qt.Key_Right) {
                                 nextButton.forceActiveFocus();
                             }
                             if(event.key == 16777220){ //enter
                                 if(isActive){
                                    isActive = false;
                                    playTimer.stop()
                                    player.pause()
                                 }else{
                                     isActive = true
                                     playMusic(idx)
                                     playTimer.start()
                                     player.play()
                                 }
                             }
                         }
                     }

                     Button {
                         id: nextButton
                         width: parent.width / 3
                         text:"next"
                         background: Rectangle {
                             implicitHeight: 40
                             border.color: nextButton.activeFocus ? "yellow" : "#242424"
                             //border.color: "#26282a"
                             border.width: 2
                             radius: 4
                         }
                         onClicked: {
                             idx = idx + 1;
                             if(idx > lv.count-1){
                                 idx = 0;
                             }
                             playMusic(idx)
                             playTimer.stop()
                         }
                         Keys.onPressed: {
                             if (event.key == Qt.Key_Left) {
                                 playpauseButton.forceActiveFocus();
                             }
                             if (event.key == Qt.Key_Right) {
                                 rewindButton.forceActiveFocus();
                             }
                             if(event.key == 16777220){ //enter
                                 idx = idx + 1;
                                 if(idx > lv.count-1){
                                     idx = 0;
                                 }
                                 playMusic(idx)
                                 playTimer.stop()
                             }
                         }
                     }
                  }
        }
    }

    function playMusic(index){
        idx = index
        //player.stop()
        console.log(myModel.get(index).url)
        player.source = myModel.get(index).url
        player.play()
        //swipeView.setCurrentIndex(1)
    }

    Timer {
        id: playTimer
        interval: 2000
        repeat: true
        running: true
        onTriggered: {
            var source_name = player.source;

            if(source_name.toString().indexOf(".jpg")>0 || source_name.toString().indexOf(".bmp")>0 || source_name.toString().indexOf(".png")>0){ //processing .jpg
                if (idx + 1 < lv.count){
                    playMusic(idx + 1);
                }else{
                    idx = 0;
                    playMusic(idx);
                }
            }

            else if(source_name.toString().indexOf(".mp4")>0){ //processing .mp4
                if (player.status == MediaPlayer.EndOfMedia){
                    if (idx + 1 < lv.count){
                        playMusic(idx + 1);
                    }else{
                        idx = 0;
                        playMusic(idx);
                    }
                }
            }
        }
     }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            id:tab1
            text: qsTr("Main")
        }
        TabButton {
            id:tab2
            text: qsTr("View")
        }
    }
}
