import 'package:student_record/Utils/utils.dart';

class Student {
  String? fullName,
      faculty,
      department,
      matricNumber,
      gender,
      dateOfBirth,
      displayPic,
      isGottenIDCard;
  int? id;

  Student();

  Student.build(
      this.dateOfBirth,
      this.department,
      this.displayPic,
      this.faculty,
      this.fullName,
      this.gender,
      this.isGottenIDCard,
      this.matricNumber);

  Student.fromMap(Map<String, dynamic> list) {
    Utils utils = Utils();
    this.matricNumber = list[utils.MATRIC];
    this.isGottenIDCard = list[utils.ISGOTTENIDCARD];
    this.gender = list[utils.GENDER];
    this.fullName = list[utils.FULLNAME];
    this.faculty = list[utils.FACULTY];
    this.displayPic = list[utils.DISPLAYPICTURE];
    this.dateOfBirth = list[utils.DATEOFBIRTH];
    this.department = list[utils.DEPARTMENT];
  }

  Map<String, dynamic> toMap() {
    Utils utils = Utils();
    return {
      utils.DEPARTMENT: this.department,
      utils.DATEOFBIRTH: this.dateOfBirth,
      utils.DISPLAYPICTURE: this.displayPic,
      utils.FACULTY: this.faculty,
      utils.FULLNAME: this.fullName,
      utils.GENDER: this.gender,
      utils.ISGOTTENIDCARD: this.isGottenIDCard,
      utils.MATRIC: this.matricNumber
    };
  }
}
