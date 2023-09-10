import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiEndpoint = 'https://api.openai.com/v1/chat/completions';
  final String _apiKey =
      ''; // Replace with your key, but consider a more secure method.

  Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiEndpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'messages': [
          {"role": "system", "content": "You are a motivation coach. $prompt"},
          {"role": "user", "content": prompt},
        ],
        'max_tokens': 150, // You can adjust this as needed.
        'model': 'gpt-3.5-turbo'
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('Failed to fetch response from OpenAI');
    }
  }
}
