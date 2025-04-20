import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ConstsClass {
  factory ConstsClass() {
    return _instance;
  }
  ConstsClass._();
  static final ConstsClass _instance = ConstsClass._();
  static const String jwtTOKEN = "authToken";
  static const String refreshTOKEN = "refreshToken";
  static const String fullNameKey = "fullName";
  static const String shopNameKey = "shopName";
  static const String shopDelegateNameKey = "delegate_name";
  static const String shopAddressKey = "shopAddress";
  static const String shopCityKey = "shopCity";
  static const String shopTypeKey = "shopType";
  static const String shopLogoKey = "shopLogo";
  static const String mobileNumberKey = "mobileNumber";
  static const String emailKey = "email";
  static const String userIdKey = "uuid";
  static const String userTypeKey = "userType";
  static const String phoneKey = "phoneKey";
  static const String addressKey = "addressKey";
  static const String neighborhoodUuidKey = "neighborhoodUuid";
  static const String isAuthorized = "isLogined";
  static const String availability = "availability";
  static const String userImage = "userImage";
  static const String userAddressUsedId = "user_addressUsed_id";
  static const String userLatitude = "userLatitude";
  static const String userLongitude = "userLongitude";
}

String formatOrderDate(String? dateStr) {
  if (dateStr == null) return '';
  try {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('d MMMM y - hh:mm a', 'ar').format(dateTime);
  } catch (e) {
    return dateStr; // fallback to original if parsing fails
  }
}

Future<void> openLink(var url) async {
  if (!await launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
