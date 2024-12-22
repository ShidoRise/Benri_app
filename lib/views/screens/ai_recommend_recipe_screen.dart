import 'package:benri_app/utils/constants/colors.dart';
import 'package:benri_app/views/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Thêm SharedPreferences

class AIRecommendRecipeScreen extends StatefulWidget {
  @override
  _AIRecommendRecipeScreenState createState() =>
      _AIRecommendRecipeScreenState();
}

class _AIRecommendRecipeScreenState extends State<AIRecommendRecipeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // Chat log (user/AI)
  bool _isLoading = false;
  final apiKey = dotenv.env['OPENAI_API_KEY'];

  // Tải lịch sử chat từ SharedPreferences
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMessages = prefs.getString('chat_history');
    if (savedMessages != null) {
      final List<dynamic> messageList = jsonDecode(savedMessages);
      setState(() {
        _messages.addAll(messageList.map((message) =>
            {'role': message['role'], 'content': message['content']}));
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedMessages = jsonEncode(_messages);
    await prefs.setString('chat_history', encodedMessages);
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });

    try {
      // Gửi yêu cầu tới API GPT
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'Bạn là trợ lý chuyên về gợi ý món ăn.'
            },
            {
              'role': 'user',
              'content': userMessage +
                  ' sẽ là tên món ăn, nguyên liệu nấu, thời gian nấu, nếu là thực đơn thì đưa ra danh sách món ăn.'
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['choices'][0]['message']['content'];
        final aiMessage = utf8.decode(latin1.encode(temp));

        setState(() {
          _messages.add(
              {'role': 'ai', 'content': aiMessage ?? 'Không có phản hồi.'});
        });

        _saveMessages();
      } else {
        setState(() {
          _messages
              .add({'role': 'ai', 'content': 'Đã xảy ra lỗi khi gửi yêu cầu.'});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'content': 'Lỗi kết nối đến AI.'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(title: 'Gợi ý của AI'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Align(
                    alignment: message['role'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: message['role'] == 'user'
                            ? Colors.blueAccent
                            : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        message['content'] ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập yêu cầu gợi ý món ăn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: BColors.primary,
                  onPressed: () {
                    final userMessage = _controller.text.trim();
                    _controller.clear();
                    sendMessage(userMessage);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
