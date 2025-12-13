import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

Window {
    id: window
    minimumHeight: 600
    minimumWidth: 800
    visible: true
    title: qsTr("Hello World")
    property bool completedVar: true
    property bool activeVar: true
    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        RowLayout {
            id: filterButtons
            Layout.alignment: Qt.AlignHCenter
            anchors.top: parent.top
            width: parent.width
            Button {
                id: all
                palette.button: "blue"
                Layout.minimumHeight: 40
                Layout.minimumWidth: 100
                Text {
                    text: "All"
                    anchors.centerIn: parent
                }
                onClicked: {
                    completedVar = true
                    activeVar = true
                }
            }
            Button {
                id: completed
                palette.button: "blue"
                Layout.minimumHeight: 40
                Layout.minimumWidth: 100
                Text {
                    text: qsTr("Completed")
                    anchors.centerIn: parent
                }
                onClicked: {
                    completedVar = true
                    activeVar = false
                }
            }
            Button {
                id: active
                palette.button: "blue"
                Layout.minimumHeight: 40
                Layout.minimumWidth: 100
                Text {
                    text: qsTr("Active")
                    anchors.centerIn: parent
                }
                onClicked: {
                    activeVar = true
                    completedVar = false
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            width: parent.width
            spacing: 15
            Layout.margins: 10
            Text {
                id: totalCount
                font.pixelSize: 22
                property int totalTasks: 1
                text: qsTr("Total: " + totalTasks)
            }
            Text {
                id:completedCount
                font.pixelSize: 22
                property int completedTasks: 0
                text: qsTr("Completed: " + completedTasks)
            }
            Text {
                id: remainingCount
                font.pixelSize: 22
                property int remainingTasks: 1
                text: qsTr("Remaining: " + remainingTasks)
            }
        }

        ListView {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: listmodel
            delegate: listDelegate
            width: parent.width
        }

        RowLayout {
            id: modifyButtons
            Layout.alignment: Qt.AlignHCenter
            anchors.bottom: window.bottom
            width: parent.width
            Button {
                palette.button: "skyblue"
                Layout.minimumHeight: 40
                Layout.minimumWidth: 100
                text: "Add task"
                onClicked: {
                    addDialog.open()
                }
            }
            Button {
                palette.button: "skyblue"
                Layout.minimumHeight: 40
                Layout.minimumWidth: 100
                text: "Remove task"
                onClicked: {
                    removeDialog.open()
                }
            }
            Button {
                palette.button: "skyblue"
                Layout.minimumHeight: 40
                Layout.minimumWidth: 100
                text: "Edit task"
                onClicked: {
                    editDialog.open()
                }
            }
        }
    }
    Component {
        id: listDelegate
        Rectangle {
            visible: {
                if(completedVar && model.completed) return true
                if(activeVar && !model.completed) return true
                return false
            }

            width: componentLayout.width
            height: componentLayout.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "grey"
            radius: 8
            border.width: 1
            border.color: "black"
            RowLayout {
                id: componentLayout
                Layout.alignment: Qt.AlignHCenter
                spacing: 15
                CheckBox {
                    checked: completed
                    onCheckedChanged: {
                        if(completed === true) {
                            completed = false
                            completedCount.completedTasks -= 1
                            remainingCount.remainingTasks += 1
                        }
                        else {
                            completed = true
                            completedCount.completedTasks += 1
                            remainingCount.remainingTasks -= 1
                        }

                    }

                    text: "Completed"
                    font.pixelSize: 20
                }
                Text {
                    text: title
                    font.pixelSize: 20
                }
                Rectangle {
                    color: priorityColor
                    width: 20
                    height: 20
                }
                Text {
                    text: due_date
                    rightPadding: 15
                    font.pixelSize: 20
                }
            }
        }
    }

    ListModel {
        id: listmodel
    }

    Dialog {
        id: addDialog
        title: "Add New Task"
        width: 450
        height: 300
        standardButtons: Dialog.Ok | Dialog.Cancel

        GridLayout {
            anchors.fill: parent
            columns: 2
            rowSpacing: 15
            columnSpacing: 15
            Label {
                text: "Task Title:"
            }
            TextField {
                id: titleInput
                placeholderText: "Title"
            }

            Label {
                text: "Priority"
            }
            Column {
                RadioButton {
                    id: low
                    checked: true
                    text: "Low"
                }
                RadioButton {
                    id: medium
                    text: "Medium"
                }
                RadioButton {
                    id: high
                    text: "High"
                }
            }

            Label {
                text: "Due Date:"
            }
            TextField {
                id: dateInput
                placeholderText: "YYYY-MM-DD"
            }
        }
        Component.onCompleted: {
            standardButton(Dialog.Ok).enabled = Qt.binding(function() {
                return titleInput.text.trim() !== "" && dateInput.text.trim() !== ""
            })
        }

        onAccepted: {
            var clr = ""
            if(low.checked === true) clr = "green"
            else if(medium.checked === true) clr = "orange"
            else if(high.checked === true) clr = "red"
            listmodel.append({
                title: titleInput.text.trim(),
                completed: false,
                priorityColor: clr,
                due_date: dateInput.text.trim()
            })
            totalCount.totalTasks += 1
            remainingCount.remainingTasks += 1
            titleInput.text = ""
            dateInput.text = ""
        }
    }

    Dialog {
        id: removeDialog
        title: "Remove Task"
        width: 250
        height: 200
        standardButtons: Dialog.Ok | Dialog.Cancel

        RowLayout {
            Label{
                text: "Select the task"
            }
            TextField {
                id: nameInput
                placeholderText: "taskName"
            }
        }

        onAccepted: {
            remove(nameInput.text)
        }
    }

    Dialog {
        id: editDialog
        title: "Edit Task"
        width: 450
        height: 350
        standardButtons: Dialog.Ok | Dialog.Cancel
        property string taskName: ""
        property int taskIndex: 0
        property bool flag: false

        GridLayout {
            anchors.fill: parent
            columns: 2
            rowSpacing: 15
            columnSpacing: 15


            Label {
                text: "Enter the name of the task"
            }
            TextField {
                id: editNameInput
                placeholderText: "Title"
            }
            Button {
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignCenter
                text: "submit"
                onClicked: {
                    editDialog.taskName = editNameInput.text
                    for(var i = 0;  i < listmodel.count; ++i) {
                        var task = listmodel.get(i)
                        if (editDialog.taskName === task.title) {
                            editDialog.flag = true
                            editDialog.taskIndex = i
                        }
                    }
                    if(editDialog.flag == false) {
                        warning.open()
                    }else {
                        editTitleInput.text = listmodel.get(editDialog.taskIndex).title
                        editDateInput.text = listmodel.get(editDialog.taskIndex).due_date
                        edit.text = listmodel.get(editDialog.taskIndex).priorityColor
                    }
                }
            }

            Label {
                text: "Task Title:"
            }
            TextField {
                id: editTitleInput
                placeholderText: "Title"
            }

            Label {
                text: "Priority:"
            }
            Column {
                RadioButton {
                    id: editlow
                    checked: true
                    text: "Low"
                }
                RadioButton {
                    id: editmedium
                    text: "Medium"
                }
                RadioButton {
                    id: edithigh
                    text: "High"
                }
            }

            Label {
                text: "Due Date:"
            }
            TextField {
                id: editDateInput
                placeholderText: "YYYY-MM-DD"
            }
        }
        Component.onCompleted: {
            standardButton(Dialog.Ok).enabled = Qt.binding(function() {
                return editDialog.flag && editTitleInput.text.trim() !== "" && editDateInput.text.trim() !== ""
            })
        }

        onAccepted: {
            var clr = ""
            if(editlow.checked === true) clr = "green"
            else if(editmedium.checked === true) clr = "orange"
            else if(edithigh.checked === true) clr = "red"

            listmodel.get(taskIndex).title = editTitleInput.text.trim()
            listmodel.get(taskIndex).due_date = editDateInput.text.trim()
            listmodel.get(taskIndex).priorityColor = clr

            titleInput.text = ""
            dateInput.text = ""
        }
    }

    MessageDialog {
        id: warning
        text: "No task found"

    }

    function remove(name) {
        var flag = false
        for(var i = 0;  i < listmodel.count; ++i) {
            var task = listmodel.get(i)
            if (name === task.title) {
                flag = true
                totalCount.totalTasks -= 1
                if(task.completed) {
                    completedCount.completedTasks -= 1
                } else {
                    remainingCount.remainingTasks -= 1
                }
                listmodel.remove(i)
            }
        }
        if(flag == false) {
            warning.open()
        }
    }
}


