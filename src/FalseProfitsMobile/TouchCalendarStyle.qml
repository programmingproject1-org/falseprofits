/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import com.example.fpx 1.0

CalendarStyle {
    navigationBar: Rectangle {
        color: "#f9f9f9"
        height: dateText.height * 2

        Rectangle {
            color: Qt.rgba(1, 1, 1, 0.6)
            height: 1
            width: parent.width
        }

        Rectangle {
            anchors.bottom: parent.bottom
            height: 1
            width: parent.width
            color: "#ddd"
        }

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

//    dayOfWeekDelegate: Rectangle {
//        color: gridVisible ? "#fcfcfc" : "transparent"
//        Label {
//            text: Qt.locale().dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
//            font.pixelSize: defaultFontPixelSize * 0.8
//            anchors.centerIn: parent
//        }
//    }

    dayDelegate: Rectangle {
        Label {
            text: styleData.date.getDate()
            anchors.centerIn: parent

            readonly property color sameMonthDateTextColor: "#444"
            readonly property color selectedDateTextColor: "#111"
            readonly property color differentMonthDateTextColor: "#bbb"
            readonly property color invalidDatecolor: "#dddddd"

            font.underline: styleData.selected

            color: {
                var color = invalidDatecolor;
                if (styleData.valid) {
                    // Date is within the valid range.
                    color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                    if (styleData.selected) {
                        color = selectedDateTextColor;
                    }
                }
                color;
            }
        }
    }
}
