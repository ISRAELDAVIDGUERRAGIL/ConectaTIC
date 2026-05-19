import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoIntroScreen extends StatefulWidget {
  final String moduleTitle;
  final String? videoPath;
  final List<Map<String, dynamic>>? content;
  final List<Map<String, dynamic>>? exercises;

  const VideoIntroScreen({
    super.key,
    required this.moduleTitle,
    this.videoPath,
    this.content,
    this.exercises,
  });

  @override
  State<VideoIntroScreen> createState() => _VideoIntroScreenState();
}

class _VideoIntroScreenState extends State<VideoIntroScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _videoWatched = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath != null) {
      _initializeVideo();
    } else {
      setState(() => _hasError = true);
    }
  }

  Future<void> _initializeVideo() async {
    if (widget.videoPath == null) return;
    try {
      _controller = VideoPlayerController.asset(widget.videoPath!);
      await _controller!.initialize();
      _controller!.addListener(_videoListener);
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Error loading video: $e');
      setState(() => _hasError = true);
    }
  }

  void _videoListener() {
    if (_controller != null && _controller!.value.isInitialized) {
      final position = _controller!.value.position;
      final duration = _controller!.value.duration;
      if (position >= duration && duration.inSeconds > 0) {
        if (!_videoWatched) {
          setState(() => _videoWatched = true);
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 350;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        title: Text(widget.moduleTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(isWide),
    );
  }

  Widget _buildBody(bool isWide) {
    return Padding(
      padding: EdgeInsets.all(isWide ? 32 : 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isWide ? 32 : 24),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                if (_isInitialized) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _controller!.value.isInitialized
                          ? VideoPlayer(_controller!)
                          : const CircularProgressIndicator(color: Color(0xFF58CC02)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => _controller!.seekTo(Duration.zero),
                        icon: const Icon(Icons.replay, color: Colors.white70),
                        tooltip: 'Reiniciar',
                      ),
                      IconButton(
                        onPressed: () {
                          if (_controller!.value.isPlaying) {
                            _controller!.pause();
                          } else {
                            _controller!.play();
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          _controller!.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: const Color(0xFF58CC02),
                          size: 48,
                        ),
                        tooltip: _controller!.value.isPlaying ? 'Pausar' : 'Reproducir',
                      ),
                    ],
                  ),
                ] else ...[
                  Icon(
                    _hasError ? Icons.school_rounded : Icons.play_circle_filled_rounded,
                    color: const Color(0xFF58CC02),
                    size: isWide ? 80 : 60,
                  ),
                  SizedBox(height: isWide ? 24 : 16),
                  Text(
                    _hasError ? 'Comenzar módulo' : 'Video introductorio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isWide ? 22 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWide ? 12 : 8),
                  Text(
                    _hasError 
                        ? 'Prepárate para aprender'
                        : 'Mira el video para aprender más sobre este módulo',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isWide ? 16 : 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: isWide ? 40 : 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/lesson-content', extra: {
                'titulo': widget.moduleTitle,
                'content': widget.content,
                'exercises': widget.exercises,
              }),
              icon: Icon(Icons.skip_next_rounded, size: isWide ? 28 : 24),
              label: Text(
                'Continuar a las lecciones',
                style: TextStyle(fontSize: isWide ? 18 : 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: isWide ? 18 : 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(bool isWide) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isWide ? 32 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off_rounded,
              color: Colors.white54,
              size: isWide ? 80 : 60,
            ),
            SizedBox(height: isWide ? 24 : 16),
            Text(
              'No se pudo cargar el video',
              style: TextStyle(
                color: Colors.white,
                fontSize: isWide ? 20 : 16,
              ),
            ),
            SizedBox(height: isWide ? 40 : 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/lesson-content', extra: {
                  'titulo': widget.moduleTitle,
                  'content': widget.content,
                  'exercises': widget.exercises,
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58CC02),
                  padding: EdgeInsets.symmetric(vertical: isWide ? 16 : 14),
                ),
                child: const Text('Continuar sin video'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(bool isWide) {
    final isPlaying = _controller?.value.isPlaying ?? false;
    final position = _controller?.value.position ?? Duration.zero;
    final duration = _controller?.value.duration ?? Duration.zero;

    return Container(
      padding: EdgeInsets.all(isWide ? 20 : 14),
      color: const Color(0xFF2C2C2E),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: isWide ? 48 : 40,
                ),
                onPressed: () {
                  setState(() {
                    if (isPlaying) {
                      _controller?.pause();
                    } else {
                      _controller?.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.replay_rounded,
                  color: Colors.white,
                  size: isWide ? 40 : 32,
                ),
                onPressed: () {
                  _controller?.seekTo(Duration.zero);
                },
              ),
            ],
          ),
          SizedBox(height: isWide ? 12 : 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF58CC02),
              inactiveTrackColor: Colors.white24,
              thumbColor: const Color(0xFF58CC02),
              overlayColor: const Color(0xFF58CC02).withOpacity(0.3),
            ),
            child: Slider(
              value: duration.inMilliseconds > 0
                  ? position.inMilliseconds / duration.inMilliseconds
                  : 0,
              onChanged: (value) {
                final newPosition = Duration(
                  milliseconds: (value * duration.inMilliseconds).round(),
                );
                _controller?.seekTo(newPosition);
              },
            ),
          ),
          Text(
            '${_formatDuration(position)} / ${_formatDuration(duration)}',
            style: TextStyle(color: Colors.white70, fontSize: isWide ? 14 : 12),
          ),
          SizedBox(height: isWide ? 16 : 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _videoWatched
                  ? () => context.push('/lesson-content', extra: {
                        'titulo': widget.moduleTitle,
                        'content': widget.content,
                        'exercises': widget.exercises,
                      })
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                disabledBackgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: isWide ? 16 : 14),
              ),
              child: Text(
                _videoWatched ? 'Continuar →' : 'Termina de ver el video',
                style: TextStyle(fontSize: isWide ? 16 : 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}