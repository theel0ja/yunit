/*
 * Copyright (C) 2014 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0

/*! Interface for preview widgets. */

Item {
    //! Specifies the preview widget being currently used or not
    property bool isCurrentPreview: true

    //! The widget identifier
    property string widgetId

    //! Variable used to contain widget's data
    property var widgetData

    //! The StyleTool component.
    property var styleTool: { foreground: "grey" }

    /*! \brief This signal should be emitted when a preview action was triggered.
     *
     *  \param widgetId, actionId Respective identifiers from widgetData.
     *  \param data Optional widget-specific data sent to the scope.
     */
    signal triggered(string widgetId, string actionId, var data)

    objectName: widgetId
}
