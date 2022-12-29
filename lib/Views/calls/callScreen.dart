import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatmate/Model/call.dart';
import 'package:chatmate/Model/callMethods.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/configs/agoraConfigs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CallScreen extends StatefulWidget {
  final Call call;
  final bool hasDialed;
  const CallScreen({Key? key, required this.call, this.hasDialed = false})
      : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
  late ClientRoleType role;

  CallMethods callMethods = CallMethods();
  late StreamSubscription callStreamSubscription;

  @override
  void initState() {
    super.initState();
    print('call Screen .dart');
    print('widget.call.hasDialed = ${widget.hasDialed}');
    print('call.hasDialed = ${widget.call.hasDialed}');
    print('callerName = ${widget.call.callerName}');
    print('receiverName = ${widget.call.receiverName}');
    print('hasDialed = ${widget.call.hasDialed}');
    print('channelId = ${widget.call.channelId}');
    // role = widget.hasDialed
    //     ? ClientRoleType.clientRoleBroadcaster
    //     : ClientRoleType.clientRoleAudience;
    if (widget.call.hasDialed) {
      print('setting broadcast');
      role = ClientRoleType.clientRoleBroadcaster;
    } else {
      print('setting audience');
      role = ClientRoleType.clientRoleAudience;
    }
    print('role = ${role.name}');
    addPostFrameCallback();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    // configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    print('widget.call.channelId = ${widget.call.channelId}');
    await _engine.joinChannel(
        channelId: widget.call.channelId,
        options: ChannelMediaOptions(),
        token: TOKEN,
        uid: 0);
    _addAgoraEventHandlers();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await _engine.enableVideo();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine.setClientRole(role: role);
    await _engine.startPreview();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    try {
      print(
          '#########################################################EVENT HANDLERSS');
      _engine.registerEventHandler(RtcEngineEventHandler(onError: (code, val) {
        if (mounted)
          setState(() {
            final info = 'onError: $code';
            _infoStrings.add(info);
          });
      }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        if (mounted)
          setState(() {
            final info = 'onJoinChannel: ${connection.localUid}, uid: $elapsed';
            _infoStrings.add(info);
          });
      }, onLeaveChannel: (connection, stats) {
        if (mounted)
          setState(() {
            _infoStrings.add('onLeaveChannel');
            _users.clear();
          });
      }, onUserJoined:
          (RtcConnection rtcConnection, int remoteUid, int elapsed) {
        print('remote ID = $remoteUid');
        if (mounted)
          setState(() {
            final info = 'userJoined: $remoteUid';
            _infoStrings.add(info);
            _users.add(remoteUid);
          });
      }, onUserOffline: (uid, elapsed, userOfflineReasonType) {
        callMethods.endCall(widget.call);
        if (mounted)
          setState(() {
            final info = 'userOffline: $uid';
            _infoStrings.add(info);
            _users.remove(uid);
          });
      }, onFirstRemoteVideoFrame: (uid, width, height, elapsed, val) {
        if (mounted)
          setState(() {
            final info = 'firstRemoteVideo: $uid ${width}x $height';
            _infoStrings.add(info);
          });
      }));
    } catch (e) {
      print('EXCEPTION ==========>>>>>>> $e');
    }
  }

  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callStreamSubscription = callMethods
          .callStream(FirebaseServices.currentUser!.uid)
          .listen((DocumentSnapshot documentSnapshot) {
        switch (documentSnapshot.data()) {
          case null:
            Navigator.pop(context);
            break;
          default:
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    _dispose();
    callStreamSubscription.cancel();
    super.dispose();
  }

  Future<void> _dispose() async {
    // destroy sdk
    await _engine.leaveChannel();
    // await _engine.destroy();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (role == ClientRoleType.clientRoleBroadcaster) {
      list.add(AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      ));
    }
    print('_users = ${_users.length}');
    // _users.forEach((int uid) =>
    list.add(AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: _users[0]),
        connection: RtcConnection(channelId: widget.call.channelId),
      ),
    ));
    // RtcRemoteView.SurfaceView(channelId: widget.channelName!, uid: uid)
    // ));
    // list.add(AgoraVideoView(
    //   controller: VideoViewController.remote(
    //     rtcEngine: _engine,
    //     canvas: VideoCanvas(uid: 12),
    //     connection: RtcConnection(channelId: widget.call.channelId),
    //   ),
    // ));
    return list;
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    print('views=${views.length}');
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
    }
    return Container();
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Text(
                    "null"); // return type can't be null, a widget was required
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index] + '= ' + _users[0].toString(),
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  /// Toolbar layout
  Widget _toolbar() {
    // if (role == ClientRoleType.clientRoleAudience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => callMethods.endCall(widget.call),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
