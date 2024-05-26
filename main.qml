import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import MyApp 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Image Cropper")

    FileDialog{
        id: appImagesSelectDialog
        modality: Qt.WindowModal
        title: qsTr("Choose a image")
        selectMultiple: false
        selectFolder: false
        nameFilters: ["Image files (*.jpeg *.png *.jpg *.gif)"]
        selectedNameFilter: nameFilters[0]
        sidebarVisible: true
        onAccepted: {
            cropDialg.open();
            cropDialg.source = fileUrls[0];
        }
    }

    ImageCropPopup{
        id: cropDialg
        onOkClicked: {
            var croppedData = ImageHelper.crop2Base64data(source, sourceSize , selectedRect);
            image.source = "data:image/png;base64,"+ croppedData
        }
    }

    Column{
        anchors.centerIn: parent
        Rectangle{
            width: 128;height: 128
            border.color: "blue"; border.width: 1
            Image{
                id: image;
                anchors.fill: parent
            }
        }
        Button{
            text: qsTr("Choose a image")
            onClicked: appImagesSelectDialog.open();
        }
    }
}
