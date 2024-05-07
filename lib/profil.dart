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
      print("HEEEEEEEEEEEEEEEEEEEEEY  ${_profileData['photo']}");
      setState(() {
        _profileData = json.decode(response.body);
      });
    } else {
      setState(() {
        _profileData = {"message": "Token non trouvé ou profil non trouvé"};
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        if (image != null) {
          _image = File(image.path);
        }
      });
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  Future<void> _uploadPhoto() async {
    if (_image == null) {
      print('Aucune photo sélectionnée');
      return;
    }

    final token = await getSharedPreferencesToken();
    final String apiUrl = 'http://192.168.1.17:8000/api/ajouter-photo/$token/';

    // Lecture du contenu de l'image sous forme de bytes
    List<int> imageBytes = await _image!.readAsBytes();

    // Convertir les octets de l'image en base64
    String base64Image = base64Encode(imageBytes);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'photo': base64Image
        }, // Inclure la clé 'photo' avec les octets de l'image encodés en base64
        // headers: {
        //   'Content-Type':
        //       'application/json', // Spécifier le type de contenu comme JSON
        // },
      );

      if (response.statusCode == 200) {
        print('Photo téléchargée avec succès');
        // Mettre à jour l'affichage ou effectuer d'autres actions en fonction de la réponse
      } else {
        print('Échec du téléchargement de la photo: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la demande: $e');
    }
  }

  Widget _buildProfileImage() {
    if (_profileData.containsKey('photo')) {
      print("mriigl");
      print("houni  ${_profileData['photo']}");
      String? base64Image = _profileData['photo'];
      if (base64Image != null) {
        print("mriigl houni");
        Uint8List bytes = base64Decode(base64Image);
        print(bytes);
        return Image.memory(
          bytes,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        );
      }
    }

    return Icon(
      Icons.person,
      size: 50,
      color: Colors.grey[700],
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
                onTap: _takePhoto,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
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
                        return ListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(entry.value.toString()),
                        );
                      }).toList(),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              MaterialButton(
                child: Text("Télécharger votre photo"),
                onPressed: _uploadPhoto,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
