
class ValidateField {

  String validateName(String value) {
    if (value.isEmpty) {
      return "Username is empty!";
    }
    final nameExp = RegExp(r'^[A-Za-z][A-Za-z0-9 _-]+$');
    if (!nameExp.hasMatch(value)) {
      return "Invalid character used!";
    }
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return "Email is empty!";
    }
    final mailExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!mailExp.hasMatch(value)) {
      return "Not a valid email!";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value == null || value.isEmpty) {
      return "Password is empty!";
    }

    if (value.length < 6) {
      return "Password is too short at least(6 character)!";
    }

    return null;
  }

  String validateVerify(String value) {
    if (value == null || value.isEmpty) {
      return "Code is empty!";
    }

    if (int.tryParse(value)==null) {
      return "Not a valid! or Should be 6 digits!";
    }

    if (value.length != 6 ) {
      return "Code Should be 6 digits!";
    }
    return null;
  }


}