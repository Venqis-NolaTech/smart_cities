import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TabBarContainer extends Container implements PreferredSizeWidget {
  final Color color;
  final TabBar tabBar;

  TabBarContainer({
    @required this.color,
    @required this.tabBar,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        width: MediaQuery.of(context).size.width,
        child: tabBar,
      );
}
