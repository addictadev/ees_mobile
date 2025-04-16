import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:ees/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../navigation_services/navigation_manager.dart';

enum ToastType { error, success, info }

BuildContext getContext() {
  return (NavigationManager.navigatorKey.currentState!.overlay!.context);
}

showCustomedToast(String message, ToastType toastType) {
  CherryToast.success(
    title: Text(
      toastType == ToastType.success ? "تم" : "خطأ",
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
    displayCloseButton: true,
    description: Text(
      message,
      style: const TextStyle(fontSize: 16),
    ),
    animationType: toastType == ToastType.success
        ? AnimationType.fromBottom
        : AnimationType.fromTop,
    animationDuration: const Duration(milliseconds: 800),
    autoDismiss: true,
    toastPosition:
        toastType == ToastType.success ? Position.bottom : Position.top,
    borderRadius: 12,
    iconWidget: toastType == ToastType.success
        ? const Icon(Icons.check_circle, color: Colors.green)
        : const Icon(Icons.error_outline, color: Colors.red),
  ).show(getContext());
}
// void showCustomedToast(String msg, ToastType type) async {
//   try {
//     final toastData = _getToastData(type);

//     if (toastData == null) {
//       if (kDebugMode) {
//         print('Invalid toast type: $type');
//       }
//       return;
//     }

//     final String title = toastData['title'];
//     final Color backgroundColor = toastData['backgroundColor'];
//     final Icon icon = toastData['icon'];

//     AchievementView(
//       title: title,
//       subTitle: '$msg       ',
//       typeAnimationContent: AnimationTypeAchievement.fade,
//       icon: icon,
//       color: backgroundColor,
//       textStyleTitle: const TextStyle(fontSize: 16),
//       textStyleSubTitle: const TextStyle(fontSize: 13),
//       alignment: Alignment.topCenter,
//       duration: const Duration(seconds: 3),
//       isCircle: false,
//       listener: (status) {
//         if (kDebugMode) {
//           print(status);
//         }
//       },
//     ).show(getContext());
//   } catch (err) {
//     if (kDebugMode) {
//       print('myToast error: $err');
//     }
//   }
// }

// Map<String, dynamic>? _getToastData(ToastType type) {
//   String title;
//   Color backgroundColor;
//   Icon icon;

//   switch (type) {
//     case ToastType.error:
//       title = translator.activeLanguageCode == 'en' ? 'Error' : 'خطأ';
//       backgroundColor = Colors.red;
//       icon = const Icon(Icons.error, color: Colors.white);
//       break;
//     case ToastType.success:
//       title = translator.activeLanguageCode == 'en' ? 'Success' : 'تم';
//       backgroundColor = AppColors.greenColor;
//       icon = const Icon(Icons.done, color: Colors.white);
//       break;
//     case ToastType.info:
//       title = translator.activeLanguageCode == 'en' ? 'Note' : 'تنبيه';
//       backgroundColor = Colors.orange;
//       icon = const Icon(Icons.info, color: Colors.white);
//       break;
//   }

//   return {
//     'title': title,
//     'backgroundColor': backgroundColor,
//     'icon': icon,
//   };
// }

Widget loadingIndicator = const Center(
  child: SizedBox(
    width: 50,
    height: 50,
    child: SpinKitCircle(
      color: AppColors.primary,
    ),
  ),
);
