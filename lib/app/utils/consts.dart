class ConstsClass {
  factory ConstsClass() {
    return _instance;
  }
  ConstsClass._();
  static final ConstsClass _instance = ConstsClass._();
  static const String jwtTOKEN = "authToken";
  static const String refreshTOKEN = "refreshToken";
  static const String fullNameKey = "fullName";
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
