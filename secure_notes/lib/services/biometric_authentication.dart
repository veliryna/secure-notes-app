import 'package:local_auth/local_auth.dart';

class BiometricAuthentication {
  Future<bool> authenticate() async {
    final LocalAuthentication localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to continue',
        );
        return didAuthenticate;
      } else {
        print('Biometric authentication is not available');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}


