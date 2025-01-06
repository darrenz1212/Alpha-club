import 'package:dio/dio.dart';
import '../model/outlook.dart';

class OutlookService {
  final Dio _dio = Dio();
  final String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  final String _apiKey = 'AIzaSyDRp_GaL5OKzsCRyHU7cpGwq4bh9A0Vq_w';
  final String _prompt = 'give me stock market overview today based on S&P 500 and other index. please search through the newest news to provide me this market outlook. or if you cant provide me with real information, use dummy information for demo purpose';

  Future<Outlook> fetchOutlook() async {
    try {
      final response = await _dio.post(
        '$_geminiApiUrl?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': _prompt}
              ]
            }
          ]
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return Outlook.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch outlook: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching outlook: $e');
    }
  }
}