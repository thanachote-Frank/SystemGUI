import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import Process 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Universal 2.0

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 640
    height: 480
    property Process process0: Process {
    }
    property Process process1: Process {
    }
    property Process process2: Process {
    }
    property Process process3: Process {
    }
    property Process process4: Process {
    }
    property string destination

    title: qsTr("Control Operation")

    Timer {
        id: timer1
        interval: 500; running: true; repeat: true
        onTriggered: {
            if(process0.getState() != Process.NotRunning){
                statusCamera.running = true;
            }
            else{
                statusCamera.running = false;
            }

            if(process1.getState() != Process.NotRunning){
                statusCore.running = true;
            }
            else{
                statusCore.running = false;
            }

            if(process2.getState() != Process.NotRunning){
                statusSLAM.running = true;
            }
            else{
                statusSLAM.running = false;
            }

            if(process3.getState() != Process.NotRunning){
                statusSyncPosition.running = true;
            }
            else{
                statusSyncPosition.running = false;
            }
        }
    }


    Connections {
        target: button
        onClicked: {
            if(process0.getState() != Process.NotRunning){
                process0.kill();
            }

            process0.start("xterm", ["-e", "source /opt/ros/indigo/setup.bash && export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/ORB_SLAM2/Examples/ROS && roscd ORB_SLAM2 && cd  ../../.. &&  utility/connect_camera.py " + textField.text]);
        }
    }


    Connections {
        target: button3
        onClicked: {
            if(process1.getState() != Process.NotRunning){
                process1.kill();
            }
            process1.start("xterm", ["-e", "source /opt/ros/indigo/setup.bash && roscore"]);
        }
    }


    GroupBox {
        id: groupBox2
        x: 34
        y: 305
        width: 241
        height: 140
        enabled: true
        title: qsTr("Camera")

        GridLayout {
            id: gridLayout
            x: -6
            y: -5
            width: 176
            height: 100
            transformOrigin: Item.Center
            rows: 4
            columns: 2

            Pane {
                id: pane
                width: 200
                height: 200
            }



            Button {
                id: button
                width: 130
                text: qsTr("Connect")
                Layout.maximumWidth: 130
                Layout.fillWidth: true
            }
















            FileDialog {
                id: fileDialog
                title: "Please choose a file"
                nameFilters: [ "Bin files (*.bin)"]
                folder: shortcuts.home
                onAccepted: {
                    console.log("You chose: " + fileDialog.fileUrl);
                    textField1.text = fileDialog.fileUrl;
                    textField1.text = textField1.text.slice(7);
                    console.log("You chose: " + textField1.text);
                    checkBox.checked = false;
                }
                onRejected: {
                    console.log("Canceled")
                }
                Component.onCompleted: visible = false

            }
            FileDialog {
                id: fileDialog2
                title: "Please choose a file"
                folder: shortcuts.home
                selectFolder: true;
                onAccepted: {
                    console.log("You chose: " + fileDialog2.Save);
                    destination = fileDialog2.fileUrl;
                    destination = destination.slice(7);
                    console.log("You chose: " + destination);
                    messageDialog.visible = true

                }
                onRejected: {
                    console.log("Canceled")
                }
                Component.onCompleted: visible = false
            }

            Dialog {
                id: messageDialog
                title: "Save File"
                width: 150
                height: 100

                contentItem: GridLayout {
                    id: gridLayout3
                    width: 150
                    height: 100
                    transformOrigin: Item.Center
                    rows: 2
                    columns: 2
                    Text {
                        text: "File name"
                    }
                    TextField {
                        id: textField3
                        width: 200
                        text: qsTr("")
                        rightPadding: 22
                    }

                    Button {
                        id: button10
                        text: qsTr("Save")
                        onClicked: {
                            console.log("rosservice call /ORB_SLAM/SaveFile \"location:\n  data: '" + destination + "/" + textField3.text + "'\"")
                            process4.start("xterm", ["-e", "source ~/ORB_SLAM2/Examples/ROS/ORB_SLAM2/build/devel/setup.bash && rosservice call /ORB_SLAM/SaveFile \"location:\n  data: '" + destination + "/" + textField3.text + "'\""]);
                            timer.start()
                        }
                    }
                    Timer {
                        id: timer
                        interval: 500; running: false; repeat: true
                        onTriggered: {
                            if(process4.getState() != Process.NotRunning){
                                messageDialog.close()
                                timer.stop()
                            }
                        }
                    }


                }
                Component.onCompleted: visible = false
            }







        }
    }

    GroupBox {
        id: groupBox3
        x: 25
        y: 11
        width: 200
        height: 200
        title: qsTr("Core")

        ColumnLayout {
            id: columnLayout
            x: 21
            y: 0
            width: 134
            height: 153

            Button {
                id: button3
                width: 130
                text: qsTr("Start")
                Layout.maximumWidth: 130
                Layout.fillHeight: false
                Layout.fillWidth: true
                clip: true
            }
        }
    }

    GroupBox {
        id: groupBox1
        x: 265
        y: 11
        width: 349
        height: 189
        title: qsTr("ORB 2 SLAM")

        GridLayout {
            id: gridLayout1
            x: -3
            y: -3
            width: 332
            height: 147
            columnSpacing: 5
            rowSpacing: 5
            transformOrigin: Item.Center
            flow: GridLayout.LeftToRight
            rows: 2
            columns: 2
            Layout.fillHeight: false


            Label {
                id: label1
                text: qsTr("File")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                scale: 1
                transformOrigin: Item.Center
                textFormat: Text.AutoText
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
            }









            TextField {
                id: textField1
                width: 200
                text: qsTr("/")
                rightPadding: 22
                readOnly: true
            }

            Button {
                id: button4
                text: qsTr("Select Map")
            }







            CheckBox {
                id: checkBox
                text: qsTr("Create new MAP")
                checked: true
            }


            Button {
                id: button2
                width: 130
                text: qsTr("Open SLAM")
                Layout.minimumWidth: 130
                Layout.maximumWidth: 131
                Layout.fillWidth: true
            }

            Button {
                id: button5
                text: qsTr("Save Map")
            }

        }
    }

    GroupBox {
        id: groupBox
        x: 289
        y: 279
        width: 315
        height: 166
        title: qsTr("Sync Position with Kalman Filtering")

        GridLayout {
            id: gridLayout2
            x: -4
            y: -5
            width: 185
            height: 118
            rows: 2
            columns: 2
            clip: false
            columnSpacing: 5
            rowSpacing: 5


            Pane {
                id: pane2
                width: 200
                height: 200
            }

            Button {
                id: button1
                width: 130
                text: qsTr("Sync")
                Layout.maximumWidth: 130
                Layout.fillWidth: true
            }

            Label {
                id: label3
                text: qsTr("R")
            }

            TextField {
                id: textField4
                text: qsTr("0.5**2")
            }


            Label {
                id: label2
                text: qsTr("Q")
            }

            TextField {
                id: textField2
                text: qsTr("1e-5")
            }






        }
    }

    Connections {
        target: button2
        onClicked: {
            if(process2.getState() != Process.NotRunning){
                process2.kill();
            }
            process2.start("xterm", ["-e", "source /opt/ros/indigo/setup.bash && export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/ORB_SLAM2/Examples/ROS && roscd ORB_SLAM2 && cd  ../../.. && rosrun ORB_SLAM2 Mono Vocabulary/ORBvoc.bin Examples/Monocular/BOSS-CAM.yaml " + !checkBox.checked + " "+ textField1.text]);
        }
    }


    TextField {
        id: textField
        x: 63
        y: 259
        text: qsTr("192.168.0.2")
    }

    Label {
        id: label
        x: 34
        y: 271
        text: qsTr("IP")
    }

    GroupBox {
        id: groupBox4
        x: 25
        y: 226
        width: 589
        height: 231
        z: -1
        title: qsTr("Connection")
    }

    Connections {
        target: button1
        onClicked: {
            if(process3.getState() != Process.NotRunning){
                process3.kill();
            }
            //process3.start("xterm", ["-e", "source /opt/ros/indigo/setup.bash && utility/sent_feedback.py " + textField.text + " " + textField4.text + " " + textField2.text]);
            process3.start("xterm", ["-e","source /opt/ros/indigo/setup.bash && export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/ORB_SLAM2/Examples/ROS && roscd ORB_SLAM2 && cd  ../../.. && " + "utility/sent_feedback.py " + textField.text + " " + textField4.text + " " + textField2.text]);
        }
    }

    Connections {
        target: button4
        onClicked: {
            fileDialog.visible = true;
        }
    }

    Connections {
        target: button5
        onClicked: {
            fileDialog2.visible = true;
        }

    }

    BusyIndicator {
        id: statusCore
        x: 165
        y: 151
        running: false
    }

    BusyIndicator {
        id: statusCamera
        x: 215
        y: 345
        running: false
    }

    BusyIndicator {
        id: statusSyncPosition
        x: 545
        y: 385
        running: false
    }

    BusyIndicator {
        id: statusSLAM
        x: 554
        y: 140
        running: false
    }















}
