/* Copyimport QtQuick 6.2
import Sailfish.Silica 1.0ght (C) 2018-2022 Michal Kosciesza <michal@mkiol.net>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import QtQuick 2.6
import Sailfish.Silica 1.0

FocusScope {
    id: root

    property alias title: header.title
    property alias searchPlaceholderText: search.placeholderText
    property int noSearchCount: 10
    property var view
    property alias combo: _combo
    property alias comboModel: _comboRepeater.model

    height: column.height
    onHeightChanged: view.positionViewAtBeginning()

    Column {
        id: column
        width: parent.width

        PageHeader {
            id: header
        }

        SearchField {
            id: search
            visible: root.view.model.filter.length !== 0 ||
                     root.view.model.count > root.noSearchCount
            width: parent.width

            onActiveFocusChanged: {
                if (activeFocus) root.view.currentIndex = -1
            }

            onTextChanged: {
                root.view.model.filter = text.toLowerCase().trim()
            }
        }

        ComboBox {
            id: _combo

            width: parent.width
            opacity: enabled ? 1.0 : Theme.opacityOverlay
            valueColor: enabled ? Theme.highlightColor : Theme.secondaryHighlightColor
            menu: ContextMenu {
                Repeater {
                    id: _comboRepeater
                    MenuItem { text: modelData }
                }
            }
        }
    }
}
