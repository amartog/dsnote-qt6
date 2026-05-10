import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15


DialogPage {
    id: root

    readonly property bool verticalMode: width < height
    property var data: null
    property int index: 0

}