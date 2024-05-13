import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  TextEditingController _tokenController = TextEditingController();
  Map<String, dynamic> _profileData = {};
  File? _image;
  final picker = ImagePicker();

  Future<String?> getSharedPreferencesToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  Future<void> _consulterProfil() async {
    final token = await getSharedPreferencesToken();
    print("TOOOOOOOOOOOOKE  $token");
    final String apiUrl =
        'http://192.168.1.17:8000/api/consulterprofil/$token/';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        _profileData = json.decode(response.body);
      });
    } else {
      setState(() {
        _profileData = {"message": "Token non trouvé ou profil non trouvé"};
      });
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
    final String? token = await getSharedPreferencesToken();
    // Check if _image is not null before using it
    if (_image == null) {
      print('Aucune image sélectionnée');
      return;
    }
    var uri = Uri.parse('http://192.168.1.17:8000/api/ajouter-photo/$token/');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('photo', _image!.path));
    var response = await request.send();
    if (response.statusCode == 201) {
      print('Image upload successful');
    } else {
      print('Image upload failed with status ${response.statusCode}');
    }
  }

  Widget _buildProfileImage() {
    if (_profileData.containsKey('photo')) {
      String? base64Image = _profileData['photo'];
      if (base64Image != null) {
        Uint8List bytes = base64Decode(base64Image);
        return ClipOval(
          child: Image.memory(
            bytes,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return CircleAvatar(
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.grey[700],
      ),
      radius: 50, // Ajustez le rayon selon vos préférences
      backgroundColor: Colors.grey[300], // Couleur de fond du cercle
    );
  }

  @override
  void initState() {
    super.initState();
    _consulterProfil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: Container(
                  width: 100,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey[200],
                  ),
                  child: _buildProfileImage(),
                ),
              ),
              SizedBox(height: 20.0),
              _profileData.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _profileData.entries.map((entry) {
                        // Vérifier si la clé n'est pas égale à "photo"
                        if (entry.key != "photo") {
                          return ListTile(
                            title: Text(
                              entry.key,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(entry.value.toString()),
                          );
                        } else {
                          return SizedBox.shrink(); // Ne pas afficher la photo
                        }
                      }).toList(),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              MaterialButton(
                child: Text("Télécharger votre photo"),
                onPressed: _uploadImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
