import 'package:bu_vsa/ui/Welcome%20Screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChatbotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  Future<void> _handleSubmit(String text) async {
    print('Handling submission...');  // Log
    _textController.clear();
    ChatMessage message = ChatMessage(text: text);
    setState(() {
      _messages.insert(0, message);
    });

    // Send the message to the backend
    try {
      print('Sending message to backend...');  // Log
      final response = await http.post(
        Uri.parse('http://10.97.10.23:5000/chatbot'),
        //Uri.parse('http://192.168.100.224:5000/chatbot'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': text}),
      );

      print('Received response: ${response.body}');  // Log

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        ChatMessage botMessage = ChatMessage(text: responseBody['response'], fromBot: true);
        setState(() {
          _messages.insert(0, botMessage);
        });
      } else {
        print('Error: ${response.statusCode}');  // Log
      }
    } catch (error) {
      print('Error occurred: $error');  // Log
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00205C),  // Blue background
      appBar: AppBar(

        elevation: 0, // No shadow to make it seamless with the background
        backgroundColor: Color(0xFF00205C),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()));
          },
        ),
      ),

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Text(
              'Academia Assist',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white), // Larger, bold font for the heading
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
                  Divider(height: 1.0),
                  _buildTextComposer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTextComposer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _handleSubmit(_textController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
// ... Rest of your Flutter code for creating the chat interface

}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool fromBot;

  ChatMessage({required this.text, this.fromBot = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
        fromBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: fromBot
                  ? BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              )
                  : BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Text(
              fromBot ? "Academia Assist: \n$text": text,
              style: TextStyle(fontSize: 18.0), // Increased font size
            ),
          ),
        ],
      ),
    );
  }
}