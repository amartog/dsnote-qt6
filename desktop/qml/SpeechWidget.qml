/* Copyright (C) 2021-2023 Michal Kosciesza <michal@mkiol.net>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

import org.mkiol.dsnote.Dsnote 1.0
import org.mkiol.dsnote.Settings 1.0

RowLayout {
    id: root

    property bool verticalMode: width < appWin.height * 0.8

    Frame {
        Layout.fillWidth: true
        leftPadding: appWin.padding
        rightPadding: appWin.padding
        topPadding: 0
        bottomPadding: appWin.padding

        background: Item {}

        GridLayout {
            columns: verticalMode ? 1 : 2
            anchors.fill: parent

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom

                ToolButton {
                    id: _icon
                    enabled: false
                    visible: false
                    Layout.alignment: Qt.AlignVCenter
                    icon.name: "audio-speakers-symbolic"
                }

                ComboBox {
                    id: _combo
                    enabled: false
                    visible: false
                }

                Item {
                    width: _icon.width
                    height: _icon.height
                    Layout.alignment: Qt.AlignBottom

                    SpeechIndicator {
                        id: indicator

                        anchors.centerIn: parent
                        width: 27
                        height: 24
                        visible: !busyIndicator.running
                        status: {
                            switch (app.task_state) {
                            case DsnoteApp.TaskStateIdle: return 0;
                            case DsnoteApp.TaskStateSpeechDetected: return 1;
                            case DsnoteApp.TaskStateProcessing: return 2;
                            case DsnoteApp.TaskStateInitializing: return 3;
                            case DsnoteApp.TaskStateSpeechPlaying: return 4;
                            case DsnoteApp.TaskStateSpeechPaused: return 5;
                            case DsnoteApp.TaskStateCancelling: return 3;
                            }
                            return 0;
                        }
                        color: palette.text
                    }

                    BusyIndicator {
                        id: busyIndicator

                        anchors.fill: parent
                        running: app.busy || service.busy ||
                                 app.state === DsnoteApp.StateTranscribingFile ||
                                 app.state === DsnoteApp.StateWritingSpeechToFile ||
                                 app.state === DsnoteApp.StateRestoringText ||
                                 app.state === DsnoteApp.StateImporting ||
                                 app.state === DsnoteApp.StateExporting
                        visible: running
                    }
                }

                Frame {
                    id: frame

                    topPadding: 2
                    bottomPadding: 2
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(_combo.height,
                                                     speechText.implicitHeight + topPadding + bottomPadding)
                    background: Rectangle {
                        color: frame.palette.button
                        border.color: frame.palette.buttonText
                        opacity: 0.3
                        radius: 3
                    }

                    Label {
                        id: speechText

                        anchors.fill: parent
                        wrapMode: TextEdit.Wrap
                        verticalAlignment: Text.AlignVCenter
                        font: _settings.notepad_font
                        color: palette.text

                        property string placeholderText: {
                            if (app.busy || service.busy)
                                return qsTr("Busy...")
                            if (app.task_state === DsnoteApp.TaskStateCancelling)
                                return qsTr("Cancelling, please wait...")
                            if (app.task_state === DsnoteApp.TaskStateInitializing)
                                return qsTr("Getting ready, please wait...")
                            if (app.state === DsnoteApp.StateRestoringText)
                                return qsTr("Repairing the text...")
                            if (app.state === DsnoteApp.StateWritingSpeechToFile)
                                return qsTr("Converting text to speech...") +
                                        (app.speech_to_file_progress > 0.0 ? " " +
                                                                             Math.round(app.speech_to_file_progress * 100) + "%" : "")
                            if (app.state === DsnoteApp.StateImporting)
                                return qsTr("Importing from a file...") +
                                        (app.mc_progress > 0.0 ? " " + Math.round(app.mc_progress * 100) + "%" : "")
                            if (app.state === DsnoteApp.StateExporting)
                                return qsTr("Exporting to a file...") +
                                        (app.mc_progress > 0.0 ? " " + Math.round(app.mc_progress * 100) + "%" : "")
                            if (app.state === DsnoteApp.StateTranslating)
                                return qsTr("Translating...") +
                                        (app.translate_progress > 0.0 ? " " +
                                                                             Math.round(app.translate_progress * 100) + "%" : "")
                            if (app.state === DsnoteApp.StateTranscribingFile)
                                return qsTr("Transcribing audio file...") +
                                        (app.transcribe_progress > 0.0 ? " " +
                                                                         Math.round(app.transcribe_progress * 100) + "%" : "")
                            if (app.task_state === DsnoteApp.TaskStateProcessing)
                                return qsTr("Processing, please wait...")
                            if (app.state === DsnoteApp.StateListeningSingleSentence ||
                                    app.state === DsnoteApp.StateListeningAuto ||
                                    app.state === DsnoteApp.StateListeningManual) return qsTr("Say something...")
                            if (app.task_state === DsnoteApp.TaskStateSpeechPaused) return qsTr("Reading is paused.")
                            if (app.state === DsnoteApp.StatePlayingSpeech) return qsTr("Reading a note...")

                            return ""
                        }

                        FontMetrics {
                            id: fontMetrics

                            font: speechText.font
                        }

                        function elideMultilineText(text, width, lines) {
                            var text_width = fontMetrics.boundingRect(text).width
                            if (text_width <= width)
                                return text

                            var text_lines = text_width / width
                            if (text_lines <= lines)
                                return text

                            var chars_to_clip = Math.ceil((text_lines - lines) * (text.length / text_lines))

                            return "..." + text.substr(chars_to_clip)
                        }

                        text: app.intermediate_text.length === 0 ? placeholderText :
                                                                   elideMultilineText(app.intermediate_text, speechText.width, 10)
                        opacity: app.intermediate_text.length === 0 ? 0.6 : 1.0
                    }
                }

                SequentialAnimation {
                    running: app.task_state === DsnoteApp.TaskStateSpeechPaused
                    loops: Animation.Infinite
                    alwaysRunToEnd: true

                    OpacityAnimator {
                        target: pauseButton
                        from: 1.0
                        to: 0.0
                        duration: 500
                    }
                    OpacityAnimator {
                        target: pauseButton
                        from: 0.0
                        to: 1.0
                        duration: 500
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: root.verticalMode
                Layout.alignment: Qt.AlignBottom

                Item {
                    visible: root.verticalMode
                    Layout.preferredWidth: _icon.width
                }

                Button {
                    id: pauseButton

                    Layout.alignment: Qt.AlignBottom
                    Layout.preferredHeight: _icon.implicitHeight
                    visible: !stopButton.visible
                    display: AbstractButton.IconOnly

                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: (app.task_state === DsnoteApp.TaskStateSpeechPaused ?
                                      qsTr("Resume reading") : qsTr("Pause reading")) + " (Ctrl+Alt+Shift+P)"
                    hoverEnabled: true

                    action: Action {
                        enabled: app.task_state !== DsnoteApp.TaskStateCancelling &&
                                 app.state === DsnoteApp.StatePlayingSpeech &&
                                 (app.task_state === DsnoteApp.TaskStateProcessing ||
                                  app.task_state === DsnoteApp.TaskStateSpeechPlaying ||
                                  app.task_state === DsnoteApp.TaskStateSpeechPaused)
                        icon.name: app.task_state === DsnoteApp.TaskStateSpeechPaused ?
                                       "media-playback-start-symbolic" : "media-playback-pause-symbolic"
                        text: app.task_state === DsnoteApp.TaskStateSpeechPaused ?
                                  qsTr("Resume reading") : qsTr("Pause reading")
                        shortcut: "Ctrl+Alt+Shift+P"
                        onTriggered: {
                            if (app.task_state === DsnoteApp.TaskStateSpeechPaused)
                                app.resume_speech()
                            else
                                app.pause_speech()
                        }
                    }
                }

                Button {
                    id: stopButton

                    Layout.fillWidth: root.verticalMode
                    Layout.alignment: Qt.AlignBottom
                    Layout.preferredHeight: _icon.implicitHeight

                    visible: app.state === DsnoteApp.StateListeningSingleSentence ||
                             app.state === DsnoteApp.StateListeningManual ||
                             app.state === DsnoteApp.StateListeningAuto

                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: qsTr("Stops listening. The already captured voice is decoded into text.") + " (Ctrl+Alt+Shift+S)"
                    hoverEnabled: true

                    action: Action {
                        enabled: app.task_state !== DsnoteApp.TaskStateCancelling &&
                                 app.task_state !== DsnoteApp.TaskStateProcessing &&
                                 app.task_state !== DsnoteApp.TaskStateInitializing &&
                                 (app.state === DsnoteApp.StateListeningSingleSentence ||
                                  app.state === DsnoteApp.StateListeningManual ||
                                  app.state === DsnoteApp.StateListeningAuto)
                        icon.name: "media-playback-stop-symbolic"
                        text: qsTr("Stop")
                        shortcut: "Ctrl+Alt+Shift+S"
                        onTriggered: app.stop_listen()
                    }
                }

                Button {
                    id: cancelButton

                    Layout.fillWidth: root.verticalMode
                    Layout.alignment: Qt.AlignBottom
                    Layout.preferredHeight: _icon.implicitHeight

                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: qsTr("Cancel") + " (Ctrl+Alt+Shift+C)"
                    hoverEnabled: true

                    action: Action {
                        icon.name: "action-unavailable-symbolic"
                        enabled: app.task_state !== DsnoteApp.TaskStateCancelling &&
                                 (app.task_state === DsnoteApp.TaskStateProcessing ||
                                 app.task_state === DsnoteApp.TaskStateInitializing ||
                                 app.state === DsnoteApp.StateTranscribingFile ||
                                 app.state === DsnoteApp.StateListeningSingleSentence ||
                                 app.state === DsnoteApp.StateListeningManual ||
                                 app.state === DsnoteApp.StateListeningAuto ||
                                 app.state === DsnoteApp.StatePlayingSpeech ||
                                 app.state === DsnoteApp.StateWritingSpeechToFile ||
                                 app.state === DsnoteApp.StateTranslating ||
                                 app.state === DsnoteApp.StateExporting ||
                                 app.state === DsnoteApp.StateImporting)
                        text: qsTr("Cancel")
                        shortcut: "Ctrl+Alt+Shift+C"
                        onTriggered: app.cancel()
                    }
                }
            }
        }
    }
}
