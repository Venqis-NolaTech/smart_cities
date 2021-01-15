import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart';

export 'package:linkify/linkify.dart'
    show
        LinkifyElement,
        LinkifyOptions,
        LinkableElement,
        TextElement,
        Linkifier,
        UrlElement,
        UrlLinkifier,
        EmailElement,
        EmailLinkifier;

enum TrimMode {
  Length,
  Line,
}

/// Callback clicked link
typedef LinkCallback(LinkableElement link);

/// Turns URLs into links
class ReadMoreText extends StatefulWidget {
  /// Text to be linkified
  final String text;

  /// Linkifiers to be used for linkify
  final List<Linkifier> linkifiers;

  /// Callback for tapping a link
  final LinkCallback onOpen;

  /// linkify's options.
  final LinkifyOptions options;

  // TextSpan

  /// Style for non-link text
  final TextStyle style;

  /// Style of link text
  final TextStyle linkStyle;

  // RichText

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Text direction of the text
  final TextDirection textDirection;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel
  final double textScaleFactor;

  /// Whether the text should break at soft line breaks.
  final bool softWrap;

  /// The strut style used for the vertical layout
  final StrutStyle strutStyle;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale
  final Locale locale;

  /// Defines how to measure the width of the rendered text.
  final TextWidthBasis textWidthBasis;

  // Trim

  /// Length of text trim.
  final int trimLength;

  /// Lines of text trim.
  final int trimLines;

  /// trim mode, line or length.
  final TrimMode trimMode;

  /// Trim expanded text label.
  final String trimExpandedText;

  /// Trim collapsed text label.
  final String trimCollapsedText;

  /// Color  of trim label.
  final Color colorClickableText;

  const ReadMoreText(
    this.text, {
    Key key,
    this.linkifiers = defaultLinkifiers,
    this.onOpen,
    this.options,
    this.style,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.softWrap = true,
    this.strutStyle,
    this.locale,
    this.textWidthBasis = TextWidthBasis.parent,
    this.trimExpandedText = ' read less',
    this.trimCollapsedText = ' ...read more',
    this.trimLength = 240,
    this.trimLines = 2,
    this.trimMode = TrimMode.Length,
    this.colorClickableText,
  })  : assert(text != null),
        super(key: key);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

const String _kEllipsis = '\u2026';

const String _kLineSeparator = '\u2028';

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final elements = linkify(
      widget.text,
      options: widget.options,
      linkifiers: widget.linkifiers,
    );

    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final textScaleFactor =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final overflow = defaultTextStyle.overflow;
    final locale =
        widget.locale ?? Localizations.localeOf(context, nullOk: true);

    final colorClickableText =
        widget.colorClickableText ?? Theme.of(context).accentColor;

    TextSpan link = TextSpan(
      text: _readMore
          ? '...${widget.trimCollapsedText}'
          : ' ${widget.trimExpandedText}',
      style: effectiveTextStyle.copyWith(
        color: colorClickableText,
      ),
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with data
        final text = TextSpan(
          style: effectiveTextStyle,
          text: widget.text,
        );

        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.trimLines,
          ellipsis: overflow == TextOverflow.ellipsis ? _kEllipsis : null,
          locale: locale,
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        print('linkSize $linkSize textSize $textSize');

        // Get the endIndex of data
        bool linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final pos = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset);
        } else {
          var pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        var textSpan;
        if (!_readMore) {
          textSpan = buildTextSpan(
            elements,
            style: effectiveTextStyle,
            onOpen: widget.onOpen,
            linkReadMore: link,
            linkStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .merge(widget.style)
                .copyWith(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                )
                .merge(widget.linkStyle),
          );
        } else {
          textSpan = buildTextSpan(
            elements,
            style: effectiveTextStyle,
            onOpen: widget.onOpen,
            linkStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .merge(widget.style)
                .copyWith(
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                )
                .merge(widget.linkStyle),
          );
        }

        switch (widget.trimMode) {
          case TrimMode.Length:
            if (widget.trimLength < widget.text.length && _readMore) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: widget.text.substring(0, widget.trimLength),
                children: <TextSpan>[link],
              );
            }
            break;

          case TrimMode.Line:
            if (textPainter.didExceedMaxLines && _readMore) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: widget.text.substring(0, endIndex) +
                    (linkLongerThanLine ? _kLineSeparator : ''),
                children: <TextSpan>[link],
              );
            }
            break;
          default:
            throw Exception(
                'TrimMode type: ${widget.trimMode} is not supported');
        }

        return RichText(
          textAlign: textAlign,
          textDirection: textDirection,
          softWrap: true,
          overflow: TextOverflow.clip,
          textScaleFactor: textScaleFactor,
          text: textSpan,
        );
      },
    );

    return result;
  }
}

/// Raw TextSpan builder for more control on the RichText
TextSpan buildTextSpan(
  List<LinkifyElement> elements, {
  TextStyle style,
  TextStyle linkStyle,
  LinkCallback onOpen,
  TextSpan linkReadMore,
}) {
  var children = elements.map<TextSpan>(
    (element) {
      if (element is LinkableElement) {
        return TextSpan(
          text: element.text,
          style: linkStyle,
          recognizer: onOpen != null
              ? (TapGestureRecognizer()..onTap = () => onOpen(element))
              : null,
        );
      } else {
        return TextSpan(
          text: element.text,
          style: style,
        );
      }
    },
  ).toList();

  if (linkReadMore != null) children.add(linkReadMore);

  return TextSpan(
    children: children,
  );
}
