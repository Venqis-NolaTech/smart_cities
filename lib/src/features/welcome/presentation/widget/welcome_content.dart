import 'package:flutter/material.dart';

class WelcomeContent extends StatelessWidget {
  WelcomeContent({
    Key key,
    @required this.steps,
    @required this.controller,
    @required this.stepOnChanged,
  }) : super(key: key);

  final List<Widget> steps;

  final PageController controller;
  final ValueChanged<int> stepOnChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: stepOnChanged,
      itemCount: steps.length,
      //physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {

        return steps.elementAt(index);

        /*return LayoutBuilder(
          builder: (context, constraint) {
            return Scrollbar(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: steps.elementAt(index),
                ),
              ),
            );




          },
        );    */
      },
    );
  }
}
