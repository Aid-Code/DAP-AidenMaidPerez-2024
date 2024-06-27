class User
{
  String? user;
  String? pass;

  User(this.user, this.pass);

  bool validateUser (inputUser, inputPass)
  {
    if(user == inputUser && pass == inputPass)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
}