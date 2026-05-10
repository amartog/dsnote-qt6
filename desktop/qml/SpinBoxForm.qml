import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

SpinBox {
    id: spinBoxForm
    from: 0
    to: 100
    value: 50
}

GridLayout {
    id: root

    property int indends: 0
    property bool verticalMode: parent.verticalMode !== undefined ? parent.verticalMode :
                                parent.parent.verticalMode !== undefined ? parent.parent.verticalMode :
                                parent.parent.parent.verticalMode !== undefined ? parent.parent.parent.verticalMode :
                                false
    property alias label: _label
    property alias spinBox: _spinBox
    property string toolTip: ""
    property alias value: _spinBox.value
    property alias button: _button
    property string toolTipButton: button.text
    property bool compact: true

    columns: verticalMode ? 1 : 2
    rows: verticalMode ? 2 : 1

    Label {
        id: _label
        text: qsTr("Label")
        Layout.preferredWidth: verticalMode ? parent.width : undefined
        Layout.preferredHeight: verticalMode ? undefined : parent.height
        Layout.alignment: verticalMode ? Qt.AlignHCenter : Qt.AlignVCenter
        Layout.column: verticalMode ? 0 : 0
        Layout.row: verticalMode ? 0 : 0
    }

    SpinBox {
        id: _spinBox
        from: 0
        to: 100
        value: 50
        Layout.preferredWidth: verticalMode ? parent.width : undefined
        Layout.preferredHeight: verticalMode ? undefined : parent.height
        Layout.alignment: verticalMode ? Qt.AlignHCenter : Qt.AlignVCenter
        Layout.column: verticalMode ? 0 : 1
        Layout.row: verticalMode ? 1 : 0
    }

    Button {
        id: _button
        text: qsTr("Button")
        Layout.preferredWidth: verticalMode ? parent.width : undefined
        Layout.preferredHeight: verticalMode ? undefined : parent.height
        Layout.alignment: verticalMode ? Qt.AlignHCenter : Qt.AlignVCenter
        Layout.column: verticalMode ? 0 : 2
        Layout.row: verticalMode ? 2 : 0
    }
}
