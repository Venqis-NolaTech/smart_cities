import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:meta/meta.dart';

import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/user_exist_use_case.dart';

enum AuthMethod {
  login,
  register,
}

enum PhoneAuthState {
  idle,
  started,
  codeSent,
  verified,
  failed,
  autoRetrievalTimeOut
}

abstract class PhoneNumberAuthProvider extends BaseProvider {
  PhoneNumberAuthProvider({
    @required this.firebaseAuth,
    @required this.userExistUseCase,
    bool inTest,
  }) : super(inTest: inTest);

  final fAuth.FirebaseAuth firebaseAuth;
  final UserExistUseCase userExistUseCase;

  PhoneAuthState _phoneAuthState = PhoneAuthState.idle;

  PhoneAuthState get phoneAuthState => _phoneAuthState;

  set phoneAuthState(PhoneAuthState newValue) {
    _phoneAuthState = newValue;
    notifyListeners();
  }

  User _user;

  User get user => _user;

  String actualCode;
  fAuth.AuthCredential authCredential;

  Function codeSendCallback;
  Function failureCallback;
  Function codeAutoRetrievalTimeoutCallback;
  Function signInWithCredentialCallback;

  Future<void> signInWithCredential(
    fAuth.AuthCredential authCredential,
    Function callback,
  );

  Future<bool> userExist(String phoneNumber, String dni, String email) async {
    state = Loading();

    final failureOrExist = await userExistUseCase(UserExistParam(email: email, dni: dni, phoneNumber: phoneNumber));

    //state = Loaded();

    return failureOrExist.fold(
      (failure) {
        state = Error(failure: failure);
        return true;
      },
      (exist) {
        state = Loaded();
        return false;
      },
    );
  }

  Future<void> resendCode(String phoneNumber) {
    return sendPhoneNumber(phoneNumber);
  }

  Future<void> sendPhoneNumber(String phoneNumber) async {
    print('phoneNumber ${phoneNumber} ');

    final fAuth.PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) {
      actualCode = verificationId;
      print('codeSent');
      if (codeSendCallback != null) codeSendCallback();

      phoneAuthState = PhoneAuthState.codeSent;

      state = Loaded();
    };

    final codeAutoRetrievalTimeout = (String verificationId) {
      actualCode = verificationId;

      if (codeAutoRetrievalTimeoutCallback != null)
        codeAutoRetrievalTimeoutCallback();

      phoneAuthState = PhoneAuthState.autoRetrievalTimeOut;
      state = Loaded();
    };

    final fAuth.PhoneVerificationFailed verificationFailed = (fAuth.FirebaseAuthException authException) {
      print('PhoneVerificationFailed ${authException.message} ${authException.phoneNumber}');
      if (failureCallback != null) failureCallback();

      phoneAuthState = PhoneAuthState.failed;
      state = Loaded();
    };

    final fAuth.PhoneVerificationCompleted verificationCompleted = (fAuth.AuthCredential authCredential) async {
      print('verificationCompleted');

      this.authCredential = authCredential;
      phoneAuthState = PhoneAuthState.started;
      await signInWithCredential(authCredential, signInWithCredentialCallback);

      phoneAuthState = PhoneAuthState.verified;
      state = Loaded();
    };

    phoneAuthState = PhoneAuthState.started;

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> signInWithSMSCode(String smsCode) {
    final authCredential = fAuth.PhoneAuthProvider.credential(
      verificationId: actualCode,
      smsCode: smsCode,
    );

    this.authCredential = authCredential;

    return signInWithCredential(authCredential, signInWithCredentialCallback);
  }
}
