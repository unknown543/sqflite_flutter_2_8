class Validator {
  String? isNUllCheck(String? value) {
    value = value ?? "";
    if (value.replaceAll(" ", "").isEmpty) {
      return "Field is Required";
    }
    return null;
  }

  String? isEmail(String? value) {
    var pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
        r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
        r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    value = value ?? '';
    bool isValid = RegExp(pattern).hasMatch(value);
    if (value.replaceAll(" ", "").isEmpty) {
      return "Email is Required";
    } else if (!isValid) {
      return "Enter Valid Email Address";
    }
    return null;
  }
}
