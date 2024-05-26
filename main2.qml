import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import MyApp 1.0 // !!import module

ApplicationWindow {
    id: appWindow
    title: qsTr("Window")
    width: 640
    height: 480
    visible: true

    // select a image from disk
    FileDialog {
        id: appImagesSelectDialog

        modality: Qt.WindowModal
        title: qsTr("Choose a image")
        selectMultiple: false
        selectFolder: false
        nameFilters: [ "Image files (*.jpeg *.png *.jpg *.gif)", "All files (*)" ]
        selectedNameFilter: nameFilters[0]
        sidebarVisible: true
        onAccepted: {
            // open image crop dialog
            cropDialg.open();
            cropDialg.source = fileUrls[0];
        }
    }

    ImageCropDialog {
        id: cropDialg
        width: parent.width
        height: parent.height
        onApplied: {
            var croppedFile = ImageHelper.crop(source, selectedRect);
            // apply crop result
            source = Qt.resolvedUrl(croppedFile);
        }
        onAccepted: {
            // show result
            image.source = cropDialg.source;
        }
    }

    Column {
        anchors.centerIn: parent
        // show the result image
        Rectangle {
            width: 256; height: 256
            border.color: "blue"; border.width: 1
            Image { id: image; anchors.fill: parent }
        }
        Button {
            text: qsTr("Choose a image")
            onClicked: appImagesSelectDialog.open();
        }
    }
}
