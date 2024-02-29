
class EmployeeModel {
  int id;
  String empCode;
  String firstName;
  String? lastName;
  String? nickname;
  String formatName;
  String photo;
  String fullName;
  String? devicePassword;
  String? cardNo;
  DepartmentModel department;

  EmployeeModel({
    required this.id,
    required this.empCode,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.formatName,
    required this.photo,
    required this.fullName,
    required this.devicePassword,
    required this.cardNo,
    required this.department,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      empCode: json['emp_code'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'],
      nickname: json['nickname'],
      formatName: json['format_name'] ?? "",
      photo: json['photo'] ?? "",
      fullName: json['full_name'] ?? "",
      devicePassword: json['device_password'],
      cardNo: json['card_no'],
      department: DepartmentModel.fromJson(json['department']),
    );
  }
}

class DepartmentModel {
  int id;
  String deptCode;
  String deptName;

  DepartmentModel({
    required this.id,
    required this.deptCode,
    required this.deptName,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] ?? 0,
      deptCode: json['dept_code'] ?? "",
      deptName: json['dept_name'] ?? "",
    );
  }
}
