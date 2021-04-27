import 'package:flutter/material.dart';
import 'package:smart_cities/src/di/injection_container.dart';


class ChatUtil {
  void openPersonalChat(
      {@required BuildContext context,
      @required String partnerId,
      bool popScreen = false}) async {
   /* final getPersonalChatRoomUseCase = sl.get<GetPersonalChatRoomUseCase>();
    // Verificando el chat
    final chatRoom = await getPersonalChatRoomUseCase(partnerId);
    final socketTransaction = sl.get<SocketTransactionValidator>();

    chatRoom.fold((l) {
      print(l);
      if (l == UnauthorisedFailure()) {
        showDialog(
            context: context,
            builder: (context) {
              return InfoAlertDialog(
                image: AppImages.failure,
                message: S.of(context).cannotChatYourself,
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return InfoAlertDialog(
                image: AppImages.failure,
                message: S.of(context).unexpectedErrorMessage,
              );
            });
      }
    }, (room) {
      if (popScreen) {
        Navigator.pop(context);
      }
      homePage?.moveToPage(HomePages.chat, callback: (_) {
        Future.delayed(Duration(milliseconds: 250), () async {
          // actualizando la data local
          await socketTransaction.fetchRooms();
          roomList?.gotoChatDetails(room);
        });
      });
    });*/
  }
}
