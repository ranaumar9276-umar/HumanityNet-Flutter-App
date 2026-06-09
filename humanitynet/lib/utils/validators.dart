class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email required hai';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Valid email enter karo';
    }
    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password required hai';
    }
    if (value.length < 8) {
      return 'Password kam se kam 8 characters ka hona chahiye';
    }
    return null;
  }

  // Confirm password
  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Password confirm karo';
    }
    if (value != original) {
      return 'Passwords match nahi kar rahe';
    }
    return null;
  }

  // Full name
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Naam required hai';
    }
    if (value.trim().length < 3) {
      return 'Naam kam se kam 3 characters ka hona chahiye';
    }
    return null;
  }

  // Phone number
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number required hai';
    }
    if (value.trim().length < 10) {
      return 'Valid phone number enter karo';
    }
    return null;
  }

  // City
  static String? city(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City required hai';
    }
    return null;
  }

  // Request title
  static String? requestTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title required hai';
    }
    if (value.trim().length < 10) {
      return 'Title kam se kam 10 characters ka hona chahiye';
    }
    if (value.trim().length > 60) {
      return 'Title 60 characters se zyada nahi ho sakta';
    }
    return null;
  }

  // Request description
  static String? requestDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description required hai';
    }
    if (value.trim().length < 20) {
      return 'Description kam se kam 20 characters ki honi chahiye';
    }
    if (value.trim().length > 300) {
      return 'Description 300 characters se zyada nahi ho sakti';
    }
    return null;
  }

  // Generic required field
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName required hai';
    }
    return null;
  }
}