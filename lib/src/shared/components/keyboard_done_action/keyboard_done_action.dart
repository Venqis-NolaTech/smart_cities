import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../../core/util/list_util.dart';
import 'input_done_widget.dart';

enum PlatfromSupport {
  all,
  android,
  ios,
}

class KeyboardDoneAction extends StatefulWidget {
  KeyboardDoneAction({
    Key key,
    this.platform = PlatfromSupport.all,
    this.onHide,
    this.onShow,
    this.child,
    this.onDone,
    @required this.focusNodes,
  })  : assert(focusNodes.isNotNullOrNotEmpty),
        super(key: key);

  final PlatfromSupport platform;
  final Function onShow;
  final Function onHide;
  final List<FocusNode> focusNodes;
  final Widget child;

  final Function onDone;

  @override
  _KeyboardDoneActionState createState() => _KeyboardDoneActionState();
}

class _KeyboardDoneActionState extends State<KeyboardDoneAction> {
  OverlayEntry _overlayEntry;

  final _keyParent = GlobalKey();

  @override
  void initState() {
    super.initState();

    final bool enabled =
        _hadlePlatform() && widget.focusNodes.isNotNullOrNotEmpty;

    if (enabled) {
      widget.focusNodes.forEach((focus) => focus.addListener(_focusListener));

      KeyboardVisibilityNotification().addNewListener(
        onShow: () {
          if (widget.onShow != null) widget.onShow();
        },
        onHide: () {
          if (widget.onHide != null) widget.onHide();

          _removeOverlay();
        },
      );
    }
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView(
            onDone: widget.onDone,
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry);
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  void _focusListener() {
    bool hasFocus = _hasFocus();

    if (hasFocus)
      _showOverlay(context);
    else
      _removeOverlay();
  }

  bool _hadlePlatform() {
    switch (widget.platform) {
      case PlatfromSupport.android:
        return Platform.isAndroid;
      case PlatfromSupport.ios:
        return Platform.isIOS;
      default:
        return true;
    }
  }

  bool _hasFocus() {
    for (FocusNode focus in widget.focusNodes) {
      if (focus.hasFocus) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _keyParent,
      child: widget.child,
    );
  }
}
