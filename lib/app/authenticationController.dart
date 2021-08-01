import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

enum AuthenticationStatus { loading, success, error, failed }

class AuthenticationController extends GetxController with StateMixin<bool> {
  Rxn<User> _user = Rxn<User>();
  FirebaseAuth auth;
  Rx<AuthenticationStatus> _authenticationStatus =
      AuthenticationStatus.loading.obs;

  Rx<AuthenticationStatus> get authStatus => _authenticationStatus;
  Rxn<User> get loggedInUser => _user;

  AuthenticationController(this.auth) {
    // auth.useEmulator('http://localhost:9099');
  }

  @override
  void onInit() {
    // _initialize();
    demoSignIn();

    super.onInit();
  }

  @override
  void change(bool? newState, {RxStatus? status}) {
    super.change(newState, status: status);
  }

  _initialize() {
    // _authenticationStatus.value = AuthenticationStatus.loading;
    change(false, status: RxStatus.loading());
    _user.bindStream(auth.authStateChanges());
    // _authenticationStatus.value = AuthenticationStatus.success;
    change(true, status: RxStatus.success());
  }

  demoSignIn() async {
    change(false, status: RxStatus.loading());

    await Future.delayed(Duration(seconds: 0), () {
      change(true, status: RxStatus.success());
    });
  }

  demoSignFailed() async {
    _authenticationStatus.value = AuthenticationStatus.loading;
    await Future.delayed(Duration(seconds: 1),
        () => _authenticationStatus.value = AuthenticationStatus.success);
  }
}
