import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  File? _images ;

  Future<void> cameraImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(image!=null) {
        _images = File(image.path);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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


          /*            TextFormField(
               // controller: commentController,
                keyboardType: TextInputType.multiline,
               // maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Add comment if you need',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),*/
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
                //controller: firstNameController,
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
              SizedBox(height: 10,),
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
                //controller: firstNameController,
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
               // controller: commentController,
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
    );
  }
}
