// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../navigation_services/navigation_manager.dart';
// import '../widgets/global_app_bar.dart';

// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen(
//       {super.key,
//       this.url,
//       this.cartId,
//       this.tranRef,
//       this.realCartId,
//       this.userId,
//       this.fromAddCard,
//       this.deleiveryCost});
//   final String? url,
//       cartId,
//       tranRef,
//       realCartId,
//       userId,
//       fromAddCard,
//       deleiveryCost;
//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageFinished: (String url) {
//             log('Page finished loading: $url');
//             if (url.contains('result')) {
//               _handleTransactionSuccess();
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             log('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//             ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               log('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             log('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//           onHttpError: (HttpResponseError error) {
//             log('Error occurred on page: ${error.response?.statusCode}');
//           },
//           onUrlChange: (UrlChange change) {
//             log('url change to ${change.url}');
//           },
//         ),
//       )
//       ..addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       )
//       ..loadRequest(
//         Uri.parse(widget.url!),
//       );
//   }

//   void _handleTransactionSuccess() {
//     if (widget.fromAddCard == "fromAddCard") {
//       context.read<CartController>().callbackCard(
//           widget.tranRef, widget.cartId, widget.userId,
//           deleiveryCost: widget.deleiveryCost);
//       NavigationManager.pop();
//     } else {
//       context
//           .read<OrderController>()
//           .payTabCallBack(widget.cartId!, widget.tranRef!, widget.realCartId!)
//           .then((_) {
//         NavigationManager.navigatToAndFinish(const IndexedScreen(
//           currentIndex: 1,
//         ));
//       });
//     }
//   }

//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         _handleTransactionSuccess();
//         log('App resumed');

//         break;
//       case AppLifecycleState.inactive:
//         _handleTransactionSuccess();
//         log('App inactive');

//         break;
//       case AppLifecycleState.paused:
//         _handleTransactionSuccess();
//         log('App paused');

//         break;
//       case AppLifecycleState.detached:
//         _handleTransactionSuccess();
//         log('App detached');
//         break;
//       case AppLifecycleState.hidden:
//         _handleTransactionSuccess();
//         log('App hidden');

//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       // ignore: deprecated_member_use
//       onPopInvoked: (didPop) {},
//       child: Scaffold(
//         appBar: sharedAppBar(
//           context,
//           "",
//           callback: () {
//             if (widget.fromAddCard == "fromAddCard") {
//               NavigationManager.pop();
//             } else {
//               log('back pressed');
//               context
//                   .read<OrderController>()
//                   .payTabCallBack(
//                       widget.cartId!, widget.tranRef!, widget.realCartId)
//                   .then((_) {
//                 NavigationManager.pop();
//               });
//             }
//           },
//           centerTitle: false,
//           backIcon: true,
//           fontSize: 24,
//           heighOfAppbar: 280.0,
//           backgroundColor: AppColors.digitsPinColor,
//         ),
//         body: WebViewWidget(
//           controller: controller,
//         ),
//       ),
//     );
//   }
// }
