import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper();

  Future pay(XmlDocument xml) async {
    String url = 'https://secure.telr.com/gateway/mobile.xml';
    var data = {xml};
    var body = xml.toString();
    // print('body = $body');

    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        "Content-Type": "application/xml",
        /*"Authentication": "Basic ${base64Encode(utf8.encode('19006:17b7b685Mx54XV7hwTm4BQxt'))}"*/
      },
    );
    // print("Response = ${response.statusCode}");
    // print("Response body = ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 400) {
      return response.body;
    } else {
      return 'failed';
    }
  }

  Future completed(XmlDocument xml) async {
    String url = 'https://secure.telr.com/gateway/mobile_complete.xml';
    var data = {xml};

    var body = xml.toString();
    // print('body = $body');

    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        "Content-Type": "application/xml",
        /*"Authentication": "Basic ${base64Encode(utf8.encode('19006:17b7b685Mx54XV7hwTm4BQxt'))}"*/
      },
    );
    // print("Response = ${response.statusCode}");
    // print("Response body = ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 400) {
      return response.body;
    } else {
      return 'failed';
    }
  }
}