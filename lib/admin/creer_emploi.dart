import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  // Initialize _image as null to avoid potential errors
  File? _image = null;
  TextEditingController _groupController = TextEditingController();

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    // Check if _image is not null before using it
    if (_image == null) {
      print('Aucune image sélectionnée');
      return;
    }

    var uri = Uri.parse('http://192.168.1.17:8000/api/admin/createEmp/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['group_id'] = _groupController.text;
    request.files.add(await http.MultipartFile.fromPath('photo', _image!.path));

    var response = await request.send();
    if (response.statusCode == 201) {
      print('Image upload successful');
    } else {
      print('Image upload failed with status ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Use conditional rendering for safety
            _image == null
                ? Text('Aucune image sélectionnée')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Sélectionner une image'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _groupController,
              decoration: InputDecoration(
                labelText: 'ID du groupe',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Télécharger'),
            ),
          ],
        ),
      ),
    );
  }
}
