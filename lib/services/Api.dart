import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:technical_interview/services/Api_user.dart';

import 'add_user.dart';
import 'api_response.dart';
import 'delete_user.dart';

class ApiManager {
  List data = [];
  var fetchdata = Uri.parse("https://reqres.in/api/users?page=2");

  Future<List<Datum>> fetchData() async {
    var client = http.Client();
    List<Datum> imageModel = [];

    try {
      var response = await client.get(fetchdata);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Enterring here !');
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> imagesList = json['data'];

        imagesList.forEach((image) => imageModel.add(Datum.fromJson(image)));
        print(imagesList.first);
        return imageModel;
      }
    } catch (e) {
      print(e);
    }
    return imageModel;
  }

  Future<UserModel> addData(String name, String jobTitle) async {
    final apiurl = Uri.parse("https://reqres.in/api/users");

    final response = await http.post(apiurl, body: {
      'name': name,
      'job': jobTitle,
    });

    if (response.statusCode == 201) {
      final String responseString = response.body;

      return userModelFromJson(responseString);
    } else {
      return null;
    }
  }

  Future<APIResponse<bool>> deleteNote(String noteID) {
    var apiUrl = Uri.parse(' https://reqres.in/api/users/$noteID');
    return http.delete(apiUrl,
        headers: {'Content-Type': 'application/json'}).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
        APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
}
