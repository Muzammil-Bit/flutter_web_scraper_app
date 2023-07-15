import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../client/api_client.dart';
import '../helpers/global_helpers.dart';

class ScrapeController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<ChatCTResponse?> chat = Rx(null);

  List captions = [];
  List tags = [];
  List tag_suggestions = [];

  scrape(String url) async {
    isLoading(true);
    try {
      var res = await http.get(Uri.parse(url));

      var textFromHtml = extractTextFromHtml(res.body);
      print("HTML TEXT:: ${textFromHtml}");

      final response = await ApiClient().generateInstagramCaption(textFromHtml);
      this.chat.value = response;

      var decoded = jsonDecode(this.chat.value!.choices.first.message!.content);
      this.tags = decoded['tags'];
      this.captions = decoded['captions'];
      this.tag_suggestions = decoded['suggested_tags'];
    } catch (e) {
      print("EXCEPTION :: ${e.toString()}");
      errorToast("Failed to fetch data. Please try again later.");
    } finally {
      isLoading(false);
    }
  }
}
