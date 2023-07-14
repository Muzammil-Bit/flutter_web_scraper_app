import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_scraper/web_scraper.dart';

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
      var resp = await http.get(Uri.parse(url));
      print("HTML RESPONSE :: ${resp.body}");

      final response = await ApiClient().generateInstagramCaption(resp.body);
      this.chat.value = response;

      var decoded = jsonDecode(this.chat.value!.choices.first.message!.content);
      this.tags = decoded['tags'];
      this.captions = decoded['captions'];
      this.tag_suggestions = decoded['suggested_tags'];
    } on WebScraperException catch (e) {
      // errorToast("Failed to scrape data.");
      final response = await ApiClient().generateInstagramCaption('');
      this.chat.value = response;

      var decoded = jsonDecode(this.chat.value!.choices.first.message!.content);
      this.tags = decoded['tags'];
      this.captions = decoded['captions'];
      this.tag_suggestions = decoded['suggested_tags'];

      print("Exception in scraping :: ${e.errorMessage()}");
    } catch (e) {
      print("EXCEPTION :: ${e.toString()}");
      errorToast("Failed to fetch data. Please try again later.");
    } finally {
      isLoading(false);
    }
  }
}
