import 'dart:convert';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'package:employees/database/database.dart';
import 'package:employees/database/db_service.dart';
import 'package:employees/model/employee_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:employees/database/database.dart' as database;

import 'dart:typed_data';



class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  int id = 0;
  File? _images ;
  String imageBase64 = "";
  EmployeeModel employee = EmployeeModel();
  late SharedPreferences sharedPreferences;
  List<String> employeeList = [];
  late database.Database _db;
  GlobalKey _globalKey = GlobalKey();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  Future<void> cameraImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(image!=null) {
        _images = File(image.path);
      }
    });
  }


  _saveLocalImage() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
    await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
    }
  }

  Future<void> data()async {
       DateTime  current = DateTime.now();
       id++;
       imageBase64  = base64Encode(File(_images!.path).readAsBytesSync());
          sharedPreferences = await SharedPreferences.getInstance();
       employee.id = id;
       employee.empId ="Emp$id";
       employee.firstName = firstNameController.text;
       employee.lastName = lastNameController.text;
       employee.phoneNumber= phoneNumberController.text;
       employee.photo = imageBase64;
       employee.description = descriptionController.text;
       employee.createdAt = current.millisecondsSinceEpoch;
       employee.lastModified = current.millisecondsSinceEpoch;
       print(employee);
       /*String user = jsonEncode(employee);
       employeeList.add(user);
       sharedPreferences.setStringList("User",employeeList);*/
    //int saved = _db.saveEmployee(database.Employee.fromJson(employee)) as int
       int saved = await _db
           .saveEmployee(database.Employee.fromJson(employee.toDBJson()));
       print(saved);


  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = DatabaseService().db;
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: width/2,
                  height: height/4,
                  clipBehavior: Clip.antiAlias,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(15) // Adjust the radius as needed
                  ),
                  child:_images == null? Image.asset("assets/images/person.jpg",fit: BoxFit.cover,): Image.file(_images!,fit: BoxFit.cover,),
                ),
                const Text("Profile Image",style: TextStyle(fontSize: 25),),

                const Row(
                  children: [
                    Text(
                      'First Name',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            
            
                TextFormField(
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  //focusNode: firstNameFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add First Name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                    //  border bottom
                  ),
                  onTap: () {},
                  onEditingComplete: () {
                    setState(() {
                      /*firstNameFocusNode.unfocus();
                      lastNameFocusNode.requestFocus();*/
                    });
                  },
                ),
                const SizedBox(height: 10,),
                const Row(
                  children: [
                    Text(
                      'Last Name',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  //focusNode: firstNameFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add Last Name',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                    //  border bottom
                  ),
                  onTap: () {},
                  onEditingComplete: () {
                    setState(() {
                      /*firstNameFocusNode.unfocus();
                      lastNameFocusNode.requestFocus();*/
                    });
                  },
                ),
                const SizedBox(height: 10,),
                const Row(
                  children: [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  //focusNode: firstNameFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Phone Number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add Phone Number',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                    //  border bottom
                  ),
                  onTap: () {},
                  onEditingComplete: () {
                    setState(() {
                      /*firstNameFocusNode.unfocus();
                      lastNameFocusNode.requestFocus();*/
                    });
                  },
                ),
                const SizedBox(height: 10,),
                const Row(
                  children: [
                    Text(
                      'Add Description',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: 'Add Description if you need',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: ()async {
                 await  data();
                    //print(imageBase64);
                  },
                  child: const Text('Elevated Button'),
                ),
                FloatingActionButton.small(
                  onPressed: () {
                    cameraImage();
                  },
                  child: const Icon(Icons.camera),
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
