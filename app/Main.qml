import QtQuick 2.4
import Ubuntu.Components 1.3

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "photos.liu-xiao-guo"

    width: units.gu(120)
    height: units.gu(85)

    AdaptivePageLayout {
        id: layout
        anchors.fill: parent
        primaryPage: listPage

        layouts: PageColumnsLayout {
            when: width > units.gu(100)
            // column #0
            PageColumn {
                minimumWidth: units.gu(30)
                maximumWidth: units.gu(80)
                preferredWidth: units.gu(70)
            }
            // column #1
            PageColumn {
                fillWidth: true
            }
        }

        Page {
            id: listPage
            visible: false
            header: standardHeader
            PageHeader {
                id: standardHeader
                visible: listPage.header === standardHeader
                title: "图库"
                trailingActionBar.actions: [
                    Action {
                        iconName: "search"
                        text: "Search"
                        onTriggered: listPage.header = searchHeader
                    }
                ]
            }

            PageHeader {
                id: searchHeader
                visible: listPage.header === searchHeader
                leadingActionBar.actions: [
                    Action {
                        iconName: "back"
                        text: "Back"
                        onTriggered: {
                            input.text = ""
                            articleList.reload()
                            listPage.header = standardHeader
                        }
                    }
                ]
                contents: TextField {
                    id: input
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    placeholderText: "Search for keyword..."

                    onTextChanged: {
                        console.log("text is changed");
                        articleList.reload();
                    }
                }
            }

            ArticleListView {
                id: articleList
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    top: listPage.header.bottom
                }
                clip: true

                onClicked: {
                    articleContent.text = instance.content
                    articleContent.image = instance.image
                    layout.addPageToNextColumn(listPage, contentPage)
                }

                onUpdated: {
                    if ( layout.columns === 1)
                        return

                    console.log( "updated!" );
                    console.log("articleList.currentIndex: " + articleList.currentIndex);
                    var model = articleList.model
                    var index = articleList.currentIndex

                    console.log("index: " + index)

                    articleContent.text = model.get(index).content
                    articleContent.image = model.get(index).image
                    layout.addPageToNextColumn(listPage, contentPage)
                }
            }
        }

        Page {
            id: contentPage
            header: PageHeader {
                title: "Content"
            }

            visible: false

            ArticleContent {
                id: articleContent
                objectName: "articleContent"
                anchors.fill: parent
            }
        }

        onColumnsChanged: {
            console.log("columns: " + columns );

            if ( columns == 2 ) {
                console.log("currentIndex: " + articleList.currentIndex )
                if ( articleList.currentIndex != undefined &&
                        articleList.currentIndex >= 0 ) {
                    var model = articleList.model
                    var index = articleList.currentIndex

                    console.log("index: " + index)

                    articleContent.text = model.get(index).content
                    articleContent.image = model.get(index).image
                    layout.addPageToNextColumn(listPage, contentPage)
                }
            }
        }
    }
}

