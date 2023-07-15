import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  Future<ChatCTResponse> generateInstagramCaption(String htmlString) async {
    final openAI = OpenAI.instance.build(token: dotenv.get('OPENAI_KEY'));

    // Model only supports up to 4097 tokens. So we have to trim the number of tokens some how.
    final String prompt =
        "${htmlString.length > 4000 ? htmlString.substring(0, 4000) : htmlString} \n Give 10 captions for post based on text provided. Also generate 10 tags and suggest people to tag based on same previous conditions. If text is not available generate by yourself about feelings and do not say sorry. Give your response as proper json. Name the key of captions as captions, tags as tags and suggested people to tag as suggested_tags.";

    final request = ChatCompleteText(
      messages: [
        Map.of({"role": "user", "content": prompt})
      ],
      maxToken: 500,
      model: ChatModel.chatGptTurbo0301Model,
    );

    final response = await openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      print("data -> ${element.message?.content}");
    }

    return response;
  }
}
