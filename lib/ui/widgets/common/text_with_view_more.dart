import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextWithViewMore extends StatefulWidget {
  final String text;
  final TextAlign textAlign;
  final int maxLines;

  const TextWithViewMore({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  State<TextWithViewMore> createState() => _TextWithViewMoreState();
}

class _TextWithViewMoreState extends State<TextWithViewMore> {
  bool isReadMore = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int charactersLimit =
        MediaQuery.of(context).size.width > 360 ? 80 : 70;
    return widget.text.trim().length - 1 > charactersLimit
        ? Wrap(
            children: [
              RichText(
                textAlign: widget.textAlign,
                maxLines: isReadMore ? null : widget.maxLines,
                overflow:
                    isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isReadMore
                          ? widget.text
                          : widget.text
                              .substring(0, charactersLimit)
                              .padRight(charactersLimit + 3, '.'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    TextSpan(
                      text: isReadMore ? 'view less' : 'view more',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorPalette.dReaderYellow100,
                            fontSize: 16,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(
                            () {
                              isReadMore = !isReadMore;
                            },
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          )
        : DescriptionText(
            text: widget.text,
          );
  }
}
