import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiEndpoint = 'https://api.openai.com/v1/engines/davinci/completions';
  final String _apiKey = ''; // Replace with your key, but consider a more secure method.

  Future<String> getResponse(String prompt) async {
    final response = await http.post(
      Uri.parse(_apiEndpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'prompt': prompt,
        'max_tokens': 150, // You can adjust this as needed.
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to fetch response from OpenAI');
    }
  }
}