import 'package:flutter/material.dart';
import '../components/formatted_date.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({Key? key, required this.conversations})
      : super(key: key);

  final List<dynamic> conversations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Most recent conversations"),
        conversations.isEmpty
            ? const Text("No conversations")
            : Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    var conversation = conversations[index];
                    return ListTile(
                      leading: CircleAvatar(
                          child: Image.network(conversation['friend_profpic'])),
                      title: Text(conversation['friend_username']),
                      subtitle: Text(conversation['latest_message']['body'],
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: FormattedDateFromString(
                          date: conversation['latest_message']['time_sent']),
                      onTap: () {},
                    );
                  },
                ),
              ),
      ],
    );
  }
}
