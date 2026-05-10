import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

Dialog {
    id: root

    property var streams
    property int selectedIndex: 0
    readonly property bool canAccept: app.stt_configured || combo.displayText.lastIndexOf("Audio") !== 0

    title: qsTr("Stream Selection")

    Column {
        anchors.centerIn: parent
        spacing: 20

        Label {
            text: qsTr("Select Audio Stream")
        }

        ComboBox {
            id: combo
            model: streams
            currentIndex: selectedIndex
            onCurrentIndexChanged: selectedIndex = currentIndex
        }

        Button {
            text: qsTr("OK")
            enabled: canAccept
            onClicked: root.accept()
        }
    }
}
