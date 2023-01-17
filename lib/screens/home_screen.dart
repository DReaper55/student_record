import 'package:data_table_2/data_table_2.dart';
import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart' as ft;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_record/database/mongo_db.dart';
import 'package:student_record/screens/create_update_record.dart';
import 'package:student_record/screens/view_record.dart';
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

  bool isRefreshBtnClicked = false;

  @override
  void initState() {
    super.initState();

    loaData();
  }

  DataTableSource _showData(BuildContext context) {
    return MyData.data(data: studentsList, context: context);
  }

  loaData() async {
    MongoDB mongo = MongoDB();

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
    // To refresh the layout
    MongoDB().getAllStudents().then((value) {
      if (isRefreshBtnClicked) {
        setState(() {
          originalStudentsList = value;
          studentsList = value;
          isRefreshBtnClicked = false;
        });
      }

      // For immediate refreshes
      /*setState(() {
        originalStudentsList = value;
        studentsList = value;
        isRefreshBtnClicked = false;
      });*/
    });

    return ft.ScaffoldPage(
      content: LayoutBuilder(
        builder: (context, constraint) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Student ID Card Allocation System",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
            ),

            /*******************************************************
                 * The Student records loaded from the database
                 ********************************/
            Expanded(
              child: SingleChildScrollView(
                child: ft.SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: PaginatedDataTable2(
                    source: _showData(context),
                    controller: _paginatorCtrl,
                    header: const Text(
                      "Student list",
                      style: TextStyle(fontSize: 20),
                    ),
                    columns: const [
                      DataColumn2(label: Text("Full Name"), size: ColumnSize.L),
                      DataColumn2(
                          label: Text("Matric Number"), size: ColumnSize.L),
                      DataColumn2(
                          label: Text("Department"), size: ColumnSize.L),
                      DataColumn2(label: Text("Faculty"), size: ColumnSize.L),
                      DataColumn2(label: Text("Gender"), size: ColumnSize.L),
                      DataColumn2(
                          label: Text("Date Of Birth"), size: ColumnSize.L),
                      DataColumn2(
                          label: Text("isGottenIDCard"), size: ColumnSize.L),
                      DataColumn2(label: Text("Actions"), size: ColumnSize.L),
                    ],
                    horizontalMargin: 10,
                    columnSpacing: 20.0,
                    minWidth: 1000,
                    headingRowHeight: 50.0,
                    autoRowsToHeight: true,
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
                            onPressed: () {
                          _recordSearchCtrl.clear();
                          setState(() {
                            studentsList = originalStudentsList;
                            isRefreshBtnClicked = true;
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
                ),
              ),
            )
          ],
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
  BuildContext? context;

  MyData();

  MyData.data({required this.data, this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow(
        cells: [
          DataCell(Text(data[index].fullName.toString())),
          DataCell(Text(data[index].matricNumber.toString())),
          DataCell(Text(data[index].department.toString())),
          DataCell(Text(data[index].faculty.toString())),
          DataCell(Text(data[index].gender.toString())),
          DataCell(Text(data[index].dateOfBirth.toString())),
          DataCell(Text(data[index].isGottenIDCard.toString())),
          DataCell(
            Row(
              children: [
                Expanded(
                  child: ft.Button(
                    style: ft.ButtonStyle(
                        backgroundColor:
                            ft.ButtonState.all(Colors.lightGreen.shade100)),
                    child: const Text("Edit"),
                    onPressed: () =>
                        Navigator.of(context!).push(CreateUpdateRecordPageBuild(
                      matric: data[index].matricNumber.toString(),
                    )),
                  ),
                ),
                Expanded(
                  child: ft.Button(
                    style: ft.ButtonStyle(
                        backgroundColor:
                            ft.ButtonState.all(Colors.red.shade400)),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => MongoDB().deleteStudentRecord(
                        data[index].matricNumber.toString()),
                  ),
                ),
              ],
            ),
          ),
        ],
        onSelectChanged: (selected) => Navigator.push(
            context!,
            MaterialPageRoute(
                builder: (context) => ViewRecord(student: data[index]))));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
