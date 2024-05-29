class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "يرجا ادخال البريد الالكتروني";
    }

    final emailRegex = RegExp(r"[^\s@]+@[^\s@]+\.[^\s@]+");
    if (!emailRegex.hasMatch(value)) {
      return "صيغة البريد الالكتروني غير صحيحة";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "يتطلب ادخال رمز الدخول";
    }

    const minLength = 6;
    if (value.length < minLength) {
      return "خطا رمز الدخول اقل من 6 مراتب";
    }

    return null;
  }
}
