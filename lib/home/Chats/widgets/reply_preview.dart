

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  // void cancelReply(WidgetRef ref) {
  //   ref.read(messageReplyProvider.state).update((state) => null);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'hell',
                  // messageReply!.isMe ?
                  // 'Me' : 'Opposite',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                child: const Icon(
                  Icons.close,
                  size: 16,
                ),
                // onTap: () => cancelReply(ref),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // DisplayMsg(
          //   msg: messageReply.message,
          //   type: messageReply.messageEnum,
          // ),
        ],
      ),
    );
  }
}