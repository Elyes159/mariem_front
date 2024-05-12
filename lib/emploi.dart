import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Emploi extends StatefulWidget {
  const Emploi({Key? key}) : super(key: key);

  @override
  _EmploiState createState() => _EmploiState();
}

class _EmploiState extends State<Emploi> {
  List<String> _photoUrls = [];

  Future<String?> getSharedPreferencesToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  List<Uint8List> _photoData = [];
  Future<void> getPhotosByGroupId(String groupId) async {
    final url = Uri.parse("http://192.168.1.17:8000/api/getemp/$groupId/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['photos'];
      setState(() {
        _photoData = data
            .map<Uint8List>((photo) => base64.decode(photo['photo']))
            .toList();
      });
    } else {
      print('Failed to load photos: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    final String? groupId = await getGroupId();
    if (groupId != null) {
      await getPhotosByGroupId(groupId);
    }
  }

  Future<String?> getGroupId() async {
    final String? token = await getSharedPreferencesToken();
    final url = Uri.parse('http://192.168.1.17:8000/api/getgroupid/$token/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] != null && data['message'] is Map) {
          return data['message']['group_id'];
        } else {
          print('Unexpected response format: $data');
          return null;
        }
      } else {
        print('Error fetching group ID: ${response.statusCode}');
        return null;
      }
    } on Exception catch (e) {
      print('Error fetching group ID: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20.0,
        titleTextStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shadowColor: Colors.green,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Emploi"),
      ),
      body: _photoData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _photoData.length,
              itemBuilder: (context, index) {
                return Image.memory(_photoData[index]);
              },
            ),
    );
  }
}
