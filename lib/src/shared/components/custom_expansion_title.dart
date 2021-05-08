import 'package:flutter/material.dart';

const kTitleListTexStyle = TextStyle(
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
);

const kNormalListTexStyle = TextStyle(
  fontSize: 16.0,
);

typedef ItemBuilder<T> = List<Widget> Function(BuildContext, List<T> items);

typedef TrailingBuilder = Widget Function(bool);

const Duration _kExpand = Duration(milliseconds: 200);

class CustomHeaderExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const CustomHeaderExpansionTile({
    Key key,
    this.headerBackgroundColor,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.iconColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// The color to display the background of the header.
  final Color headerBackgroundColor;

  /// The color to display the icon of the header.
  final Color iconColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  @override
  _CustomHeaderExpansionTileState createState() =>
      _CustomHeaderExpansionTileState();
}

class _CustomHeaderExpansionTileState extends State<CustomHeaderExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;
    final Color titleColor = _headerColor.value;

    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor.value ?? Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor.value),
            child: Container(
              color: widget.headerBackgroundColor ?? Colors.black,
              child: ListTile(
                onTap: _handleTap,
                leading: widget.leading,
                title: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: titleColor),
                  child: widget.title,
                ),
                trailing: widget.trailing ??
                    RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        Icons.expand_more,
                        color: widget.iconColor ?? Colors.grey,
                      ),
                    ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subtitle1.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}

abstract class CustomExpansionTitle<T> extends StatefulWidget {
  CustomExpansionTitle({
    Key key,
    @required this.expandedLabel,
    @required this.colapsedLabel,
    @required this.items,
    this.labelStyle = const TextStyle(
      fontSize: 17.0,
      fontWeight: FontWeight.w600,
    ),
    this.leading,
    this.trailingBuilder,
    this.initiallyExpanded = false,
  }) : super(key: key);

  final String expandedLabel;
  final String colapsedLabel;
  final TextStyle labelStyle;
  final Widget leading;
  final TrailingBuilder trailingBuilder;

  final bool initiallyExpanded;
  final List<T> items;

  @protected
  List<Widget> buildItems(BuildContext context, List<T> items);

  @override
  _CustomExpansionTitleState createState() =>
      _CustomExpansionTitleState(buildItems);
}

class _CustomExpansionTitleState extends State<CustomExpansionTitle> {
  _CustomExpansionTitleState(this.buildItems);

  final ItemBuilder buildItems;

  bool _expanded = false;

  void _onExpansionChanged(bool expanded) {
    setState(() {
      _expanded = expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
      accentColor: Colors.grey,
    );

    return Theme(
      data: theme,
      child: ExpansionTile(
        leading: widget.leading,
        trailing: widget.trailingBuilder(_expanded),
        onExpansionChanged: _onExpansionChanged,
        initiallyExpanded: widget.initiallyExpanded,
        title: Text(
          _expanded ? widget.expandedLabel : widget.colapsedLabel,
          style: widget.labelStyle,
        ),
        children: buildItems(context, widget.items) ?? [],
      ),
    );
  }
}
