import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ScrollingArrowsWidget extends StatelessWidget {
  final int currentPage, totalPagesCount;
  final void Function(int page) onPageChange;
  const ScrollingArrowsWidget({
    super.key,
    required this.currentPage,
    required this.totalPagesCount,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFirstPage = currentPage == 0,
        isLastPage = currentPage == (totalPagesCount - 1);
    return Row(
      children: [
        Expanded(
          child: ScrollingArrow(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(
                8,
              ),
            ),
            onTap: isFirstPage
                ? null
                : () {
                    onPageChange(currentPage - 1);
                  },
            child: Icon(
              Icons.arrow_left,
              color: isFirstPage ? ColorPalette.greyscale400 : Colors.white,
            ),
          ),
        ),
        Expanded(
          child: ScrollingArrow(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(
                8,
              ),
            ),
            onTap: isLastPage
                ? null
                : () {
                    onPageChange(currentPage + 1);
                  },
            child: Icon(
              Icons.arrow_right,
              color: isLastPage ? ColorPalette.greyscale400 : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollingArrow extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  const ScrollingArrow({
    super.key,
    required this.onTap,
    required this.child,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: ColorPalette.greyscale400),
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}
