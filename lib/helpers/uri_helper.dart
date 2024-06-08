/* 
  print(UriHelper.getBaseURL()); -> http://192.168.15.37:3000/
  print(UriHelper.getResourceURL(resource: ""));-> http://192.168.15.37:3000/
  print(UriHelper.getUri("")); -> http://192.168.15.37:3000/
  print(UriHelper.getUri("login")); -> http://192.168.15.37:3000/login/
  print(UriHelper.getUri("home")); -> http://192.168.15.37:3000/home/
  print(UriHelper.getUriWithId("edit", "1")); -> http://192.168.15.37:3000/edit/1
  print(UriHelper.getUriWithParams("home", {"page": "1"})); -> http://192.168.15.37:3000/home/?page=1
  print(UriHelper.getUriWithIdAndParams("edit", "1", {"page": "1"})); -> http://192.168.15.37:3000/edit/1?page=1
  
  */

class UriHelper {
  static String getBaseURL() {
    //return "http://10.1.9.107:3000/";
    return "http://192.168.15.37:3000/";
  }

  static String getResourceURL({String resource = ""}) {
    if (resource == "") {
      return getBaseURL() + "$resource";
    }
    return getBaseURL() + "$resource/";
  }

  static Uri getUri(String resource) {
    return Uri.parse(getResourceURL(resource: resource));
  }

  static Uri getUriWithId(String resource, String id) {
    return Uri.parse(getResourceURL(resource: resource) + id);
  }

  static Uri getUriWithParams(String resource, Map<String, String> params) {
    Uri uri = Uri.parse(getResourceURL(resource: resource));
    params.forEach((key, value) {
      uri = uri.replace(queryParameters: {key: value});
    });
    return uri;
  }

  static Uri getUriWithIdAndParams(
      String resource, String id, Map<String, String> params) {
    Uri uri = Uri.parse(getResourceURL(resource: resource) + id);
    params.forEach((key, value) {
      uri = uri.replace(queryParameters: {key: value});
    });
    return uri;
  }
}
