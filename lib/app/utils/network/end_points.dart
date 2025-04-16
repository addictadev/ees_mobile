class EndPoints {
  factory EndPoints() {
    return _instance;
  }
  EndPoints._();
  static final EndPoints _instance = EndPoints._();
  static const String baseUrl = "https://api.ees-elmasria.com/api/v1/";
  static const String baseUrlImgs = "https://api.ees-elmasria.com/";
  static const String register = "auth/register";
  static const String login = "auth/login";
  static const String citys = "auth/cities";
  static const String forgotPassword = "auth/forgot-password";
  static const String checkLocation = "user/checkNewLocation";
  static const String verfiyOtpApi = "auth/verify-otp-register";
  static const String resendOtpAgainApi = "auth/resend-otp";
  static const String resetPassword = "auth/reset-password";
  static const String userProfile = "user";
  static const String editUserProfile = "user/updateUserProfile";
  static const String getAllCategories = "categories/get-all";
  static const String getAllSuppliers = "properties/get-all";
  static const String getAllHomeProducts = "products/get-all";
  static const String addToCart = "cart/add-to-cart";
}
