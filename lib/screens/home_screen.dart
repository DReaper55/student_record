import 'dart:math';

import 'package:data_table_2/paginated_data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart';
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
  DataTableSource _data = MyData();

  List<Map<String, Object>> stuffList = [];

  final TextEditingController _recordSearchCtrl = TextEditingController();
  final PaginatorController _paginatorCtrl = PaginatorController();

  @override
  void initState() {
    super.initState();

    loaData();

    _data = MyData.data(stuffList);

    // print(MyData().data[3]['id']);
  }

  loaData() async {
    stuffList = List.generate(
        200,
        (index) => {
              "id": index,
              "title": "Item: $index",
              "price": Random().nextInt(10000),
            });

    MongoDB mongo = MongoDB();

    await mongo.insert(Student.build(
        "12/12/1212",
        "Quantum Mechanics",
        "C:\\Users\\DANIEL UWADI\\Pictures\\face14.jpg",
        "Physical Science",
        "Matilda Hesmond",
        "Female",
        "False",
        "16/1122334"));

    // await mongo.updateStudentRecord(
    //     "16/1122334",
    //     Student.build(
    //         "12/12/1212",
    //         "Quantum Physics",
    //         "C:\\Users\\DANIEL UWADI\\Pictures\\face14.jpg",
    //         "Physical Sciences",
    //         "Matilda Simeon",
    //         "Female",
    //         "False",
    //         "16/1122334"));

    // await mongo.deleteStudentRecord("16/1122334");

    Student student = await mongo.getStudent("17/095244112");
    print(student.fullName);

    // List<Student> documents = await mongo.getAllStudents();
    // for (var element in documents) {
    //   print(element.fullName);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
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
                // Container(
                //   margin: const EdgeInsets.all(10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       ElevatedButton(
                //           onPressed: () => print("New"),
                //           child: const Text("New"),
                //           style: const ButtonStyle(
                //             alignment: Alignment.center,
                //             // minimumSize: MaterialStateProperty.all(Size(20, 20)),
                //             // backgroundColor:
                //             //     MaterialStateProperty.all<Color>(Colors.blue),
                //           )),
                //       ElevatedButton(
                //         onPressed: () => print("Search"),
                //         child: const Text("Search"),
                //         style: const ButtonStyle(alignment: Alignment.center),
                //       ),
                //     ],
                //   ),
                // ),

                /*******************************************************
                     * The Student records loaded from the database
                     ********************************/
                SizedBox(
                  height: constraint.maxHeight - 50.0,
                  child: PaginatedDataTable2(
                    source: _data,
                    controller: _paginatorCtrl,
                    header: const Text(
                      "Student list",
                      style: TextStyle(fontSize: 20),
                    ),
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Title")),
                      DataColumn(label: Text("Price")),
                      DataColumn(label: Text("Actions")),
                    ],
                    columnSpacing: 100,
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
                        onPressed: () {
                          _recordSearchCtrl.clear();
                          setState(() {
                            _data = MyData.data(stuffList);
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
  filterList(String value) {
    for (var element in stuffList) {
      if (element['id'].toString() == value) {
        print(element['id']);

        setState(() {
          _data = MyData.data([element]);
        });
      }
    }
  }
}

class MyData extends DataTableSource {
  List<Map<String, Object>> data = [];

  MyData();

  MyData.data(List<Map<String, Object>> data) {
    this.data = data;
  }

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index]['id'].toString())),
      DataCell(Text(data[index]['title'].toString())),
      DataCell(Text(data[index]['price'].toString())),
      DataCell(Row(
        children: [
          Button(
            child: const Text("Delete"),
            onPressed: () => print("Delete item with id ${data[index]['id']}"),
          ),
          Button(
            child: const Text("New"),
            onPressed: () => print("Create new item at $index"),
          )
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
