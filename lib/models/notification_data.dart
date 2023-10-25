class NotificationData {
  final int type;

  NotificationData({
    required this.type,
  });

  factory NotificationData.fromJson(Map<String, dynamic> jsonData) =>
      NotificationData(
        type: int.parse(jsonData['notificationType']),
      );
}

class ContactRequestNotificationData extends NotificationData {
  final int senderId;
  final String senderPhone;
  final String senderFirstName;
  final String senderLastName;
  final String senderImage;

  ContactRequestNotificationData({
    required this.senderId,
    required this.senderPhone,
    required this.senderFirstName,
    required this.senderImage,
    required this.senderLastName,
  }) : super(type: NotificationTypes.contactRequest);

  factory ContactRequestNotificationData.fromJson(
          Map<String, dynamic> jsonData) =>
      ContactRequestNotificationData(
        senderId: jsonData['senderId'],
        senderPhone: jsonData['senderPhone'],
        senderFirstName: jsonData['senderFirstName'],
        senderImage: jsonData['senderImage'],
        senderLastName: jsonData['senderLastName'],
      );
}

class ChatNotificationData extends NotificationData {
  final int senderId;
  final String senderPhone;
  final String senderFirstName;
  final String senderLastName;
  final String senderImage;

  ChatNotificationData({
    required this.senderId,
    required this.senderPhone,
    required this.senderFirstName,
    required this.senderImage,
    required this.senderLastName,
  }) : super(type: NotificationTypes.chat);

  factory ChatNotificationData.fromJson(Map<String, dynamic> jsonData) =>
      ChatNotificationData(
        senderId: jsonData['senderId'],
        senderPhone: jsonData['senderPhone'],
        senderFirstName: jsonData['senderFirstName'],
        senderImage: jsonData['senderImage'],
        senderLastName: jsonData['senderLastName'],
      );
}

class CallNotificationData extends NotificationData {
  final int senderId;
  final String senderPhone;
  final String senderFirstName;
  final String senderLastName;
  final String senderImage;
  final String channelId;
  final String callingToken;
  final String remoteUid;

  CallNotificationData({
    required this.senderId,
    required this.senderPhone,
    required this.senderFirstName,
    required this.senderImage,
    required this.senderLastName,
    required this.channelId,
    required this.callingToken,
    required this.remoteUid,
  }) : super(type: NotificationTypes.call);

  factory CallNotificationData.fromJson(Map<String, dynamic> jsonData) =>
      CallNotificationData(
        senderId: jsonData['senderId'].runtimeType == String
            ? int.parse(jsonData['senderId'])
            : jsonData['senderId'],
        senderPhone: jsonData['senderPhone'],
        senderFirstName: jsonData['senderFirstName'],
        senderImage: jsonData['senderImage'],
        senderLastName: jsonData['senderLastName'],
        channelId: jsonData['channelId'],
        callingToken: jsonData['callingToken'],
        remoteUid: jsonData['remoteUid'],
      );

  toJson() => {
        'senderId': senderId,
        'senderPhone': senderPhone,
        'senderFirstName': senderFirstName,
        'senderLastName': senderLastName,
        'senderImage': senderImage,
        'channelId': channelId,
        'callingToken': callingToken,
        'remoteUid': remoteUid
      };
}

class PaymentSuccessfulNotificationData extends NotificationData {
  PaymentSuccessfulNotificationData()
      : super(type: NotificationTypes.paymentSuccessful);
}

class NotificationTypes {
  static const int contactRequest = 1;
  static const int chat = 2;
  static const int paymentSuccessful = 3;
  static const int call = 4;
}
