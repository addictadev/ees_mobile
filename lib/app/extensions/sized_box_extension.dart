import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension EmptySpace on num {
  SizedBox get height => SizedBox(height: toDouble().h);

  SizedBox get width => SizedBox(width: toDouble().w);
}
