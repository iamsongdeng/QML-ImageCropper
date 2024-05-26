import QtQuick 2.15

Rectangle {
    id: selectionRect

    property bool squared: false
    property int rulerSize: 12
    property color rulerColor: "steelblue"
    property int minimumSize: 50
    property int maximumSize: Math.min(parent.width, parent.height)

    color: "#354682B4"
    border {
        width: 2
        color: rulerColor
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

        onDoubleClicked: {
            parent.destroy() // destroy component
        }
    }

    Repeater {
        id: repeater

        //TODO: optimize this code
        readonly property var actions: {
            "left" : function(x, y) {
                selectionRect.width = selectionRect.width - x
                selectionRect.x = selectionRect.x + x
                if(selectionRect.width < minimumSize)
                    selectionRect.width = minimumSize
                if(selectionRect.width > maximumSize)
                    selectionRect.width = maximumSize

                if(squared) {
                    selectionRect.height = selectionRect.width
                }
            },
            "right" : function(x, y) {
                selectionRect.width = selectionRect.width + x
                if(selectionRect.width < minimumSize)
                    selectionRect.width = minimumSize
                if(selectionRect.width > maximumSize)
                    selectionRect.width = maximumSize

                if(squared) {
                    selectionRect.height = selectionRect.width
                }
            },
            "top" : function(x, y) {
                selectionRect.height = selectionRect.height - y
                selectionRect.y = selectionRect.y + y
                if(selectionRect.height < minimumSize)
                    selectionRect.height = minimumSize
                if(selectionRect.height > maximumSize)
                    selectionRect.height = maximumSize

                if(squared) {
                    selectionRect.width = selectionRect.height
                }
            },
            "bottom" : function(x, y) {
                selectionRect.height = selectionRect.height + y
                if(selectionRect.height < minimumSize)
                    selectionRect.height = minimumSize
                if(selectionRect.height > maximumSize)
                    selectionRect.height = maximumSize

                if(squared) {
                    selectionRect.width = selectionRect.height
                }
            },
            "lt" : function(x, y) {
                repeater.actions["left"](x, y);
                if(!squared) {
                    repeater.actions["top"](x, y);
                }
            },
            "lb" : function(x, y) {
                repeater.actions["left"](x, y);
                if(!squared) {
                    repeater.actions["bottom"](x, y);
                }
            },
            "rt" : function(x, y) {
                repeater.actions["right"](x, y);
                if(!squared) {
                    repeater.actions["top"](x, y);
                }
            },
            "rb" : function(x, y) {
                repeater.actions["right"](x, y);
                if(!squared) {
                    repeater.actions["bottom"](x, y);
                }
            },
        }

        model: [
            // edge rulers
            { horizontal: parent.left, vertical: parent.verticalCenter, axis: Drag.XAxis, callback: "left" },
            { horizontal: parent.right, vertical: parent.verticalCenter, axis: Drag.XAxis, callback: "right" },
            { horizontal: parent.horizontalCenter, vertical: parent.top, axis: Drag.YAxis, callback: "top" },
            { horizontal: parent.horizontalCenter, vertical: parent.bottom, axis: Drag.YAxis, callback: "bottom" },
            // corner rulers
            { horizontal: parent.left, vertical: parent.top, axis: Drag.YAxis | Drag.XAxis, callback: "lt" },
            { horizontal: parent.left, vertical: parent.bottom, axis: Drag.YAxis | Drag.XAxis, callback: "lb" },
            { horizontal: parent.right, vertical: parent.top, axis: Drag.YAxis | Drag.XAxis, callback: "rt" },
            { horizontal: parent.right, vertical: parent.bottom, axis: Drag.YAxis | Drag.XAxis, callback: "rb" },
        ]
        delegate: Rectangle {
            width: rulerSize
            height: rulerSize
            radius: rulerSize
            color: rulerColor
            anchors.horizontalCenter: modelData.horizontal
            anchors.verticalCenter: modelData.vertical

            MouseArea {
                anchors.fill: parent
                drag{ target: parent; axis: modelData.axis }
                onPositionChanged: {
                    if(drag.active) {
                        if(typeof repeater.actions[modelData.callback] === "function")
                            repeater.actions[modelData.callback](mouseX, mouseY)
                    }
                }
            }
        }
    }// Repeater
}
