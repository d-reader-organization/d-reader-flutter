import 'package:http/http.dart' as http;

class ApiService {
  static const String API_ENDPOINT = 'https://d-reader-backend.herokuapp.com';

  static Future<String> getInitial() async {
    Uri initialUri = Uri.parse('$API_ENDPOINT/app/hello');
    http.Response response = await http.get(initialUri);
    return response.statusCode == 200 ? response.body : 'An error occured';
  }
}
