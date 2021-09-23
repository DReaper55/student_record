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
    matricNumber = list[utils.MATRIC];
    isGottenIDCard = list[utils.ISGOTTENIDCARD];
    gender = list[utils.GENDER];
    fullName = list[utils.FULLNAME];
    faculty = list[utils.FACULTY];
    displayPic = list[utils.DISPLAYPICTURE];
    dateOfBirth = list[utils.DATEOFBIRTH];
    department = list[utils.DEPARTMENT];
  }

  Map<String, dynamic> toMap() {
    Utils utils = Utils();
    return {
      utils.DEPARTMENT: department,
      utils.DATEOFBIRTH: dateOfBirth,
      utils.DISPLAYPICTURE: displayPic,
      utils.FACULTY: faculty,
      utils.FULLNAME: fullName,
      utils.GENDER: gender,
      utils.ISGOTTENIDCARD: isGottenIDCard,
      utils.MATRIC: matricNumber
    };
  }
}
