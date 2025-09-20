class HelperService{

  static Map<String, String> buildHeaders(Uri uri, {bool isJson = true}) {
    Map<String, String> headers = {
      if (isJson) "Accept": "application/json",
      if (isJson) "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Referrer-Policy": "unsafe-url",
      "x-api-key": "reqres-free-v1"
    };

    // if (Global.accessToken != null) {
    //   String token = Global.accessToken!;
    //   headers['Authorization'] = 'Bearer $token';
    // }
    return headers;
  }

}