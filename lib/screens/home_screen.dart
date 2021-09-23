import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart' as ft;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_record/database/mongo_db.dart';
import 'package:student_record/screens/create_update_record.dart';
import 'package:student_record/student/student.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Student> studentsList = [];
  List<Student> originalStudentsList = [];

  final TextEditingController _recordSearchCtrl = TextEditingController();
  final PaginatorController _paginatorCtrl = PaginatorController();

  @override
  void initState() {
    super.initState();

    loaData();
  }

  DataTableSource _showData() {
    return MyData.data(studentsList);
  }

  loaData() async {
    MongoDB mongo = MongoDB();

    /*await mongo.insert(Student.build(
        "12/12/1212",
        "Quantum Mechanics",
        "C:\\Users\\DANIEL UWADI\\Pictures\\face14.jpg",
        "Physical Science",
        "Matilda Hesmond",
        "Female",
        "False",
        "16/1122334"));*/

    /*await mongo.updateStudentRecord(
        "16/1122334",
        Student.build(
            "12/12/1212",
            "Quantum Physics",
            "C:\\Users\\DANIEL UWADI\\Pictures\\face14.jpg",
            "Physical Sciences",
            "Matilda Simeon",
            "Female",
            "False",
            "16/1122334"));*/

    // await mongo.deleteStudentRecord("16/1122334");

    // Student student = await mongo.getStudent("17/095244112");
    // print(student.fullName);

    List<Student> studentsList = await mongo.getAllStudents();
    for (var student in studentsList) {
      this.studentsList.add(student);
      originalStudentsList.add(student);
      print(student.fullName);
    }

    mongo.cleanUpDatabase();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted == true) {
      MongoDB().getAllStudents().then((value) => originalStudentsList = value);
    }

    return ft.ScaffoldPage(
      content: LayoutBuilder(
        builder: (context, constraint) => Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Student ID Card Allocation System",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
                ),

                /*******************************************************
                     * The Student records loaded from the database
                     ********************************/
                SizedBox(
                  height: constraint.maxHeight - 50.0,
                  child: PaginatedDataTable2(
                    source: _showData(),
                    controller: _paginatorCtrl,
                    header: const Text(
                      "Student list",
                      style: TextStyle(fontSize: 20),
                    ),
                    columns: const [
                      DataColumn(label: Text("Full Name")),
                      DataColumn(label: Text("Matric Number")),
                      DataColumn(label: Text("Department")),
                      DataColumn(label: Text("Faculty")),
                      DataColumn(label: Text("Gender")),
                      DataColumn(label: Text("Date Of Birth")),
                      DataColumn(label: Text("isGottenIDCard")),
                      DataColumn(label: Text("Actions")),
                    ],
                    horizontalMargin: 10,
                    headingRowHeight: 50.0,
                    empty: const Center(
                        child: Text(
                      "No record in the database",
                      style: TextStyle(fontSize: 20),
                    )),
                    rowsPerPage:
                        ((constraint.maxHeight - 50.0 - 30.0 - 50.0) ~/ 60.0)
                            .toInt(),
                    showCheckboxColumn: false,
                    actions: [
                      Container(
                        width: 200,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(5),
                        child: TextFormField(
                          controller: _recordSearchCtrl,
                          decoration: const InputDecoration(
                            hintText: "Search by matric number",
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(10.0))
                          ),
                          onFieldSubmitted: (value) {
                            filterList(value);
                            _paginatorCtrl.goToFirstPage();
                            // _paginatorCtrl.goToRow(int.parse(value));
                          },
                        ),
                      ),
                      /*****************************************
                           * Refresh and New button
                           ***************************/
                      ElevatedButton(
                        onPressed: () async {
                          _recordSearchCtrl.clear();
                          setState(() {
                            studentsList = originalStudentsList;
                          });
                        },
                        child: const Text("Refresh"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .push(CreateUpdateRecordPageBuild()),
                        child: const Text("New"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Filter the list to return and show search query
  filterList(String matricNumber) {
    for (Student student in studentsList) {
      if (student.matricNumber == matricNumber) {
        setState(() {
          studentsList = [student];
        });
      }
    }
  }
}

class MyData extends DataTableSource {
  List<Student> data = [];

  MyData();

  MyData.data(this.data);

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index].fullName.toString())),
      DataCell(Text(data[index].matricNumber.toString())),
      DataCell(Text(data[index].department.toString())),
      DataCell(Text(data[index].fullName.toString())),
      DataCell(Text(data[index].gender.toString())),
      DataCell(Text(data[index].dateOfBirth.toString())),
      DataCell(Text(data[index].isGottenIDCard.toString())),
      DataCell(Row(
        children: [
          ft.Button(
            style: ft.ButtonStyle(
                backgroundColor:
                    ft.ButtonState.all(Colors.lightGreen.shade100)),
            child: const Text("Edit"),
            onPressed: () => print("Create new item at $index"),
          ),
          ft.Button(
            style: ft.ButtonStyle(
                backgroundColor: ft.ButtonState.all(Colors.red.shade400)),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () =>
                print("Delete item with id ${data[index].fullName}"),
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
