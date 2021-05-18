import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:votingsystem/src/Widget/registerCandidatePage.dart';
import 'package:votingsystem/src/modules/api.dart';

// class TakePicture extends StatefulWidget {
//   final CameraDescription camera;

//   const TakePicture({
//     Key key,
//     @required this.camera,
//   }) : super(key: key);

//   @override
//   _TakePicture createState() => _TakePicture();
// }

// class _TakePicture extends State<TakePicture> {
//   CameraController _controller;
//   Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       widget.camera,
//       ResolutionPreset.high,
//     );

//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Take a picture'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return CameraPreview(_controller);
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.camera_alt),
//           onPressed: () async {
//             final image = await _controller.takePicture();
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         DisplayPictureScreen(imagePath: image?.path)));
//           }),
//     );
//   }
// }

// class DisplayPictureScreen extends StatefulWidget {
//   final String imagePath;

//   DisplayPictureScreen({
//     Key key,
//     this.imagePath,
//   }) : super(key: key);

//   @override
//   _DisplayPictureScreen createState() => _DisplayPictureScreen();
// }

// class _DisplayPictureScreen extends State<DisplayPictureScreen> {
//   Future<File> _image;
//   String status = '';
//   String base64Image;
//   File tmpFile;
//   String errMessage = "Error uploading image";

//   // getImageFromCamera() {
//   //   var image = ImagePicker.pickImage(source: ImageSource.camera);
//   //   setState(() {
//   //     _image = image;
//   //   });
//   // }

//   setStatus(String message) {
//     setState(() {
//       status = message;
//     });
//   }

//   startUpload(candidateReg) {
//     setStatus('Uploading Image...');
//     if (null == tmpFile) {
//       setStatus(errMessage);
//     }
//     // String fileName = tmpFile.path.split('/').last;
//     upload(candidateReg);
//   }

//   upload(String fileName) {
//     Dio().post(candidateReg, data: {
//       'image': base64Image,
//       'name': fileName,
//     }).then((result) {
//       setStatus(result.statusCode == 200 ? result.data : errMessage);
//     }).catchError((error) {
//       setStatus(error);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final imagePath = widget.imagePath;
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Image.file(File(imagePath)),
//       ),
//       floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.save_alt), onPressed: startUpload(imagePath)),
//     );
//   }
// }

class TakePicture extends StatefulWidget {
  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  static final String uploadEndPoint = '';
  Future<File> _image;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = "Error uploading image";

  // getImagefromcamera() {
  //   var image = ImagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     _image = image;
  //   });
  // }

