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
  List<dynamic> _emplois = [];

  @override
  void initState() {
    super.initState();
    _fetchNumgrs();
    _getEmplois();
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

  Future<void> _getEmplois() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17:8000/api/admin/getemplois/'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _emplois = responseData['emplois'];
      });
    } else {
      print('Échec du chargement des emplois');
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
      _getEmplois(); // Refresh the list of emplois
    } else {
      print('Failed to upload image with status ${response.statusCode}');
    }
  }

  Future<void> _deleteEmploi(String groupId) async {
    final response = await http.delete(
        Uri.parse('http://192.168.1.17:8000/api/admin/deleteemploi/$groupId/'));
    if (response.statusCode == 200) {
      print('Emploi supprimé avec succès');
      _getEmplois(); // Refresh the list of emplois
    } else {
      print('Failed to delete emploi with status ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null
                  ? Text('Aucune image sélectionnée')
                  : Image.file(
                      _image!,
                      height: 100,
                    ),
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
              SizedBox(height: 20),
              Text('Emplois:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _emplois.length,
                itemBuilder: (context, index) {
                  final emploi = _emplois[index];
                  final decodedBytes = base64Decode(emploi['photo']);
                  return Card(
                    child: ListTile(
                      title: Text('Groupe ID: ${emploi['group_id']}'),
                      leading: Image.memory(decodedBytes),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteEmploi(emploi['group_id']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
