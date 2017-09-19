import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import com.example.fpx 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    width: FpStyle.appWindowWidth
    height: FpStyle.appWindowHeight
    title: qsTr("Hello World")

    StackView {
        id: appNavStack
        anchors.fill: parent
        initialItem: QuotesNavigation{}
    }

    Drawer {
        id: appDrawer
        width: Math.min(appWindow.width, appWindow.height) / 3 * 2
        height: appWindow.height

        property bool enableDrawer: true

        onEnableDrawerChanged: {
            // Drawer doesn't have an enable property, fake one
            dragMargin = !enableDrawer ? 0 : Qt.styleHints.startDragDistance
        }

        ListView {
            id: listView

            focus: true
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: {
                    listView.currentIndex = index
                    if (model.source !== "qrc:/SignOutPage.qml") {
                        appNavStack.clear() // limit depth
                    }
                    appNavStack.push(model.source)
                    appDrawer.close()
                }
            }

            model: ListModel {
                ListElement{ title: qsTr("Quotes"); source: "qrc:/QuotesNavigation.qml" }
                ListElement{ title: qsTr("My Profile"); source: "qrc:/MyUserProfileNavigation.qml" }
                ListElement{ title: qsTr("Sign Out"); source: "qrc:/SignOutPage.qml" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    function showSignInScreen() {
        listView.currentIndex = -1
        appNavStack.push("qrc:/SignInNavigation.qml", {"objectName": "SignInNavigation"})
        appDrawer.close()
        appDrawer.enableDrawer = false
    }

    /*!
       Push the sign in screen if not authenticated,
       Pop the sign in screen if authenticated and the
       stack is not empty, otherwise show the default
       screen.
     */
    function getBackToWork() {
        if (fpCore.authState === Fpx.NotAuthenticatedState) {
            showSignInScreen()
        } else if (appNavStack.currentItem
                   && appNavStack.currentItem.objectName === "SignInNavigation"){
            appDrawer.enableDrawer = true
            if (appNavStack.depth > 1) {
                appNavStack.pop()
            } else {
                listView.currentIndex = 0
                appNavStack.clear() // limit depth
                appNavStack.push("qrc:/QuotesNavigation.qml")
            }
        }
    }

    Connections {
        target: fpCore
        onLaunchSettingsLoaded: {
            getBackToWork()
        }
        onAuthStateChanged: {
            getBackToWork()
        }
    }
}
