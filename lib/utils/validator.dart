class Validator {
  static final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static bool isValidEmail(String email) {
    if (email.isEmpty) {
      return false;
    }

    if (emailRegex.hasMatch(email.trim())) {
      return true;
    } else {
      return false;
    }
  }

}