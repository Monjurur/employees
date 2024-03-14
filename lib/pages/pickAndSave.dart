import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
  bool hideList = false;

  List<String> listData = [];
  List<Map<String, dynamic>> convertedData = [];
  List<Map<String, dynamic>> getUser = [];
  List<String> recordList = [];

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
    hideList = false;
    sharedPreferences = await SharedPreferences.getInstance();
    await getListData();
    recordList = sharedPreferences.getStringList("EmployeeRecord") ?? [];
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
                      width: width / 2.8,
                      height: height / 5,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              15) // Adjust the radius as needed
                          ),
                      child: images == null
                          ? Image.asset(
                              "assets/images/empty_image.jpg",
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              images!,
                              fit: BoxFit.fill,
                            ),
                    ),
                    const Text(
                      "Profile Image",
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: SizedBox(
                        height: 35,
                        width: width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5, // Add elevation here
                            //padding: EdgeInsets.all(20),
                            backgroundColor: Colors.green,
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
                              Text(
                                "Camera",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Employee Name',
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
                              hintText: 'Employee Full Name',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w300,
                              ),
                              //  border bottom
                            ),
                            onTap: () async {
                              await getData();
                            },
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
                                'Employee Id',
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
                            onChanged: (value) => dataFilter(value),
                            onFieldSubmitted: (value) => dataFilter(value),
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
                              hintText: 'Add Employee Id',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w300,
                              ),
                              //  border bottom
                            ),
                            onTap: () async {
                              await getData();
                              setState(() {});
                            },
                            onEditingComplete: () {
                              setState(() {
                                /*firstNameFocusNode.unfocus();
                            lastNameFocusNode.requestFocus();*/
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    hideList
                        ? const SizedBox()
                        : getUser.isNotEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '*Please Upload .csv File Only',
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 35,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.yellow.shade600,
                                                  elevation:
                                                      8, // Add elevation here
                                                  //padding: EdgeInsets.all(20),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  )),
                                              onPressed: () async {
                                                showAlertDialog(context);

                                              },
                                              child: const Text(
                                                'Re-Upload',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: height / 4,
                                        child: ListView.builder(
                                          itemCount: getUser.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                idController.text =
                                                    getUser[index]
                                                        ["Identifier"];
                                                nameController.text =
                                                    getUser[index]["Username"];
                                                setState(() {
                                                  hideList = true;
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2, bottom: 1),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  margin: EdgeInsets.zero,
                                                  //shadowColor: Colors.blue,
                                                  //color: Colors.grey,
                                                  child: ListTile(
                                                    dense: true,
                                                    //contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    title: Text(
                                                      'Username: ${getUser[index]["Username"]}',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    subtitle: Text(
                                                        'Id: ${getUser[index]["Identifier"]}',
                                                        style: const TextStyle(
                                                            fontSize: 15)),
                                                    trailing: Column(
                                                      children: [
                                                        for (int i = 0;
                                                            i <
                                                                recordList
                                                                    .length;
                                                            i++) ...{
                                                          getUser[index][
                                                                      "Identifier"] ==
                                                                  (recordList[i] ?? '')
                                                              ? const Text(
                                                                  "Image Taken",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,fontSize: 14,fontWeight: FontWeight.bold),
                                                                )
                                                              : const SizedBox(),
                                                        }
                                                      ],
                                                    ),
                                                    //recordList.forEach((element) { })
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                    const SizedBox(
                      height: 30,
                    ),
                    getUser.isNotEmpty
                        ? Center(
                            child: SizedBox(
                              height: 45,
                              width: width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    elevation: 8, // Add elevation here
                                    //padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                onPressed: () async {
                                  List<String> recordList = sharedPreferences
                                          .getStringList("EmployeeRecord")
                                          ?.toList() ??
                                      [];
                                  if (formKey.currentState!.validate()) {
                                    if (imagePath != null) {
                                      saveImageToGallery(
                                          imagePath!,
                                          idController.text,
                                          nameController.text);
                                      if(recordList.contains(idController.text)){
                                        recordList.remove(idController.text);
                                      }
                                      recordList.add(idController.text);
                                      sharedPreferences.setStringList(
                                          "EmployeeRecord", recordList);
                                      await getData();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        backgroundColor:
                                            Colors.deepOrangeAccent,
                                        content: Text("Pick Image Please"),
                                      ));
                                    }
                                  }
                                },
                                child: const Text(
                                  'Save Image',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    getUser.isEmpty
                        ? Center(
                            child: SizedBox(
                              //height: 35,
                              width: width / 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    elevation: 5, // Add elevation here
                                    //padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    )),
                                onPressed: () async {
                                  await pickCSVFile();

                                  await getListData();
                                },
                                child: Column(
                                  children: [
                                    const Text(
                                      'Upload Employee List',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      '*Please Upload .csv File Only',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey.shade300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () async{
        await   sharedPreferences.remove("Employee");
        await pickCSVFile();

        await getListData();
      },
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Upload CSV File !"),
      content: const Text("Would you like to upload the employee list again?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> pickCSVFile() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
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
      List<String> data1 = _data.map((dynamic item) => item.toString())
          .toList();
      List<String> tableData = parseData(data1.toString());
      sharedPreferences.setStringList("Employee", tableData);
      listData = parseData("$_data");
    }catch (e){
      d.log("Error::Pick and CSV File Read:$e");
    }
  }

  void dataFilter(String enteredKeyword) {
    List<Map<String, dynamic>> getUserResult = [];
    if (enteredKeyword.isEmpty) {
      getUserResult = convertedData;
      setState(() {
        hideList = false;
      });
      idController.clear();
    } else {
      // Search for the keyword in convertedData
      getUserResult = convertedData
          .where((element) =>
              element["Username"]
                  .toString()
                  .toUpperCase()
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
          .where((element) =>
              element["Identifier"].toString() ==
              (enteredKeyword.toLowerCase()))
          .toList();
      d.log("$getUserResult");
    }
    setState(() {
      getUser = getUserResult;
    });
  }

  Future<void> getListData() async {
    String dataString = sharedPreferences.getStringList("Employee").toString();
    convertedData = convertToListOfMaps(dataString);
    setState(() {});
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
    if(imagePath.isNotEmpty){
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
  }else{
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Center(child: Text("Pick Image First")),
        ));
      }
    }
  }
}
