import 'package:mongo_dart/mongo_dart.dart';
import 'package:student_record/Utils/utils.dart';
import 'package:student_record/student/student.dart';

class MongoDB {
  DbCollection? _studentsCollection;

  final _db = Db("mongodb://localhost:27017/StudentRecord");

  _initialize() async {
    await _db.open();

    if (_db.isConnected) {
      _studentsCollection = _db.collection("students");
    }
  }

  cleanUpDatabase() async {
    await _db.close();
  }

  insert(Student student) async {
    await _initialize();

    await _studentsCollection?.insertOne(student.toMap());
  }

  Future<Student> getStudent(String matric) async {
    await _initialize();

    Map<String, dynamic>? document =
        await _studentsCollection!.findOne(where.eq(Utils().MATRIC, matric));

    return Student.fromMap(document!);
  }

  Future<List<Student>> getAllStudents() async {
    await _initialize();
    List<Map<String, dynamic>> documents = [];

    List<Student> students = [];

    if (_db.state == State.OPEN) {
      documents = await _studentsCollection!.find().toList();

      for (var student in documents) {
        students.add(Student.fromMap(student));
      }
    }
    return students;
  }

  updateStudentRecord(String matric, Student student) async {
    await _initialize();

    await _studentsCollection!
        .replaceOne(where.eq(Utils().MATRIC, matric), student.toMap());
  }

  deleteStudentRecord(String matric) async {
    await _initialize();

    await _studentsCollection!.remove(where.eq(Utils().MATRIC, matric));
  }
}
