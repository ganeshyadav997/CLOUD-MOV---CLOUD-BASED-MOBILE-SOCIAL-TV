import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../models/video_model.dart';
import '../../models/watch_party_model.dart';
import '../../services/watch_party_service.dart';
import 'party_chat_widget.dart';
import 'participant_list_widget.dart';

class WatchPartyScreen extends StatefulWidget {
  final VideoModel? selectedVideo;
  final String userId;
  final String? partyId;

  const WatchPartyScreen({
    super.key,
    required this.userId,
    this.selectedVideo,
    this.partyId,
  });

  @override
  State<WatchPartyScreen> createState() => _WatchPartyScreenState();
}

class _WatchPartyScreenState extends State<WatchPartyScreen> {
  final WatchPartyService _partyService = WatchPartyService();
  VideoPlayerController? _videoController;

  String? _partyId;
  bool _isHost = false;
  bool _isInitializing = true;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initParty();
  }

  Future<void> _initParty() async {
    try {
      if (widget.partyId != null) {
        final partySnapshot = await _partyService.getPartyOnce(widget.partyId!);
        if (partySnapshot == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Room not found!")),
          );
          Navigator.pop(context);
          return;
        }

        await _partyService.joinParty(widget.partyId!, widget.userId);
        if (!mounted) return;

        _partyId = widget.partyId;
        _isHost = false;

        await _initializeVideo(
          partySnapshot.currentVideo,
          partySnapshot.isPlaying,
          partySnapshot.playbackPosition,
        );
      } else if (widget.selectedVideo != null) {
        final partyId =
            await _partyService.createParty(widget.userId, widget.selectedVideo!);
        if (!mounted) return;

        _partyId = partyId;
        _isHost = true;

        await _initializeVideo(widget.selectedVideo!, false, 0);
      } else {
        throw Exception("Must provide selectedVideo or partyId");
      }
    } finally {
      if (mounted) setState(() => _isInitializing = false);
    }
  }

  Future<void> _initializeVideo(
      VideoModel video, bool isPlaying, int position) async {
    setState(() => _isVideoLoading = true);

    if (_videoController != null) {
      await _videoController!.pause();
      await _videoController!.dispose();
    }

    _videoController = VideoPlayerController.network(video.url)
      ..initialize().then((_) {
        if (!mounted) return;
        _videoController!.seekTo(Duration(seconds: position));
        if (isPlaying) _videoController!.play();
        setState(() => _isVideoLoading = false);
      });
  }

  void _playPauseVideo(bool isPlaying) {
    if (_videoController == null) return;
    isPlaying ? _videoController!.play() : _videoController!.pause();
  }

  Future<void> _seekRelative(int seconds) async {
    if (_videoController == null || _partyId == null) return;
    final current = _videoController!.value.position.inSeconds;
    final newPos = current + seconds;
    await _partyService.updatePlayback(_partyId!, true, newPos);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_partyId == null || _isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Watch Party - Room ID: $_partyId"),
        backgroundColor: const Color(0xFF141414),
      ),
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: StreamBuilder<WatchParty>(
          stream: _partyService.getPartyStream(_partyId!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final party = snapshot.data!;
            _isHost = party.isHost(widget.userId);

            if (_videoController == null ||
                _videoController!.dataSource != party.currentVideo.url) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _initializeVideo(
                  party.currentVideo,
                  party.isPlaying,
                  party.playbackPosition,
                );
              });
            } else {
              if (_videoController!.value.isPlaying != party.isPlaying) {
                _playPauseVideo(party.isPlaying);
              }
            }

            return Column(
              children: [
                Stack(
                  children: [
                    _videoController != null && _videoController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : Container(height: 250, color: Colors.grey.shade900),
                    if (_isVideoLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black45,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ParticipantListWidget(
                        partyId: party.partyId,
                        partyService: _partyService,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Room ID: $_partyId",
                          style:
                              const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
                        onPressed: _partyId == null
                            ? null
                            : () {
                                Clipboard.setData(
                                    ClipboardData(text: _partyId!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Room ID copied")),
                                );
                              },
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: Column(
                    children: [
                      Expanded(
                        child: PartyChatWidget(
                          partyId: party.partyId,
                          userId: widget.userId,
                        ),
                      ),
                      if (_isHost)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _partyService.updatePlayback(
                                      party.partyId,
                                      true,
                                      _videoController?.value.position.inSeconds ??
                                          0),
                                  child: const Text("Play"),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _partyService.updatePlayback(
                                      party.partyId,
                                      false,
                                      _videoController?.value.position.inSeconds ??
                                          0),
                                  child: const Text("Pause"),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _seekRelative(30),
                                  child: const Text("Seek +30s"),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
