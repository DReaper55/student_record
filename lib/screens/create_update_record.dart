import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_record/database/mongo_db.dart';
import 'package:student_record/student/student.dart';

class CreateUpdateRecordPageBuild extends FluentPageRoute {
  CreateUpdateRecordPageBuild()
      : super(builder: (BuildContext context) => const CreateUpdateRecord());

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return HorizontalSlidePageTransition(
      child: const CreateUpdateRecord(),
      animation: animation,
      fromLeft: true,
    );
  }
}

class CreateUpdateRecord extends StatefulWidget {
  const CreateUpdateRecord({Key? key}) : super(key: key);

  @override
  _CreateUpdateRecordState createState() => _CreateUpdateRecordState();
}

class _CreateUpdateRecordState extends State<CreateUpdateRecord> {
  final _fullname = TextEditingController();
  final _matric = TextEditingController();
  final _department = TextEditingController();
  final _faculty = TextEditingController();

  final List<String> genderRadioBtn = ['Male', 'Female'];
  int currentGenderIndex = -1;

  PlatformFile? userImageFile;

  DateTime date = DateTime.now();

  Student student = Student();

  @override
  Widget build(BuildContext context) {
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
                GestureDetector(
                  onTap: _loadUserImage,
                  child: userImageFile == null
                      ? Container(
                          alignment: Alignment.topRight,
                          width: 200,
                          height: 200,
                          child: OutlinedButton(
                              child: const Center(child: Text("Choose image")),
                              onPressed: _loadUserImage),
                        )
                      : Container(
                          alignment: Alignment.topRight,
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(File(userImageFile!.name)),
                                fit: BoxFit.cover),
                            border: Border.all(width: 2.0, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),
                  width: 500,
                  child: TextBox(
                    controller: _fullname,
                    placeholder: "Enter full name",
                    style: const TextStyle(fontSize: 18),
                    minHeight: 40,
                    maxLines: 1,
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
                    controller: _matric,
                    placeholder: "Enter Matric number",
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
                    controller: _department,
                    placeholder: "Name of Department",
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
                    controller: _faculty,
                    placeholder: "Name of Faculty",
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
                            checked: currentGenderIndex == index,
                            onChanged: (check) => setState(() {
                                  currentGenderIndex = index;
                                  print(currentGenderIndex);
                                })),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 0.0),
                  width: 400,
                  child: DatePicker(
                    selected: date,
                    header: "Date of birth",
                    headerStyle: const TextStyle(fontSize: 18),
                    onChanged: (newDate) => setState(() {
                      date = newDate;
                      print(date.toLocal().toString());
                    }),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 50.0,
                  width: 150.0,
                  child: Button(
                    style: ButtonStyle(
                        backgroundColor: ButtonState.all(Colors.blue.lighter)),
                    onPressed: () async => await saveUserDetailsToDB(),
                    child: const Center(
                        child: Text(
                      "Save",
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loadUserImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: ['jpg', 'jpeg', 'png']);

    setState(() {
      userImageFile = result!.files.first;
    });

    print(userImageFile!.path);
  }

  saveUserDetailsToDB() async {
    MongoDB mongo = MongoDB();

    student.dateOfBirth = date.toLocal().toString();
    student.gender = currentGenderIndex == 0 ? "Male" : "Female";
    student.department = _department.value.text;
    student.fullName = _fullname.value.text;
    student.matricNumber = _matric.value.text;
    student.faculty = _faculty.value.text;
    student.displayPic = userImageFile!.path;
    student.isGottenIDCard = "False";

    if (student.dateOfBirth != null &&
        student.gender != null &&
        student.department != null &&
        student.fullName != null &&
        student.matricNumber != null &&
        student.faculty != null &&
        student.isGottenIDCard != null &&
        student.dateOfBirth != null) {
      await mongo.insert(student);
    }

    await mongo.cleanUpDatabase();
    Navigator.pop(context);
  }
}
