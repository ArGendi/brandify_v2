import 'package:http/http.dart' as http;
import 'dart:convert';

class SlackServices {
  static const String _webhookUrl = 'https://hooks.slack.com/services/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';

  Future<bool> sendMessage({
    required String message,
    String? channel,
    String? username,
    String? emoji,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': message,
          if (channel != null) 'channel': channel,
          if (username != null) 'username': username,
          if (emoji != null) 'icon_emoji': emoji,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending Slack message: $e');
      return false;
    }
  }
}