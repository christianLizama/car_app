import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraStreamWidget extends StatefulWidget {
  final String url;

  const CameraStreamWidget({required this.url, super.key});

  @override
  createState() => _CameraStreamWidgetState();
}

class _CameraStreamWidgetState extends State<CameraStreamWidget> {
  late WebSocketChannel channel;
  Uint8List? latestFrame;
  Uint8List? previousFrame;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse(widget.url));

    channel.stream.listen((message) {
      setState(() {
        previousFrame = latestFrame;
        latestFrame = message as Uint8List;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          if (previousFrame != null)
            Transform.rotate(
              angle: 1.5708, // 90 grados en radianes
              child: Image.memory(
                previousFrame!,
                gaplessPlayback: true,
              ),
            ),
          if (latestFrame != null)
            Transform.rotate(
              angle: 1.5708, // 90 grados en radianes
              child: Image.memory(
                latestFrame!,
                gaplessPlayback: true,
              ),
            ),
          if (latestFrame == null && previousFrame == null)
            const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
