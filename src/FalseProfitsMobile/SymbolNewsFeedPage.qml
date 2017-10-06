import QtQuick 2.7
import QtQuick.XmlListModel 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page {
    property string currentSymbol

    /* newsFeedModel
        Defining XML file of current Symbol to be created as List element.  */
    XmlListModel {
        id: newsFeedModel

        source: "https://feeds.finance.yahoo.com/rss/2.0/headline?s=" + currentSymbol + ".AX"
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "title/string()" }
        // Remove any links from the description
        XmlRole { name: "description"; query: "fn:replace(description/string(), '\&lt;a href=.*\/a\&gt;', '')" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "pubDate"; query: "pubDate/string()" } // Publish date of article.
    }

    /* Creating list from newsFeedModel specifications. */
    ListView {
        id: listView
        anchors.fill: parent
        model: newsFeedModel
        clip: true

        delegate: Column {
            id: delegate
            width: delegate.ListView.view.width - 30 // Width minus 15 points of padding on either side.
            padding: 15
            spacing: 8

            Item { height: 8; width: delegate.width }

            Row {
                width: parent.width
                spacing: 8

                Text {
                    text: title
                    width: delegate.width
                    wrapMode: Text.WordWrap
                    font.pixelSize: 14
                    font.bold: true
                }
            }

            Text {
                width: delegate.width
                font.pixelSize: 8
                textFormat: Text.RichText
                font.italic: true
                text: pubDate
                }

            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                textFormat: Text.StyledText
                text: description
            }
        }
    }
}

