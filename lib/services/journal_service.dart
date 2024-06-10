import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';
import 'http_interceptors.dart';

class JournalService {
  //TODO: Modularizar o endpoint;
  static const String url = "http://10.1.9.107:3000/";
  //static const String url = "http://192.168.15.37:3000/";

  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

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

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUri()}$id"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: journalJSON,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
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
      //TODO: Criar uma exceção personalizada
      throw Exception();
    }

    List<Journal> result = [];

    List<dynamic> jsonList = json.decode(response.body);
    for (var jsonMap in jsonList) {
      result.add(Journal.fromMap(jsonMap));
    }

    return result;
  }

  Future<bool> delete(String id) async {
    http.Response response = await client.delete(
      Uri.parse("${getUri()}$id"),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
