import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls 1.4 as OldControl
import QtQuick.Layouts 1.3

import com.example.fpx 1.0
//import "DatePicker"

TransactionsPageForm {
    property int busyIndicatorVisibility: 0

    FpTransactionsWrapper {
        id: transactionsWrapper
        coreClient: fpCore
    }

    FpTradingAccounts {
        id: myTradingAccounts
        coreClient: fpCore
    }

    Connections {
        target: fpCore
        onAuthStateChanged: {
            if (fpCore.authState === Fpx.AuthenticatedState) {
                updateAccounts()
                if (transactionsWrapper.currentAccountId() !== "") {
                    refreshTransactions()
                }
            }
        }
    }

    Component.onCompleted: {
        accountsComboBox.model = myTradingAccounts.model
        listView.model = transactionsWrapper.model

        if (fpCore.authState === Fpx.AuthenticatedState) {
            updateAccounts()
            if (transactionsWrapper.currentAccountId() !== "") {
                refreshTransactions()
            }
        }
    }

    accountsComboBox.onActivated: {
        var accountId = myTradingAccounts.model.getAccountId(accountsComboBox.currentIndex)
        var notifier = transactionsWrapper.loadTransactions(accountId)
        incrementBusyIndicatorVisibility()
        notifier.onFinished.connect(function() {
            // TODO(seamus): Handle errors
            decrementBusyIndicatorVisibility()
            transactionsEmpty = listView.count == 0
        })
    }

    menuButton.onClicked: {
        appDrawer.open()
    }

    filterButton.onClicked: {
        transactionQueryPopup.open()
    }

    listView.onAtYEndChanged: {
        if (listView.atYEnd) {
            fetchMoreResults()
        }
    }

    function incrementBusyIndicatorVisibility() {
        busyIndicator.visible = true
        busyIndicatorVisibility = busyIndicatorVisibility + 1
    }

    function decrementBusyIndicatorVisibility() {
        busyIndicatorVisibility = busyIndicatorVisibility - 1
        if (busyIndicatorVisibility == 0) {
            busyIndicator.visible = false
        }
    }

    function updateAccounts() {
        var notifier = myTradingAccounts.updateAccounts()
        incrementBusyIndicatorVisibility()
        notifier.onFinished.connect(function() {
            decrementBusyIndicatorVisibility()
            if (accountsComboBox.currentIndex == -1) {
                accountsComboBox.incrementCurrentIndex()
            }
        })
    }

    function refreshTransactions() {
        var notifier = transactionsWrapper.refreshTransactions()
        incrementBusyIndicatorVisibility()
        notifier.onFinished.connect(function() {
            // TODO(seamus): Handle errors
            decrementBusyIndicatorVisibility()
            transactionsEmpty = listView.count == 0
        })
    }

    function fetchMoreResults() {
        if (!transactionsWrapper.canFetchMore())
            return

        var notifier = transactionsWrapper.getNextPage()
        incrementBusyIndicatorVisibility()
        notifier.onFinished.connect(function() {
            decrementBusyIndicatorVisibility()
        })
    }

    Dialog {
        id: transactionQueryPopup
        focus: true
        standardButtons: Dialog.Ok | Dialog.Cancel
        modal: visible

        x: (parent.width - width) / 2 //parent.width - width - 5
        y: 5 //(parent.height - height) / 2

        title: qsTr("Filter Transactions")

        onAboutToHide: {
            startCalendar.visible = false;
            endCalendar.visible = false
        }

        ColumnLayout {

            Label {
                text: "Select, then choose from the calendar."
            }

            Row {
                Label {
                    text: qsTr("First Date")
                    rightPadding: 10
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            startCalendar.visible = true;
                            endCalendar.visible = false
                        }

                    }
                }


                OldControl.TextField {
                    id: startdateText
                    text: Qt.formatDate(startCalendar.selectedDate, "dd/MM/yyyy")
                    inputMask: "99/99/9999"

                    onEditingFinished: {
                        var newDate = new Date();
                        newDate.setDate(text.substr(0, 2));
                        newDate.setMonth(text.substr(3, 2) - 1);
                        newDate.setFullYear(text.substr(6, 4));
                        startCalendar.selectedDate = newDate;
                        startCalendar.visible = false
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            startCalendar.visible = true;
                            endCalendar.visible = false
                        }

                    }
                }
            }

            Row
            {
                Label {
                    text: qsTr("Last Date")
                    rightPadding: 10
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            startCalendar.visible = false;
                            endCalendar.visible = true
                        }

                    }
                }

                TextField {
                    id: endDateText
                    text: Qt.formatDate(endCalendar.selectedDate, "dd/MM/yyyy")
                    inputMask: "99/99/9999"

                    onEditingFinished: {
                        var newDate = new Date();
                        newDate.setDate(text.substr(0, 2));
                        newDate.setMonth(text.substr(3, 2) - 1);
                        newDate.setFullYear(text.substr(6, 4));
                        endCalendar.selectedDate = newDate;
                        endCalendar.visible = false
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            startCalendar.visible = false;
                            endCalendar.visible = true
                        }
                    }
                }
            }

            Row{
                OldControl.Calendar {
                    id: startCalendar
                    visible: false
                    //                // x: (parent.parent.width - width) / 2
                    //                y: parent.parent.parent.y + parent.parent.parent.height + 20
                    //                anchors.horizontalCenter: parent.horizontalCenter
                    width: 256 //parent.width * 0.8
                    height: width
                    //anchors.centerIn: parent

                    focus: visible
                    onClicked: visible = false
                    Keys.onBackPressed: {
                        event.accepted = true;
                        visible = false
                    }

                    style: FpCalendarStyle {
                    }
                }
                OldControl.Calendar {
                    id: endCalendar
                    visible: false
                    //                // x: (parent.parent.width - width) / 2
                    //                y: parent.parent.parent.y + parent.parent.parent.height + 20
                    //                anchors.horizontalCenter: parent.horizontalCenter
                    width: 256 //parent.width * 0.8
                    height: width
                    //anchors.centerIn: parent

                    focus: visible
                    onClicked: visible = false
                    Keys.onBackPressed: {
                        event.accepted = true;
                        visible = false
                    }

                    style: FpCalendarStyle {
                    }
                }
            }
        }

        onAccepted: {
            // new Date()
            var start = startDateInput.calendar.selectedDate
            var end = endDateInput.calendar.selectedDate
            transactionsWrapper.setDateRangeLocal(start, end)
            refreshTransactions()
        }
    }
}
