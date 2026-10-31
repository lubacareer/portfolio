import 'package:flutter/material.dart';

class YouTubePlayer extends StatelessWidget {
  const YouTubePlayer({super.key, required this.videoId, required this.title});

  final String videoId;
  final String title;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
