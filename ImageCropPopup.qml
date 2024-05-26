import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id:root
    modal:true
    closePolicy: Popup.NoAutoClose
    spacing: 15

    signal okClicked             //确定按钮点击
    signal cancelClicked         //取消按钮点击
    property string okText: "Ok"
    property string cancelText:"Cancel"
    property int maxSourceSide: 300
    property int maxSelectionSide : 128

    property size sourceSize
    property rect selectedRect
    property alias source: imageItem.source
    property var selection: undefined

    width: maxSourceSide + 30
    height: maxSourceSide + 80
    anchors.centerIn: parent
    background: Rectangle {
        radius: 4
        border.color: "#E7E7E7"
        border.width: 1
    }

    // iamge viewport
    Rectangle {
        id: viewport
        width:  parent.width
        height: parent.height - rectFooter.height
        anchors.top: parent.Top
        //color: "blue"

        Image {
            id: imageItem

            sourceSize: Qt.size(maxSourceSide,maxSourceSide)

            fillMode: Image.Pad
            anchors.centerIn: parent
            onStatusChanged: {
                if(status === Image.Ready) {
                    createSelection();
                    console.log("implicitWidth:" + implicitWidth  +  ", implicitHeight:" + implicitHeight)
                }
            }
        } // Image item
    } // viewport
    Rectangle
    {
        id:rectFooter
        width:parent.width
        height:50
        anchors.top: viewport.bottom

        Rectangle
        {
            id:topLine
            width: parent.width
            height:1
            color: "grey"
            anchors.top: parent.top
        }

        //ok
        Rectangle{
            id:btnOk
            width:72
            height:26
            radius:4
            border.color: "blue"
            color:"blue"
            anchors{
                verticalCenter: parent.verticalCenter
                right:parent.right
                rightMargin: 40
            }
            Text{
                text:okText
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter:  parent.horizontalCenter
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    sourceSize = Qt.size(imageItem.implicitWidth, imageItem.implicitHeight);
                    selectedRect = imageItem.mapFromItem(imageItem, selection.x, selection.y,selection.width, selection.height);
                    okClicked()
                    close()
                }
            }
        }
        //cancel
        Rectangle{
            id:btnCancel
            width:72
            height:26
            radius:4
            border.color: "blue"
            color:"white"
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
                leftMargin: 40
            }
            Text{
                text:cancelText
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter:  parent.horizontalCenter
            }
            MouseArea{
                anchors.fill:parent
                onClicked: {
                    cancelClicked()
                    close()
                }
            }
        }
    }

    function createSelection()
    {
        if(!selection) {
            // centre in parent
            var ajustWidth = Math.min(maxSelectionSide, imageItem.implicitWidth, imageItem.implicitHeight);   //Math.min(parent.width, parent.height) / 2;
            var properties = {
                "width": ajustWidth, "height": ajustWidth,
                "x": (imageItem.implicitWidth - ajustWidth) / 2, "y": (imageItem.implicitHeight - ajustWidth) / 2
            }
            selection = selectionComponent.createObject(imageItem, properties)
        }
        console.log("x===" + selection.x + ", y==="+ selection.y );
    }


    Component {
        id: selectionComponent
        Rectangle {
            id: selectionRect

            color: "#354682B4"
            border {
                width: 1
                color: "red"
            }

            MouseArea {
                id: dragMouseArea
                anchors.fill: parent
                drag{
                    target: parent
                    minimumX: 0
                    minimumY: 0
                    maximumX: parent.parent.width - parent.width
                    maximumY: parent.parent.height - parent.height
                    smoothed: true
                }
            }

        }
    }
}
