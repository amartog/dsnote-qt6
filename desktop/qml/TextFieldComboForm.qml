import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15


GridLayout {
    id: root

    property int indends: 0
    property bool verticalMode: parent.verticalMode !== undefined ? parent.verticalMode :
                                parent.parent.verticalMode !== undefined ? parent.parent.verticalMode :
                                parent.parent.parent.verticalMode !== undefined ? parent.parent.parent.verticalMode :
                                false
    property alias label: _label
    property string toolTip: ""
    property alias textField: _textField
    property alias comboBox: _comboBox
    property alias text: _textField.text
    property string toolTipCombo: comboBox.text
    property bool compact: true
    property bool valid: true

}