import 'package:http/http.dart';

String apiLink = "https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json";

Future<Response> getUniversities() async{
  return get(Uri.parse(apiLink));
}