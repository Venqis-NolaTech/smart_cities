import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import '../../di/injection_container.dart' as di;
import '../provider/base_provider.dart';

class BaseView<T extends BaseProvider> extends StatefulWidget {
  final Widget Function(BuildContext context, T provider, Widget child) builder;
  final Widget child;
  final Function(T) onProviderReady;
  final bool onlyConsumer;

  BaseView({
    @required this.builder,
    this.child,
    this.onProviderReady,
    this.onlyConsumer = false,
  }) : assert(builder != null);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseProvider> extends State<BaseView<T>> {
  T provider = di.sl<T>();

  @override
  void initState() {
    if (widget.onProviderReady != null) {
      widget.onProviderReady(provider);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final consumer = Consumer<T>(
      builder: widget.builder,
      child: widget.child,
    );

    if (widget.onlyConsumer) {
      return consumer;
    } else {
      return ChangeNotifierProvider<T>(
        create: (context) => provider,
        child: consumer,
      );
    }
  }
}
