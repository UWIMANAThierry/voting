import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TakePicture extends StatefulWidget {
  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  File _image;
  Future getImagefromcamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      print(_image);
    });
  }

  Future getImagefromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future saveImagefromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set a picture"),
        backgroundColor: Color(0xff004D40),
      ),
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
                  child: _image == null
                      ? Text("No Image is picked")
                      : Image.file(_image, height: 400, fit: BoxFit.contain),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: getImagefromcamera,
                  tooltip: "pickImage",
                  child: Icon(Icons.add_a_photo),
                ),
                FloatingActionButton(
                  onPressed: getImagefromGallery,
                  tooltip: "Pick Image",
                  child: Icon(Icons.camera_alt),
                ),
                FloatingActionButton(
                  onPressed: saveImagefromGallery,
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
