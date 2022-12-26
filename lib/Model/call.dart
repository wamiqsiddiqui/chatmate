class Call {
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String channelId;
  bool hasDialed;

  Call(
      {required this.callerId,
      required this.callerName,
      required this.callerPic,
      required this.receiverId,
      required this.receiverName,
      required this.receiverPic,
      required this.channelId,
      required this.hasDialed});

  factory Call.fromMap(Map<String, dynamic> map) => Call(
      callerId: map['callerId'],
      callerName: map['callerName'],
      callerPic: map['callerPic'],
      receiverId: map['receiverId'],
      receiverName: map['receiverName'],
      receiverPic: map['receiverPic'],
      channelId: map['channelId'],
      hasDialed: map['hasDialed']);

  Map<String, dynamic> toMap() => {
        'callerId': callerId,
        'callerName': callerName,
        'callerPic': callerPic,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'receiverPic': receiverPic,
        'channelId': channelId,
        'hasDialed': hasDialed
      };
}
