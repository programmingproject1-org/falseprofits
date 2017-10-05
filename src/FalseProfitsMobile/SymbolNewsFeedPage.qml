import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    property string currentSymbol

    Label {
        anchors.centerIn: parent
        text: "News for " + currentSymbol
    }

    ListView {
        id: listView2
        anchors.fill: parent

        model: ListModel {
            ListElement {
                name: "Grey"
                colorCode: "grey"
            }

            ListElement {
                name: "Red"
                colorCode: "red"
            }

            ListElement {
                name: "Blue"
                colorCode: "blue"
            }

            ListElement {
                name: "Green"
                colorCode: "green"
            }

            ListElement {
                name: "Orange"
                colorCode: "orange"
            }
        }
        delegate: Item {
            x: 5
            width: 80
            height: 40
            Row {
                id: row3
                spacing: 10
                Rectangle {
                    width: 40
                    height: 40
                    color: colorCode
                }

                Text {
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                }
            }
        }
    }
}
