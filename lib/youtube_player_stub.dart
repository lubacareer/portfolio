import 'package:flutter/material.dart';

class YouTubePlayer extends StatelessWidget {
  const YouTubePlayer({
    super.key,
    required this.videoId,
    required this.title,
    required this.fallbackMessage,
  });

  final String videoId;
  final String title;
  final String fallbackMessage;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(fallbackMessage, textAlign: TextAlign.center),
    ),
  );
}
