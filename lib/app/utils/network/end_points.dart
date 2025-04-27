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
  static const String forceAddToCart = "cart/force-add-to-cart";
  static const String getCart = "cart/get-cart";
  static const String incrementCartItem = "cart/increment-cart-quantity";
  static const String decrementCartItem = "cart/decrement-cart-quantity";
  static const String deleteCartItem = "cart/remove-item";
  static const String createOrder = "order/store-order";
  static const String applyCoupon = "coupon/apply-coupon";
  static const String getOrders = "order/details";
  static const String cancelOrder = "order/";
  static const String cancelOrderItem = "order/order-items/";
  static const String acceptOrderEdit = "order/accept-update/";
  static const String getAllSliders = "sliders/get-all";
  static const String getStaticPage = "privacy/get-all";
  static const String changePassword = 'profile/update-password';
  static const String logout = 'auth/logout';
  static const String getAllBrands = "brands/get-all";
  static const String contactUs = "contact/store-contact";
  static const String deleteAccount = "profile/deactivate-account";
  static const String rateVendor = "rate/store-rate";
  // static String getProductById({required String id}) => '/api/sales/product/$id';
}
