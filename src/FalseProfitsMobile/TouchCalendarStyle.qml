
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import com.example.fpx 1.0

CalendarStyle {
    navigationBar: Rectangle {
        color: "#f9f9f9"
        height: dateText.height * 2

        ToolButton {
            id: previousMonth
            width: parent.height
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            iconSource: "qrc:/images/" + FpStyle.iconPrimary + "/arrow_back.png"
            onClicked: control.showPreviousMonth()
        }
        Label {
            id: dateText
            text: styleData.title
            font.pixelSize: defaultFontPixelSize * 1.5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: previousMonth.right
            anchors.leftMargin: 2
            anchors.right: nextMonth.left
            anchors.rightMargin: 2
        }
        ToolButton {
            id: nextMonth
            width: parent.height
            height: width
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            iconSource: "qrc:/images/" + FpStyle.iconPrimary + "/arrow_forward.png"
            onClicked: control.showNextMonth()
        }
    }
}
