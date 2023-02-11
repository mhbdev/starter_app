import 'package:apex_api/cipher/models/key_pair.dart';

class Constants {
  static String handlerUrl = '{{handlerUrl}}';
  static const int handlerPrivateVersion = 1;
  static const int handlerPublicVersion = 1;

  static const KeyPair webKey =
      KeyPair("YOUR-WEB-SECRETKEY", "YOUR-WEB-PUBLICKEY");
  static const KeyPair androidKey =
      KeyPair("YOUR-ANDROID-SECRETKEY", "YOUR-ANDROID-PUBLICKEY");
  static const KeyPair iosKey =
      KeyPair("YOUR-IOS-SECRETKEY", "YOUR-IOS-PUBLICKEY");
  static const KeyPair windowsKey =
      KeyPair("YOUR-WINDOWS-SECRETKEY", "YOUR-WINDOWS-PUBLICKEY");
}
