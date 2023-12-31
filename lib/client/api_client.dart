import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  Future<ChatCTResponse> generateInstagramCaption(String htmlString) async {
    final openAI = OpenAI.instance.build(token: dotenv.get('OPENAI_KEY'));

    // Model only supports up to 4097 tokens. So we have to trim the number of tokens some how.
    final String prompt =
        "${htmlString.length > 4000 ? htmlString.substring(0, 4000) : htmlString} \n Give 10 captions, 10 tags and 10 instagram usernames of people that should be tagged for post based on text provided. Do not include any explanations, only provide a  RFC8259 compliant JSON response  following this format without deviation.{'captions': ['array of captions'], 'tags': ['array of tags'], 'suggested_tags' : ['array of suggested people instagram usernames to tag']}";

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
