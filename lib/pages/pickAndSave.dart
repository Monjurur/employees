import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:employees/pages/table.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as d;
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickAndSave extends StatefulWidget {
  const PickAndSave({super.key});

  @override
  State<PickAndSave> createState() => _PickAndSaveState();
}

class _PickAndSaveState extends State<PickAndSave> {
  String? imagePath;
  var pickedFile;
  bool permission = false;
  var images;
  final picker = ImagePicker();
  String selectedOption = 'All';

  List<dynamic> _data = [];
  String? filePath;

  List<String> listData = [];
  List<Map<String, dynamic>> convertedData = [];
  List<Map<String, dynamic>> getUser = [];

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode idFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async {
    sharedPreferences = await SharedPreferences.getInstance();
  await  getListData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      width: width / 2,
                      height: height / 4,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              15) // Adjust the radius as needed
                          ),
                      child: images == null
                          ? Image.asset(
                              "assets/images/empty_image.jpg",
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              images!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const Text(
                      "Profile Image",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: SizedBox(
                        height: 45,
                        width: width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5, // Add elevation here
                            //padding: EdgeInsets.all(20),
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await requestStoragePermission();

                              imagePath = await pickAndSaveImage();

                              setState(() {});
                            } catch (e) {
                              d.log(
                                  "Error[Request Permission and Camera Open]:",
                                  error: e);
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Camera"),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.camera_alt)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Full Name',
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
                      onChanged: (value) => dataFilter(value),
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      focusNode: nameFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add full Name',
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Id',
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
                      controller: idController,
                      onFieldSubmitted: (value) => dataFilterById(value),
                      keyboardType: TextInputType.name,
                      focusNode: idFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Id';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add Id',
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
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    /* listData.isEmpty
                        ? Container()
                        : Center(
                            child: CustomTable(
                              tdata: _data,
                            ),
                          ),*/
                    getUser.isNotEmpty
                        ? SizedBox(
                            //color: Colors.lightBlueAccent,
                            height: height / 5,
                            child: ListView.builder(
                              itemCount: getUser.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    idController.text =
                                        getUser[index]["Identifier"];
                                    nameController.text =
                                        getUser[index]["Username"];
                                    setState(() {
                                      getUser = [];
                                    });
                                  },
                                  child: Card(
                                    shadowColor: Colors.grey,
                                    child: ListTile(
                                      title: Text(
                                          'Username: ${getUser[index]["Username"]}'),
                                      subtitle: Text(
                                          'Id: ${getUser[index]["Identifier"]}'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: SizedBox(
                        height: 45,
                        width: width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 8, // Add elevation here
                            //padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )
                          ),
                          onPressed: () async {
                             if (formKey.currentState!.validate()) {
                              if (imagePath != null) {
                                saveImageToGallery(imagePath!, idController.text,
                                    nameController.text);
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  content: Text("Pick Image Please"),
                                ));
                              }
                            }
                          },
                          child: const Text('Save Image'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: SizedBox(
                        height: 45,
                        width: width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 8, // Add elevation here
                            //padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )
                          ),
                          onPressed: () async {
                            await pickCSVFile();

                            await getListData();
                          },
                          child: const Text('CSV File Upload'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickCSVFile() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) result;
    print(result!.files.first.name);
    filePath = result.files.first.path;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);
    setState(() {
      _data = fields;
    });
    List<String> data1 = _data.map((dynamic item) => item.toString()).toList();
    List<String> tableData = parseData(data1.toString());
    sharedPreferences.setStringList("Employee", tableData);
    listData = parseData("$_data");
  }

  void dataFilter(String enteredKeyword) {
    List<Map<String, dynamic>> getUserResult = [];
    if (enteredKeyword.isEmpty) {
      getUserResult = convertedData;
      setState(() {});
      idController.clear();
    } else {
      // Search for the keyword in convertedData
      getUserResult = convertedData
          .where((element) =>
              element["Username"]
                  .toString().toUpperCase()
                  .contains(enteredKeyword.toUpperCase()) ||
              element["Identifier"]
                  .toString()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      print(getUserResult);
    }
    setState(() {
      getUser = getUserResult;
    });
  }
  void dataFilterById(String enteredKeyword) {
    List<Map<String, dynamic>> getUserResult = [];
    if (enteredKeyword.isEmpty) {
      getUserResult = convertedData;
      setState(() {});
      idController.clear();
    } else {
      // Search for the keyword in convertedData
      getUserResult = convertedData
          .where((element) => element["Identifier"].toString()==(enteredKeyword.toLowerCase()))
          .toList();
      print(getUserResult);
    }
    setState(() {
      getUser = getUserResult;
    });
  }

  Future<void> getListData() async {
    String dataString = sharedPreferences.getStringList("Employee").toString();
    convertedData = convertToListOfMaps(dataString);
    setState(() {});
    print(convertedData);
    getUser = convertedData;
  }

  List<Map<String, dynamic>> convertToListOfMaps(String dataString) {
    List<List<String>> dataList = parseDataString(dataString);

    List<Map<String, dynamic>> result = [];

    List<String> headers = dataList[0];
    for (int i = 1; i < dataList.length; i++) {
      Map<String, dynamic> entry = {};
      for (int j = 0; j < headers.length; j++) {
        entry[headers[j]] = dataList[i][j];
      }
      result.add(entry);
    }
    return result;
  }

  List<List<String>> parseDataString(String dataString) {
    dataString = dataString.replaceAll("[", "").replaceAll("]", "");
    List<String> splitData = dataString.split(", ");

    List<List<String>> result = [];
    List<String> currentList = [];

    for (String item in splitData) {
      if (item.isNotEmpty) {
        currentList.add(item);
        if (currentList.length == 2) {
          result.add(List.from(currentList));
          currentList.clear();
        }
      }
    }

    return result;
  }

  List<String> parseData(String data) {
    // Remove trailing semicolon and split the string by ';'
    // return data.substring(0, data.length - 1).split(';');
    return data
        .split(RegExp(r'[;\n]'))
        .where((element) => element.isNotEmpty)
        .toList();
  }

  Future<void> requestStoragePermission() async {
    await Permission.camera.request();
    await Permission.storage.request();
    await Permission.photos.request();
  }

  Future<String?> pickAndSaveImage() async {
    try {
      pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 15);
      if (pickedFile == null) {
        return null;
      } else {
        images = File(pickedFile.path);
      }

      final fileName = '${DateTime.now()}.jpg'; // Generate unique name
      final directory = await getApplicationDocumentsDirectory();
      final newPath = '${directory.path}/$fileName';

      // Read bytes from picked file
      final bytes = await pickedFile.readAsBytes();

      // Create a new file with custom name
      final newFile = File(newPath);

      // Write bytes to the new file
      await newFile.writeAsBytes(bytes);

      return newPath; // Return the path of the copied file
    } catch (e) {
      d.log("Error: [Camera Open And Image Pick] :$e");
    }
  }

  Future<void> saveImageToGallery(
      String imagePath, String id, String name) async {
    await ImageGallerySaver.saveFile(imagePath, name: '$id-$name');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.indigoAccent,
        content: Center(child: Text("Save Successfully")),
      ));
    }

    idController.clear();
    nameController.clear();
    imagePath = '';
    images = null;
    idFocusNode.unfocus();
    nameFocusNode.unfocus();
    setState(() {});
  }
}
