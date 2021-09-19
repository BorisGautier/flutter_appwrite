class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidTelephone(String telephone) {
    return telephone.length == 9 ? true : false;
  }

  static isValidMatricule(String matricule) {
    return matricule.length == 10 || matricule.length == 11 ? true : false;
  }

  static isValidCPassword(String password, String cPassword) {
    return cPassword == password ? true : false;
  }
}
