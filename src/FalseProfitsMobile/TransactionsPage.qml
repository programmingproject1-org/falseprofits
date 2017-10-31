import QtQuick 2.7
import QtQuick.Controls 2.2
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
            startDateInput.calendar.visible = false;
            endDateInput.calendar.visible = false
        }

        GridLayout {
            columns: 2

            Label {
                text: qsTr("First Date")
            }

//            TextField {
//                id: startDateInput
//                placeholderText: "yyyy-M-d"
//                selectByMouse: true
//                Layout.fillWidth: true
//            }

            DatePicker {
                id: startDateInput

                TextField {
                    id: dateText
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            startDateInput.calendar.visible = true
                            endDateInput.calendar.visible = false
                        }
                    }
                }
            }

            Label {
                text: qsTr("Last Date")
            }

            DatePicker {
                id: endDateInput
//                    MouseArea {
//                        anchors.fill: parent
//                        onClicked: {
//                            startDateInput.calendar.visible = false
//                        }
//                    }
            }

//            TextField {
//                id: endDateInput
//                placeholderText: "yyyy-M-d"
//                selectByMouse: true
//                Layout.fillWidth: true
//            }
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
