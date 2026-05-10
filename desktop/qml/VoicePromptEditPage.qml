import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

DialogPage {
    id: root

    readonly property bool verticalMode: width < height
    property var data: null // null => new data

    ColumnLayout {
        property alias verticalMode: root.verticalMode
        Layout.fillWidth: true

        TextArea {
            id: _descForm

            selectByMouse: true
            wrapMode: TextEdit.Wrap
            verticalAlignment: TextEdit.AlignTop
            placeholderText: qsTr("Description")
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.visible: hovered
            ToolTip.text: placeholderText
            hoverEnabled: true
            Layout.fillWidth: true
            text: root.dataDesc
            Layout.minimumHeight: _nameForm.textField.implicitHeight * 3

            TextContextMenu {}
        }

        TextFieldForm {
            id: _nameForm

            label.text: qsTr("Name")
            valid: !root.nameTaken
            toolTip: valid ? "" : qsTr("This name is already taken")
            textField {
                text: root.dataName
                placeholderText: _nameForm.label.text
            }
        }
    }
}
