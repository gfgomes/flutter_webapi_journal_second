import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_second_course/helpers/uri_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';
import 'http_interceptors.dart';

class AuthService {
  //class

//TODO: Modularizar o endpoint;
  //static const String url = "http://10.1.9.107:3000/";
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

  //email: gabriel.fgomes@gmail.com
  //password: 12345
  login({required String email, required String password}) async {
    print(UriHelper.getUri("login"));
    http.Response response = await client.post(UriHelper.getUri("login"),
        body: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }
  }

  register(Journal journal) async {}
}
