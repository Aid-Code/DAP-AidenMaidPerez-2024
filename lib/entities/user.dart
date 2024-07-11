class User {
  final String user;
  final String pass;

  User(this.user, this.pass);

  bool validateUser(String inputUser, String inputPass) {
    if (user == inputUser && pass == inputPass) {
      return true;
    } else {
      return false;
    }
  }
}
