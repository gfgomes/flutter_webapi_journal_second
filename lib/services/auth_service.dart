import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_second_course/helpers/uri_helper.dart';
import 'package:flutter_webapi_second_course/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'http_interceptors.dart';

class AuthService {
  //class

//TODO: Modularizar o endpoint;
  //static const String url = "http://10.1.9.107:3000/";
  //static const String resource = "journals/";

  http.Client client = WebClient().client;

  //email: gabriel.fgomes@gmail.com
  //password: 12345
  Future<bool> login({required String email, required String password}) async {
    print(UriHelper.getUri("login"));
    http.Response response = await client.post(UriHelper.getUri("login"),
        body: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      String content = json.decode(response.body);

      switch (content) {
        case "Cannot find user":
          throw UserNotFoundException();
      }

      throw HttpException(response.body);
    }

    saveUserInfos(response.body);

    return true;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    http.Response response = await client.post(UriHelper.getUri("register"),
        body: {'email': email, 'password': password});

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);

    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = json.decode(body);
    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    print("$token\n$email\n$id");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", token);
    prefs.setString("email", email);
    prefs.setInt("id", id);

    String? tokenSalvo = prefs.getString("accessToken");
    print("token salvo no shared preferences: $tokenSalvo");
  }
}

class UserNotFoundException implements Exception {}
