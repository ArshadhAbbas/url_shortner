// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_shortner/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TextProvider>(
      create: (context) => TextProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: UrlShortenerApp(),
      ),
    );
  }
}

class UrlShortenerApp extends StatelessWidget {
  UrlShortenerApp({super.key});
  final _formKey = GlobalKey<FormState>();

  TextEditingController textcontroller = TextEditingController();

  Future getData(context) async {
    var response = await http.get(Uri.parse(
        'https://api.shrtco.de/v2/shorten?url=${textcontroller.text}'));
    var jsonData = jsonDecode(response.body);
    Provider.of<TextProvider>(context, listen: false)
        .changeLink(jsonData['result']['short_link']);
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("URL Shortner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Cannot be Empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
                controller: textcontroller,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Text(Provider.of<TextProvider>(context).shortLink),
              onTap: () {
                var data = ClipboardData(
                    text: Provider.of<TextProvider>(context).shortLink);
                Clipboard.setData(data);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Copied ${Provider.of<TextProvider>(context).shortLink}")));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    getData(context);
                    // showDialog(context: context, builder: (context) {
                    //   return AlertDialog(content: Text(Provider.of<TextProvider>(context).shortLink),);
                    // },);
                  }
                },
                child: const Text("Shorten Url"))
          ],
        ),
      ),
    );
  }
}
