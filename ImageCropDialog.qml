import QtQuick 2.15
import QtQuick.Controls 2.15


Dialog {
    id: control

    property rect selectedRect
    property alias source: imageItem.source
    property var selection: undefined

    function createSelection()
    {
        if(!selection) {
            // centre in parent
            var ajustWidth = Math.min(parent.width, parent.height) / 2;
            var properties = {
                "width": ajustWidth, "height": ajustWidth,
                "x": (viewport.width - ajustWidth) / 2, "y": (viewport.height - ajustWidth) / 2
            }
            selection = selectionComponent.createObject(viewport, properties)
        }
    }

    title: qsTr("Crop Image Dialog")
    modal: true
    padding: 0
    standardButtons: Dialog.Apply | Dialog.Ok | Dialog.Cancel
    closePolicy: Popup.CloseOnEscape
    onApplied: {
        // mapping parent coordinate to current coordinate
        selectedRect = imageItem.mapFromItem(viewport, selection.x, selection.y,selection.width, selection.height);
    }

    Component {
        id: selectionComponent
        SelectionArea {
            id: selectionRect
            squared: true
        }
    }

    // iamge viewport
    Rectangle {
        id: viewport
        anchors.fill: parent
        color: "black"

        Image {
            id: imageItem

            // zoom in or zoom out
            scale: 1 / (sourceSize.height / parent.height)
            fillMode: Image.Pad
            anchors.centerIn: parent
            onStatusChanged: {
                if(status === Image.Ready) {
                    createSelection();
                }
            }
            onSourceChanged: {
                // reset selection area
                if(selection) {
                    selection.destroy();
                    selection = undefined;
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(imageItem.status === Image.Ready) {
                        createSelection();
                    }
                }
            }
        } // Image item
    } // viewport
}
