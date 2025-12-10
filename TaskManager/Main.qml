import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    minimumHeight: 600
    minimumWidth: 800
    visible: true
    title: qsTr("Hello World")
    ColumnLayout {
        RowLayout {
            Button {
                id: all
                Text {
                    text: qsTr("All")
                }
                onClicked: {
                    filter("all")
                }
            }
            Button {
                id: completed
                Text {
                    text: qsTr("Completed")
                }
                onClicked: {
                    filter("completed")
                }
            }
            Button {
                id: active
                Text {
                    text: qsTr("Active")
                }
                onClicked: {
                    filter("active")
                }
            }
        }
        RowLayout {
            Text {
                id: totalCouont
                property int totalTasks: 1
                text: qsTr("Total: " + totalTasks)
            }
            Text {
                id:completeCount
                property int completedTasks: 0
                text: qsTr("Completed: " + completedTasks)
            }
            Text {
                id: remainingCount
                property int remainingTasks: 1
                text: qsTr("Remaining: " + remainingTasks)
            }
        }

        ListView {
            height: 500
            model: filtermodel
            delegate: listDelegate
            width: parent.width
        }

        RowLayout {
            Button {
                text: "Add task"
                onClicked: {
                    addDialog.open()
                }
            }
            Button {
                text: "Remove task"
                onClicked: {
                    removeDialog.open()
                }
            }
            Button {
                text: "Edit task"
                onClicked: {
                    editDialog.open()
                }
            }
        }
    }
    Component {
        id: listDelegate
        RowLayout {
            CheckBox {
                checked: check
                text: qsTr("Completed")
            }
            Text {
                text: title
            }
            Rectangle {
                color: Color
                width: 20
                height: 20
            }
            Text {
                text: due_date
            }
        }
    }

    ListModel {
        id: listmodel
        ListElement {
            check: false
            title: "Task1"
            Color: "green"
            due_date: "03-08-2009"
        }
    }

    ListModel {
        id: filtermodel
        ListElement {
            check: false
            title: "Task1"
            Color: "green"
            due_date: "03-08-2009"
        }
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
                text: "Priority:"
            }
            TextField {
                id: priorityInput
                placeholderText: "green, orange, or red"
            }

            Label {
                text: "Due Date:"
            }
            TextField {
                id: dateInput
                placeholderText: "YYYY-MM-DD"
            }
        }
        onAccepted: {
            listmodel.append({
                title: titleInput.text,
                completed: false,
                Color: priorityInput.text,
                due_date: dateInput.text
            })
            filtermodel.append({
                title: titleInput.text,
                completed: false,
                Color: priorityInput.text,
                due_date: dateInput.text
            })
            totalCouont.totalTasks += 1
            remainingCount.remainingTasks += 1
            titleInput.text = ""
            priorityInput.text = ""
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
                placeholderText: "TaskName"
            }
        }

        onAccepted: {
            remove(nameInput.text)
        }
    }

    function filter(button) {
        filtermodel.clear()
        for(var i = 0;  i < listmodel.count; ++i) {
            var task = listmodel.get(i)
            if (button === "all") {
                filtermodel.append(task)
            } else if (button === "active" && !task.check) {
                filtermodel.append(task)
            } else if (button === "completed" && task.ckeck) {
                filtermodel.append(task)
            }
        }
    }

    function remove(name) {
        for(var i = 0;  i < listmodel.count; ++i) {
            var task = listmodel.get(i)
            if (name === task.title) {
                totalCouont.totalTasks -= 1
                if(task.check) {
                    completeCount.completedTasks -= 1
                } else {
                    remainingCount.remainingTasks -= 1
                }

                listmodel.remove(i)
            }
        }
    }
}


