import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _image;
  TextEditingController _groupController = TextEditingController();
  List<String> _numgrs = [];
  String? _selectedNumgr;

  @override
  void initState() {
    super.initState();
    _fetchNumgrs();
  }

  Future<void> _fetchNumgrs() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17:8000/api/admin/getAllNumgr/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _numgrs = List<String>.from(data['numgrs']);
      });
    } else {
      print('Failed to fetch numgrs');
    }
  }

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _selectedNumgr == null) {
      print('Veuillez sélectionner une image et un groupe');
      return;
    }

    var uri = Uri.parse('http://192.168.1.17:8000/api/admin/createEmp/');
    var request = http.MultipartRequest('POST', uri);
    request.fields['group_id'] = _selectedNumgr!;
    request.files.add(await http.MultipartFile.fromPath('photo', _image!.path));

    var response = await request.send();
    if (response.statusCode == 201) {
      print('Image uploaded successfully');
    } else {
      print('Failed to upload image with status ${response.statusCode}');
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
            _image == null
                ? Text('Aucune image sélectionnée')
                : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Sélectionner une image'),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedNumgr,
              onChanged: (newValue) {
                setState(() {
                  _selectedNumgr = newValue;
                });
              },
              items: _numgrs.map((numgr) {
                return DropdownMenuItem<String>(
                  value: numgr,
                  child: Text(numgr),
                );
              }).toList(),
              hint: Text('Sélectionner un groupe'),
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
