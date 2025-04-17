import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:intl/intl.dart';

class Validator {
  static String? defaultValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return "هذا الحقل مطلوب".tr();
    }
    return null;
  }

  static String formatPrice(dynamic amount) {
    // Handle null first
    amount ??= 0.0;

    // Force to double no matter what
    double amountAsDouble;
    try {
      if (amount is double) {
        amountAsDouble = amount;
      } else if (amount is String) {
        amountAsDouble = double.tryParse(amount) ?? 0.0;
      } else if (amount is int) {
        amountAsDouble = amount.toDouble();
      } else {
        amountAsDouble = 0.0;
      }
    } catch (e) {
      amountAsDouble = 0.0;
    }

    return "${NumberFormat('#,##0').format(amountAsDouble)} ${"EGP".tr()}";
  }

  static String? name(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      }
    }
    return null;
  }

  static String? text(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
        return "enter_correct_name".tr();
      }
    }
    return null;
  }

  static String? hasValidUrl(String? value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "هذا الحقل مطلوب".tr();
    } else if (!regExp.hasMatch(value)) {
      return "enter_correct_link".tr();
    }
    return null;
  }

  static String? defaultEmptyValidator(String? value) {
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "هذا الحقل مطلوب".tr();
    } else if (!RegExp(r'^01\d{9}$').hasMatch(value)) {
      return "Enter a valid phone number that starts with 01 and is 11 digits"
          .tr()
          .tr();
    } else {
      return null;
    }
  }

  static String? email(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-_]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return "error_email_regex".tr();
      }
    } else {
      return "هذا الحقل مطلوب".tr();
    }
    return null;
  }

  static String? password(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      } else if (value.length < 8 ||
          !RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$")
              .hasMatch(value)) {
        return "error_password_validation".tr();
      }
    }
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword != null) {
      confirmPassword = confirmPassword.trim();
      if (confirmPassword.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      } else if (confirmPassword != password) {
        return "error_wrong_password_confirm".tr();
      }
    } else {
      return "هذا الحقل مطلوب".tr();
    }
    return null;
  }

  static String? numbers(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      }
      if (value.startsWith("+")) {
        value = value.replaceFirst(r'+', "".tr());
      }
      final number = int.tryParse(value);
      if (number == null) {
        return "error_wrong_input".tr();
      }
    } else {
      return "هذا الحقل مطلوب".tr();
    }
    return null;
  }

  static String? price(String? value, int fare) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      }
      if (value.startsWith("+")) {
        value = value.replaceFirst(r'+', "".tr());
      }
      final number = int.tryParse(value);
      if (number == null) {
        return "error_wrong_input".tr();
      } else if (number < fare) {
        return "${"error_price_less_than_fare".tr()} $fare ${"EGP".tr()}";
      }
    } else {
      return "هذا الحقل مطلوب".tr();
    }
    return null;
  }

  static String? phone(
    String? value,
    PhoneModel model,
  ) {
    if (value != null) {
      value = value.trim();
      value = value.replaceAll(r' ', '');
      if (value.isEmpty) {
        return "هذا الحقل مطلوب".tr();
      }
      if (!value.startsWith(model.startWith) || value.length != model.length) {
        return model.startWith.isEmpty
            ? " ${model.length} ${"numbers".tr()} "
            : "${"must_start_with".tr()} ${model.startWith} ${"and_constits_of".tr()} ${model.length} ${"numbers".tr()} ";
      }
    }
    return null;
  }
}

class PhoneModel {
  final String startWith;
  final int length;

  const PhoneModel({required this.length, required this.startWith});
  bool validate(String phoneNumber) {
    return phoneNumber.length == length && phoneNumber.startsWith(startWith);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneModel &&
        other.startWith == startWith &&
        other.length == length;
  }

  @override
  int get hashCode => startWith.hashCode ^ length.hashCode;
}
