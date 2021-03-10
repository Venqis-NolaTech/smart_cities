import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:smart_cities/src/features/route/presentation/provider/route_provider.dart';
import 'package:smart_cities/src/features/route/presentation/widget/location_see_route.dart';
import 'package:smart_cities/src/features/route/presentation/widget/map_see_route.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';



class SeeRoute extends StatefulWidget {

  SeeRoute({Key key}) : super(key: key);

  @override
  _SeeRouteState createState() => _SeeRouteState();
}

class _SeeRouteState extends State<SeeRoute> {
  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {

    return BaseView<RouteProvider>(
      builder: (context, provider, child ){
        final currentState = provider.currentState;

        return ModalProgressHUD(
          inAsyncCall: provider.currentState is Loading,
          child: Stack(
            children: [

              IndexedStack(
                index: _stepIndex,
                children: [
                  LocationSeeRoute(provider: provider, onSeeRoute: onSeeRoute),
                  MapSeeRoute(provider: provider, onChange: (){
                    setState(() {
                      _stepIndex = 0;
                    });
                  },),
                ],
              ),


            ],
          )
        );
      }
    );



  }



  void onSeeRoute() {

    setState(() {
      _stepIndex=1;
    });
  }
}