  getImagefromGallery() {
    var image = ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    Dio().post(candidateReg, data: {
      'image': base64Image,
      'name': fileName,
    }).then((result) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CandidateRegisterPage()));
      setStatus(result.statusCode == 200 ? result.data : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: _image,
      builder: (BuildContext content, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          // print(snapshot.data);
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(child: Image.file(snapshot.data, fit: BoxFit.fill));
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Set a picture"),
      //   backgroundColor: Color(0xff004D40),
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                child: Center(
                  // child: _image == null
                  //     ? Text("No Image is picked")
                  //     : Image.file(_image, height: 400, fit: BoxFit.contain),
                  child: showImage(),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // FloatingActionButton(
                //   onPressed: getImagefromcamera,
                //   tooltip: "pickImage",
                //   child: Icon(Icons.add_a_photo),
                // ),
                FloatingActionButton(
                  onPressed: getImagefromGallery,
                  tooltip: "Pick Image",
                  child: Icon(Icons.camera_alt),
                ),
                FloatingActionButton(
                  onPressed: startUpload,
                  tooltip: "Save info",
                  child: Icon(Icons.save),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ??????????????????????????????????????????????????????????????

// class TakePicture extends StatefulWidget {
//   @override
//   TakePictureState createState() => TakePictureState();
// }

// class TakePictureState extends State {
//   File imageURI;

//   Future getImageFromCamera() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);

//     setState(() {
//       imageURI = image;
//     });
//   }

//   Future getImageFromGallery() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       imageURI = image;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//           imageURI == null
//               ? Text('No image selected.')
//               : Image.file(imageURI,
//                   width: 300, height: 200, fit: BoxFit.cover),
//           Container(
//               margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
//               child: RaisedButton(
//                 onPressed: () => getImageFromCamera(),
//                 child: Text('Click Here To Select Image From Camera'),
//                 textColor: Colors.white,
//                 color: Colors.green,
//                 padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
//               )),
//           Container(
//               margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//               child: RaisedButton(
//                 onPressed: () => getImageFromGallery(),
//                 child: Text('Click Here To Select Image From Gallery'),
//                 textColor: Colors.white,
//                 color: Colors.green,
//                 padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
//               ))
//         ])));
//   }
// }

// //////////////////////////////////////////////////////////////////////
// class TakePicture extends StatefulWidget {
//   TakePicture() : super();

//   final String title = "Flutter Pick Image demo";

//   @override
//   _TakePictureState createState() => _TakePictureState();
// }

// class _TakePictureState extends State<TakePicture> {
//   Future<File> imageFile;

//   pickImageFromGallery(ImageSource source) {
//     setState(() {
//       imageFile = ImagePicker.pickImage(source: source);
//     });
//   }

//   Widget showImage() {
//     return FutureBuilder<File>(
//       future: imageFile,
//       builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             snapshot.data != null) {
//           return Image.file(
//             snapshot.data,
//             width: 300,
//             height: 300,
//           );
//         } else if (snapshot.error != null) {
//           return const Text(
//             'Error Picking Image',
//             textAlign: TextAlign.center,
//           );
//         } else {
//           return const Text(
//             'No Image Selected',
//             textAlign: TextAlign.center,
//           );
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             showImage(),
//             RaisedButton(
//               child: Text("Select Image from Gallery"),
//               onPressed: () {
//                 pickImageFromGallery(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ...................................................................

// class TakePicture extends StatefulWidget {
//   @override
//   _TakePictureState createState() => _TakePictureState();
// }

// File _image;

// class _TakePictureState extends State<TakePicture> {
//   _imgFromCamera() async {
//     File image = await ImagePicker.pickImage(
//         source: ImageSource.camera, imageQuality: 50);

//     setState(() {
//       _image = image;
//     });
//   }

//   _imgFromGallery() async {
//     File image = await ImagePicker.pickImage(
//         source: ImageSource.gallery, imageQuality: 50);

//     setState(() {
//       _image = image;
//     });
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Container(
//               child: new Wrap(
//                 children: <Widget>[
//                   new ListTile(
//                       leading: new Icon(Icons.photo_library),
//                       title: new Text('Photo Library'),
//                       onTap: () {
//                         _imgFromGallery();
//                         Navigator.of(context).pop();
//                       }),
//                   new ListTile(
//                     leading: new Icon(Icons.photo_camera),
//                     title: new Text('Camera'),
//                     onTap: () {
//                       _imgFromCamera();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: <Widget>[
//           SizedBox(
//             height: 32,
//           ),
//           Center(
//             child: GestureDetector(
//               onTap: () {
//                 _showPicker(context);
//               },
//               child: CircleAvatar(
//                 radius: 55,
//                 backgroundColor: Color(0xffFDCF09),
//                 child: _image != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: Image.file(
//                           _image,
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       )
//                     : Container(
//                         decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(50)),
//                         width: 100,
//                         height: 100,
//                         child: Icon(
//                           Icons.camera_alt,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }















// class TakePicture extends StatefulWidget {
//   @override
//   _TakePictureState createState() => _TakePictureState();
// }

// class _TakePictureState extends State<TakePicture> {
//   File _image;
//   Future getImagefromcamera() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() {
//       _image = image;
//     });
//   }

//   Future getImagefromGallery() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = image;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Image Picker Example"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Center(
//             child: Text(
//               "Image Picker Example in Flutter",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: 200.0,
//               child: Center(
//                 child: _image == null
//                     ? Text("No Image is picked")
//                     : Image.file(_image),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               FloatingActionButton(
//                 onPressed: getImagefromcamera,
//                 tooltip: "pickImage",
//                 child: Icon(Icons.add_a_photo),
//               ),
//               FloatingActionButton(
//                 onPressed: getImagefromGallery,
//                 tooltip: "Pick Image",
//                 child: Icon(Icons.camera_alt),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }






// class TakePicture extends StatefulWidget {
//   @override
//   _TakePictureState createState() => _TakePictureState();
// }

// class _TakePictureState extends State<TakePicture> {
//   File _image;
//   Future getImagefromcamera() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.camera);
//     setState(() {
//       _image = image;
//     });
//   }

//   Future getImagefromGallery() async {
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = image;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Image Picker Example"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Center(
//             child: Text(
//               "Image Picker Example in Flutter",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: 200.0,
//               child: Center(
//                 child: _image == null
//                     ? Text("No Image is picked")
//                     : Image.file(_image),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               FloatingActionButton(
//                 onPressed: getImagefromcamera,
//                 tooltip: "pickImage",
//                 child: Icon(Icons.add_a_photo),
//               ),
//               FloatingActionButton(
//                 onPressed: getImagefromGallery,
//                 tooltip: "Pick Image",
//                 child: Icon(Icons.camera_alt),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
