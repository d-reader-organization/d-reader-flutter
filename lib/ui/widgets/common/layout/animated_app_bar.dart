import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AnimatedAppBar extends StatelessWidget {
  final Animation<Color?> animation;
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  const AnimatedAppBar({
    super.key,
    required this.animation,
    this.title,
    this.actions,
    this.centerTitle = true,
    //  = const [
    //   Padding(
    //     padding: EdgeInsets.symmetric(
    //       horizontal: 12,
    //     ),
    //     child: Icon(
    //       Icons.more_horiz_outlined,
    //       size: 16,
    //       color: Colors.white,
    //     ),
    //   ),
    // ],
  });

  @override
  Widget build(BuildContext context) {
    final convertedTitle = title != null && title!.length > 20
        ? '${title!.substring(0, 20)}...'
        : title;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return AppBar(
          title: title != null
              ? Text(
                  '$convertedTitle',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
          centerTitle: centerTitle,
          actions: actions,
          backgroundColor: animation.value,
          shadowColor: animation.value,
        );
      },
    );
  }
}

class VisibilityAnimationAppBar extends ConsumerWidget {
  final String? title;
  final List<Widget>? actions;
  final bool centerTitle;
  const VisibilityAnimationAppBar({
    super.key,
    this.title,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      opacity: ref.watch(isAppBarVisibleProvider) ? 1 : 0,
      child: AppBar(
        title: title != null
            ? Text(
                '$title',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              )
            : null,
        centerTitle: centerTitle,
        actions: actions,
        backgroundColor: ColorPalette.appBackgroundColor,
        shadowColor: ColorPalette.appBackgroundColor,
      ),
    );
  }
}
