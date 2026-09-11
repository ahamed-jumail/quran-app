
class Utils {
  static Future<Map<String, String>> getHeader(String? token) async {
    return <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static bool nullOrEmpty(String? token){
    return token == null || token == '';
  }
}
