import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15


InlineMessage {
    id: root

    property int indends: 0
    property alias text: _label.text
    property alias label: _label

}