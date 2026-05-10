import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15


RowForm {
    id: root

    property alias text: _textField.text
    property alias textField: _textField
    signal helpClicked

}