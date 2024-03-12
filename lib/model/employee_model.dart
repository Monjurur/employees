import 'dart:convert';

class EmployeeModel {
  int? id;
  String? empId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? photo;
  String? email;
  String? department;
  String? description;
  int? createdAt;
  int? lastModified;

  EmployeeModel({
    this.id,
    this.empId,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.photo,
    this.email,
    this.department,
    this.description,
    this.createdAt,
    this.lastModified,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      empId: json['emp_Id'] ?? "",
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'] ?? "",
      photo: json['photo'] ?? "",
      email: json['email'] == null ? "" : json['email'],
      department: json['department'] == null ? '' : json['department'],
      description: json['description'] ?? "",
      createdAt: json['createdAt'] ?? '',
      lastModified: json['lastModified'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emp_id'] = empId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['photo'] = photo;
    data['email'] = email;
    data['department'] = department;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['lastModified'] = lastModified;
    return data;
  }

  Map<String, dynamic> toDBJson() => {
        "id": id,
        "employeeId": empId,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "photo": photo,
        "email": email,
        "department": department,
        "description": description,
        "createdAt": createdAt,
        "lastModified": lastModified,
        "fullObject": json.encode(toJson())
      };
}
