import 'package:flutter_webapi_second_course/services/http_interceptors.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http/http.dart' as http;

class WebClient {
  //static const String url = "http://10.1.9.107:3000/";
  //static const String url = "http://192.168.15.37:3000/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: const Duration(seconds: 5),
  );
}
