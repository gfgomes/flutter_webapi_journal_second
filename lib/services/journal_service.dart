import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_second_course/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';
import 'http_interceptors.dart';

class JournalService {
  //TODO: Modularizar o endpoint;
  static const String url = "http://10.1.9.107:3000/";
  //static const String url = "http://192.168.15.37:3000/";

  static const String resource = "journals/";

  http.Client client = WebClient().client;

  String getURL() {
    return "$url$resource";
  }

  String getBaseURL() {
    return "$url";
  }

  Uri getUri() {
    return Uri.parse(getURL());
  }

  Uri getUriWithParams(String url) {
    return Uri.parse(url);
  }

  Uri getBaseUri() {
    return Uri.parse(getBaseURL());
  }

  Future<bool> register(Journal journal, String token) async {
    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.post(
      getUri(),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: journalJSON,
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    return true;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    //Seta a nova data de atualização
    journal.updatedAt = DateTime.now();

    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUri()}$id"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: journalJSON,
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    return true;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    print("Get all uri: ${url}users/${id}/journals");

    http.Response response = await client.get(
      Uri.parse(
        "${url}users/${id}/journals",
      ),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    List<Journal> result = [];

    List<dynamic> jsonList = json.decode(response.body);
    for (var jsonMap in jsonList) {
      result.add(Journal.fromMap(jsonMap));
    }

    return result;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await client.delete(
      Uri.parse("${getUri()}$id"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    return true;
  }
}

class TokenNotValidException implements Exception {}
