import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../app/utils/app_colors.dart';

class ExpnsionItem extends StatefulWidget {
  const ExpnsionItem({super.key, required this.headerWidget, this.content});
  final Widget headerWidget;
  final Widget? content;

  @override
  State<ExpnsionItem> createState() => _ExpnsionItemState();
}

class _ExpnsionItemState extends State<ExpnsionItem>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
      reverseCurve: Curves.elasticIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      isCollapsed = !isCollapsed;
      if (isCollapsed) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 2.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: _toggleExpansion,
                child: widget.headerWidget,
              ),
              SizeTransition(
                sizeFactor: _animation,
                axisAlignment: -1.0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
                  child: widget.content,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
