import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MyAudioPlayer extends StatefulWidget {
  final String source;
  final void Function() onDelete;

  const MyAudioPlayer({required this.source, required this.onDelete, Key? key})
      : super(key: key);

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

void _playPause() async {
  if (_isPlaying) {
    await _audioPlayer.pause();
  } else {
    await _audioPlayer.play(DeviceFileSource(widget.source));
  }
}

  void _stop() async {
    await _audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _playPause,
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: _stop,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: widget.onDelete,
        ),
      ],
    );
  }
}
