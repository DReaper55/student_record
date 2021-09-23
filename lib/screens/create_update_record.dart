import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FluentIcons.back)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  outsidePrefix: Container(
                      margin: const EdgeInsets.only(right: 50.0),
                      child: const Text("Full name")),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                width: 500,
                child: TextBox(
                  controller: _matric,
                  placeholder: "Enter Matric number",
                  outsidePrefix: Container(
                      margin: const EdgeInsets.only(right: 60.0),
                      child: const Text("Matric")),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                width: 500,
                child: TextBox(
                  controller: _department,
                  placeholder: "Name of Department",
                  outsidePrefix: Container(
                      margin: const EdgeInsets.only(right: 40.0),
                      child: const Text("Department")),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                width: 500,
                child: TextBox(
                  controller: _faculty,
                  placeholder: "Name of Faculty",
                  outsidePrefix: Container(
                      margin: const EdgeInsets.only(right: 60.0),
                      child: const Text("Faculty")),
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
                          content: Text(genderRadioBtn[index]),
                          checked: currentGenderIndex == index,
                          onChanged: (check) => setState(() {
                                currentGenderIndex = index;
                                print(currentGenderIndex);
                              })),
                    )),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 0.0),
                width: 300,
                child: DatePicker(
                  selected: date,
                  header: "Date of birth",
                  onChanged: (newDate) => setState(() {
                    date = newDate;
                  }),
                ),
              )
            ],
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
}
