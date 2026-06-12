import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiChatService {
  // Directly using the API key since Firebase Functions require the Blaze plan
  static const String _apiKey = 'AIzaSyCD-iXomIHpe0KfnRms3JKfzSOm3MLLmyw';
  final GenerativeModel _model;

  GeminiChatService()
    : _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _apiKey,
        systemInstruction: Content.system(
          "You are a calm, supportive mental health assistant for the E-Therapy app. Answer only questions related to this app, its features, user experience, and safe non-medical mental wellness guidance. If a user asks something unrelated to this app or outside the app's scope, politely say that you can only help with this app and its supported mental health topics.",
        ),
      );

  Future<String> sendMessageToGemini(
    String message,
    List<Map<String, dynamic>> previousMessages,
  ) async {
    try {
      final List<Content> chatHistory = previousMessages.map((msg) {
        final role = msg['sender'] == 'ai' ? 'model' : 'user';
        return Content(role, [TextPart(msg['text'] as String)]);
      }).toList();

      chatHistory.add(Content.text(message));

      final response = await _model.generateContent(chatHistory);

      return response.text ?? "I'm sorry, I couldn't process that request.";
    } catch (e) {
      print('Gemini API Error: \$e');
      throw Exception('Failed to communicate with AI. Please try again later.');
    }
  }
}
