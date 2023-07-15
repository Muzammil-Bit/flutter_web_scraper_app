import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

errorToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.red,
    webPosition: 'center',
    webBgColor: "#FF0000",
    timeInSecForIosWeb: 3,
  );
}

String extractTextFromHtml(String htmlString) {
  // Remove any <script> tags and their contents
  htmlString = htmlString.replaceAll(RegExp(r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>'), '');

  // Remove any <style> tags and their contents
  htmlString = htmlString.replaceAll(RegExp(r'<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>'), '');

  // Parse the HTML string and extract the plain text content
  final document = HtmlParser.parseHTML(htmlString);
  final String plainText = document.body!.text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');

  return plainText;
}
