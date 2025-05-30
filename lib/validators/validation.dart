class PSValidator {
  // Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return "field_name_required";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'invalid_email_address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required';
    }

    if (value.length < 8) {
      return 'password_minimum_length';
    }

    // Uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'password_uppercase_required';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'password_lowercase_required';
    }

    // Numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'password_number_required';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'phone_number_required';
    }

    final phoneRegExp = RegExp(r'^\d{8}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'invalid_phone_number_format';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? confirmPassword) {
    if (value == null || value.isEmpty) {
      return 'password_required';
    }
    if (value != confirmPassword) {
      return "passwords_do_not_match";
    }
    return null;
  }
}
