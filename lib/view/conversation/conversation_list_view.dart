import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/widgets/loading_indicator.dart';

import '../../models/conversation.dart';
import '../../repository/conversation_repository.dart';
import '../people/nearby_people_view.dart';
import '../../widgets/chat_history.dart';
import 'package:flutter/material.dart';

class ConversationListView extends StatefulWidget {
  const ConversationListView({super.key});

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView> {
  var _isInit = true;
  var _isLoading = false;
  late List<Conversation> _conversations;
  late List<Conversation> _searchedConversations;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      _fetchAndSetConversations().then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _fetchAndSetConversations() async {
    final payload = await ConversationRepository().getConversationsApi();
    final responseData = payload['conversations']['data'] as List;
    final chatManager = ChatClient.getInstance.chatManager;
    final chatData = await Future.wait(
      responseData.map((conversationItem) async {
        return Conversation.fromJson(
          conversationItem,
          (await chatManager.getConversation(
            conversationItem['accountTwoPhone'].toString(),
            createIfNeed: true,
          ))!,
        );
      }),
    );
    setState(() {
      _conversations = [...chatData];
      _searchedConversations = [...chatData];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('chat'),
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (searchText) {
                setState(() {
                  _searchedConversations = _conversations.where((element) {
                    var receiver = element.receiver;
                    return receiver.firstName!
                            .toLowerCase()
                            .contains(searchText.toLowerCase()) ||
                        receiver.lastName!
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                  }).toList();
                });
              },
              maxLines: 1,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xfff0f0f0), width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: context.tr('search'),
                hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                suffixIcon: const Icon(
                  Icons.mic,
                ),
                prefixIcon: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const NearbyPeopleView(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const LoadingIndicator()
                : RefreshIndicator(
                    onRefresh: _fetchAndSetConversations,
                    child: ChatHistory(
                      conversations: _searchedConversations,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
