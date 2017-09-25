import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    width: 400
    height: 400
    property alias userEmailText: userEmailField.text
    property alias userDisplayNameText: userDisplayNameField.text
    property alias userLevelText: userLevelField.text

    GridLayout {
        columnSpacing: 12
        rowSpacing: 20
        anchors.fill: parent
        columns: 2

        Label {
            text: qsTr("Email")
        }

        Label {
            id: userEmailField
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Display Name")
        }

        Label {
            id: userDisplayNameField
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Level")
        }

        Label {
            id: userLevelField
            Layout.fillWidth: true
        }
    }
}
