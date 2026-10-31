import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

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
  Widget build(BuildContext context) => HtmlElementView.fromTagName(
    tagName: 'iframe',
    onElementCreated: (element) {
      final frame = element as web.HTMLIFrameElement;
      frame.src = 'https://www.youtube-nocookie.com/embed/$videoId';
      frame.title = title;
      frame.allow = 'encrypted-media; picture-in-picture; fullscreen';
      frame.allowFullscreen = true;
      frame.referrerPolicy = 'strict-origin-when-cross-origin';
      frame.style.border = '0';
    },
  );
}
