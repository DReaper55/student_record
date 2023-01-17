import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:student_record/database/mongo_db.dart';
import 'package:student_record/student/student.dart';

class ViewRecord extends StatefulWidget {
  final Student student;

  const ViewRecord({Key? key, required this.student}) : super(key: key);

  @override
  _ViewRecordState createState() => _ViewRecordState();
}

class _ViewRecordState extends State<ViewRecord> {
  final List<String> genderRadioBtn = ['Male', 'Female'];
  List<Student> students = [];
  Student currentStudent = Student();

  int index = 0;

  @override
  void initState() {
    super.initState();

    currentStudent = widget.student;

    print(widget.student.fullName);
  }

  loadRecords() async {
    students = await MongoDB().getAllStudents();

    for (int i = 0; i < students.length; i++) {
      if (students[i].matricNumber == currentStudent.matricNumber) {
        index = i;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      loadRecords();
    }

    return ScaffoldPage(
      header: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FluentIcons.back)),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(
                            File(currentStudent.displayPic.toString())),
                        fit: BoxFit.cover),
                    border: Border.all(width: 2.0, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                  width: 500,
                  child: TextBox(
                    style: const TextStyle(fontSize: 18),
                    controller: TextEditingController(
                        text: currentStudent.fullName.toString()),
                    minHeight: 40,
                    maxLines: 1,
                    enabled: false,
                    readOnly: true,
                    expands: false,
                    textAlignVertical: TextAlignVertical.center,
                    outsidePrefix: Container(
                        margin: const EdgeInsets.only(right: 50.0),
                        child: const Text(
                          "Full name",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                  width: 500,
                  child: TextBox(
                    controller: TextEditingController(
                        text: currentStudent.matricNumber.toString()),
                    readOnly: true,
                    enabled: false,
                    style: const TextStyle(fontSize: 18),
                    minHeight: 40,
                    maxLines: 1,
                    expands: false,
                    textAlignVertical: TextAlignVertical.center,
                    outsidePrefix: Container(
                        margin: const EdgeInsets.only(right: 60.0),
                        child: const Text(
                          "Matric",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                  width: 500,
                  child: TextBox(
                    controller: TextEditingController(
                        text: currentStudent.department.toString()),
                    readOnly: true,
                    enabled: false,
                    style: const TextStyle(fontSize: 18),
                    minHeight: 40,
                    maxLines: 1,
                    expands: false,
                    textAlignVertical: TextAlignVertical.center,
                    outsidePrefix: Container(
                        margin: const EdgeInsets.only(right: 40.0),
                        child: const Text(
                          "Department",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                  width: 500,
                  child: TextBox(
                    controller: TextEditingController(
                        text: currentStudent.faculty.toString()),
                    readOnly: true,
                    enabled: false,
                    style: const TextStyle(fontSize: 18),
                    minHeight: 40,
                    maxLines: 1,
                    expands: false,
                    textAlignVertical: TextAlignVertical.center,
                    outsidePrefix: Container(
                        margin: const EdgeInsets.only(right: 60.0),
                        child: const Text(
                          "Faculty",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ),
                Container(
                  width: 200,
                  margin: const EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 0.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        genderRadioBtn.length,
                        (index) => RadioButton(
                            content: Text(
                              genderRadioBtn[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                            checked:
                                (currentStudent.gender == "Male" ? 0 : 1) ==
                                    index,
                            onChanged: (check) => setState(() {
                                  index =
                                      currentStudent.gender == "Male" ? 0 : 1;
                                })),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 0.0),
                  width: 400,
                  child: DatePicker(
                    selected:
                        DateTime.parse(currentStudent.dateOfBirth.toString()),
                    header: "Date of birth",
                    headerStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      height: 50.0,
                      width: 150.0,
                      child: Button(
                        style: ButtonStyle(
                            backgroundColor:
                                ButtonState.all(Colors.blue.lighter)),
                        onPressed: showPreviousRecord,
                        child: const Center(
                            child: Text(
                          "<- Previous",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        )),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      height: 50.0,
                      width: 150.0,
                      child: Button(
                        style: ButtonStyle(
                            backgroundColor:
                                ButtonState.all(Colors.blue.lighter)),
                        onPressed: showNextRecord,
                        child: const Center(
                            child: Text(
                          "Next ->",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        )),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      height: 50.0,
                      width: 150.0,
                      child: Button(
                        style: ButtonStyle(
                            backgroundColor:
                                ButtonState.all(Colors.blue.lighter)),
                        onPressed: _printIDCard,
                        child: const Center(
                            child: Text(
                          "[Generate]",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPreviousRecord() {
    if (index != 0) {
      setState(() {
        currentStudent = students[index - 1];
        index--;
      });
    }
  }

  showNextRecord() {
    if (index < students.length - 1) {
      setState(() {
        currentStudent = students[index + 1];
        index++;
      });
    }
  }

  _printIDCard() async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: pw.Text("Yooo"));
        }));
    /*PdfPreview(
      build: (format) => doc.save(),
    );*/

    await showDialog(
        context: context,
        builder: (builder) => const mt.AlertDialog(
              content: Text("Stuff"),
            ));

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

// _generatIDCard(pw.Document )
}
