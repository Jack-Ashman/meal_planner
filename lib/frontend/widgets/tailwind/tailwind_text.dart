import 'package:flutter/material.dart';

class TailwindText extends StatelessWidget {
  final BuildContext context;

  final String text;
  final String classes;

  final Color? colour;

  const TailwindText(
    this.context,
    this.text, {
    super.key,
    this.classes = '',
    this.colour,
  });

  /// Builds text style based on utility classes similar to TailwindCSS
  TextStyle buildStyleFromClasses(String classes) {
    final List<String> classList = classes.split(' ');

    // Default style
    TextStyle style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
      color: Colors.black,
    );

    // Process each class
    for (String cls in classList) {
      /* ################################################### Text Sizes ################################################### */

      if (cls == 'text-xs') {
        style = style.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        );
      } else if (cls == 'text-sm') {
        style = style.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        );
      } else if (cls == 'text-md') {
        style = style.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        );
      } else if (cls == 'text-lg') {
        style = style.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        );
      } else if (cls == 'text-xl') {
        style = style.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        );
      } else if (cls == 'text-2xl') {
        style = style.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );
      }

      /* ################################################### Font Weights ################################################### */

      if (cls == 'font-thin') {
        style = style.copyWith(fontWeight: FontWeight.w100);
      } else if (cls == 'font-extralight') {
        style = style.copyWith(fontWeight: FontWeight.w200);
      } else if (cls == 'font-light') {
        style = style.copyWith(fontWeight: FontWeight.w300);
      } else if (cls == 'font-normal') {
        style = style.copyWith(fontWeight: FontWeight.w400);
      } else if (cls == 'font-medium') {
        style = style.copyWith(fontWeight: FontWeight.w500);
      } else if (cls == 'font-semibold') {
        style = style.copyWith(fontWeight: FontWeight.w600);
      } else if (cls == 'font-bold') {
        style = style.copyWith(fontWeight: FontWeight.w700);
      } else if (cls == 'font-extrabold') {
        style = style.copyWith(fontWeight: FontWeight.w800);
      } else if (cls == 'font-black') {
        style = style.copyWith(fontWeight: FontWeight.w900);
      }

      /* ################################################### Text Colors ################################################### */

      if (cls.startsWith('text-')) {
        final colours = {
          'red': Colors.red,
          'green': Colors.green,
          'blue': Colors.blue,
          'yellow': Colors.yellow,
          'purple': Colors.purple,
          'orange': Colors.orange,
          'gray': Colors.grey,
          'black': Colors.black,
          'white': Colors.white,
          'transparent': Colors.transparent,
        };

        final colourName = cls.substring(5);

        if (colours.containsKey(colourName)) {
          style = style.copyWith(color: colours[colourName]);
        }
      }

      /* ################################################### Text Decoration ################################################### */

      if (cls == 'underline') {
        style = style.copyWith(decoration: TextDecoration.underline);
      } else if (cls == 'strikethrough') {
        style = style.copyWith(decoration: TextDecoration.lineThrough);
      } else if (cls == 'no-underline') {
        style = style.copyWith(decoration: TextDecoration.none);
      }

      /* ################################################### Letter Spacing ################################################### */

      if (cls == 'tracking-tight') {
        style = style.copyWith(letterSpacing: -0.5);
      } else if (cls == 'tracking-normal') {
        style = style.copyWith(letterSpacing: 0.0);
      } else if (cls == 'tracking-wide') {
        style = style.copyWith(letterSpacing: 0.5);
      }

      if (cls == 'truncate') {
        style = style.copyWith(
          overflow: TextOverflow.ellipsis,
        );
      }

      if (colour != null) {
        style = style.copyWith(color: colour);
      }
    }

    return style;
  }

  TextAlign getTextAlignFromClasses(String classes) {
    final List<String> classList = classes.split(' ');

    if (classList.contains('text-center')) {
      return TextAlign.center;
    } else if (classList.contains('text-right')) {
      return TextAlign.right;
    } else if (classList.contains('text-justify')) {
      return TextAlign.justify;
    } else {
      return TextAlign.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: buildStyleFromClasses(classes),
      textAlign: getTextAlignFromClasses(classes),
      overflow: classes.contains('truncate') ? TextOverflow.ellipsis : TextOverflow.visible,
      maxLines: classes.contains('truncate') ? 1 : null,
      softWrap: !classes.contains('truncate'),
    );
  }
}
