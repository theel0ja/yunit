AbstractButton { 
                id: root; 
                property var cardData; 
                property string artShapeStyle: "inset"; 
                property string backgroundShapeStyle: "inset"; 
                property real fontScale: 1.0; 
                property var scopeStyle: null; 
                property int fixedHeaderHeight: -1; 
                property size fixedArtShapeSize: Qt.size(-1, -1); 
                readonly property string title: cardData && cardData["title"] || ""; 
                property bool showHeader: true; 
                implicitWidth: childrenRect.width; 
                enabled: false;
signal action(var actionId);
readonly property size artShapeSize: artShapeLoader.item ? Qt.size(artShapeLoader.item.width, artShapeLoader.item.height) : Qt.size(-1, -1);
Item  { 
                            id: artShapeHolder; 
                            height: root.fixedArtShapeSize.height > 0 ? root.fixedArtShapeSize.height : artShapeLoader.height; 
                            width: root.fixedArtShapeSize.width > 0 ? root.fixedArtShapeSize.width : artShapeLoader.width; 
                            anchors { horizontalCenter: parent.horizontalCenter; } 
                            Loader { 
                                id: artShapeLoader; 
                                objectName: "artShapeLoader"; 
                                readonly property string cardArt: cardData && cardData["art"] || "";
                                active: cardArt != "";
                                asynchronous: true;
                                visible: status == Loader.Ready;
                                sourceComponent: Item {
                                    id: artShape;
                                    objectName: "artShape";
                                    visible: image.status == Image.Ready;
                                    readonly property alias image: artImage;
                                    ShaderEffectSource {
                                        id: artShapeSource;
                                        sourceItem: artImage;
                                        anchors.centerIn: parent;
                                        width: 1;
                                        height: 1;
                                        hideSource: false;
                                    }
                                    Loader {
                                        anchors.fill: parent;
                                        visible: false;
                                        sourceComponent: root.artShapeStyle === "icon" ? artShapeIconComponent : artShapeShapeComponent;
                                        Component {
                                            id: artShapeShapeComponent;
                                            UbuntuShape {
                                                source: artShapeSource;
                                                sourceFillMode: UbuntuShape.PreserveAspectCrop;
                                                radius: "medium";
                                                aspect: {
                                                    switch (root.artShapeStyle) {
                                                        case "inset": return UbuntuShape.Inset;
                                                        case "shadow": return UbuntuShape.DropShadow;
                                                        default:
                                                        case "flat": return UbuntuShape.Flat;
                                                    }
                                                }
                                            }
                                        }
                                        Component {
                                            id: artShapeIconComponent;
                                            ProportionalShape { source: artShapeSource; aspect: UbuntuShape.DropShadow; }
                                        }
                                    }
                                    readonly property real fixedArtShapeSizeAspect: (root.fixedArtShapeSize.height > 0 && root.fixedArtShapeSize.width > 0) ? root.fixedArtShapeSize.width / root.fixedArtShapeSize.height : -1;
                                    readonly property real aspect: fixedArtShapeSizeAspect > 0 ? fixedArtShapeSizeAspect : 1;
                                    Component.onCompleted: { updateWidthHeightBindings(); }
                                    Connections { target: root; onFixedArtShapeSizeChanged: updateWidthHeightBindings(); }
                                    function updateWidthHeightBindings() {
                                        if (root.fixedArtShapeSize.height > 0 && root.fixedArtShapeSize.width > 0) {
                                            width = root.fixedArtShapeSize.width;
                                            height = root.fixedArtShapeSize.height;
                                        } else {
                                            width = Qt.binding(function() { return image.status !== Image.Ready ? 0 : image.width });
                                            height = Qt.binding(function() { return image.status !== Image.Ready ? 0 : image.height });
                                        }
                                    }
                                    CroppedImageMinimumSourceSize {
                                        id: artImage;
                                        objectName: "artImage";
                                        source: artShapeLoader.cardArt;
                                        asynchronous: true;
                                        width: root.width;
                                        height: width / artShape.aspect;
                                    }
                                } 
                            }
                        }
Loader { 
                            id: overlayLoader; 
                            readonly property real overlayHeight: root.fixedHeaderHeight + units.gu(2);
                            anchors.fill: artShapeHolder; 
                            active: artShapeLoader.active && artShapeLoader.item && artShapeLoader.item.image.status === Image.Ready || false; 
                            asynchronous: true;
                            visible: showHeader && status == Loader.Ready; 
                            sourceComponent: UbuntuShapeOverlay { 
                                id: overlay; 
                                property real luminance: Style.luminance(overlayColor); 
                                aspect: UbuntuShape.Flat; 
                                radius: "medium"; 
                                overlayColor: cardData && cardData["overlayColor"] || "#99000000"; 
                                overlayRect: Qt.rect(0, 1 - overlayLoader.overlayHeight / height, 1, 1); 
                            } 
                        }
readonly property int headerHeight: titleLabel.height + subtitleLabel.height + subtitleLabel.anchors.topMargin;
Label { 
                        id: titleLabel;
                        objectName: "titleLabel"; 
                        anchors { right: parent.right; 
                        rightMargin: units.gu(1); 
                        left: parent.left; 
                        leftMargin: units.gu(1); 
                        top: overlayLoader.top; 
                        topMargin: units.gu(1) + overlayLoader.height - overlayLoader.overlayHeight; 
                        } 
                        elide: Text.ElideRight; 
                        fontSize: "small"; 
                        wrapMode: Text.Wrap; 
                        maximumLineCount: 2; 
                        font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale); 
                        color: root.scopeStyle && overlayLoader.item ? root.scopeStyle.getTextColor(overlayLoader.item.luminance) : (overlayLoader.item && overlayLoader.item.luminance > 0.7 ? theme.palette.normal.baseText : "white");
                        visible: showHeader && overlayLoader.active; 
                        width: undefined;
                        text: root.title; 
                        font.weight: cardData && cardData["subtitle"] ? Font.DemiBold : Font.Normal; 
                        horizontalAlignment: Text.AlignLeft;
                    }
Label { 
                            id: subtitleLabel; 
                            objectName: "subtitleLabel"; 
                            anchors { left: titleLabel.left; 
                            leftMargin: titleLabel.leftMargin; 
                            rightMargin: units.gu(1); 
                            right: titleLabel.right; 
                            top: titleLabel.bottom; 
                            } 
                            anchors.topMargin: units.dp(2); 
                            elide: Text.ElideRight; 
                            maximumLineCount: 1; 
                            fontSize: "x-small"; 
                            font.pixelSize: Math.round(FontUtils.sizeToPixels(fontSize) * fontScale); 
                            color: root.scopeStyle && overlayLoader.item ? root.scopeStyle.getTextColor(overlayLoader.item.luminance) : (overlayLoader.item && overlayLoader.item.luminance > 0.7 ? theme.palette.normal.baseText : "white");
                            visible: titleLabel.visible && titleLabel.text; 
                            text: cardData && cardData["subtitle"] || ""; 
                            font.weight: Font.Light; 
                        }
UbuntuShape { 
    id: touchdown; 
    objectName: "touchdown"; 
    anchors { fill: artShapeHolder } 
    visible: root.artShapeStyle != "shadow" && root.artShapeStyle != "icon" && root.pressed;
    radius: "medium"; 
    borderSource: "radius_pressed.sci" 
}
implicitHeight: artShapeHolder.height;
}
