import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../controllers/scrape_controller.dart';
import '../helpers/global_helpers.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final TextEditingController _urlEditingController = TextEditingController();
  final ScrapeController _scrapeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextField(
              controller: _urlEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Enter URL"),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Obx(() {
                return _scrapeController.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: () {
                          if (!GetUtils.isURL(_urlEditingController.text.trim())) {
                            errorToast("Please enter a valid url.");
                            return;
                          }
                          _scrapeController.scrape(_urlEditingController.text.trim());
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
              }),
            ),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _scrapeController.chat.value == null ? SizedBox() : _buildCaptionsContainer(_scrapeController.captions, 'Captions'),
                      _scrapeController.chat.value == null ? SizedBox() : _buildCaptionsContainer(_scrapeController.tags, 'Tags'),
                      _scrapeController.chat.value == null ? SizedBox() : _buildCaptionsContainer(_scrapeController.tag_suggestions, 'Tag Suggestions'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptionsContainer(List list, String title) {
    return list.length == 0
        ? SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      for (int i = 0; i < list.length; i++) Text('\t${i + 1}. ${list[i].toString()}'),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 20,
                  child: IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: jsonEncode(list),
                        ),
                      );
                      await Fluttertoast.showToast(
                        msg: "${title} copied to clipboard.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                    icon: Icon(Icons.copy),
                  ),
                ),
              ],
            ),
          );
  }
}
