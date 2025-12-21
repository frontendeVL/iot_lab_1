import 'package:my_project/models/user_model.dart';
import 'package:my_project/repositories/i_auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepository implements IAuthRepository {
  
  // Зберігаємо юзера в телефон
  @override
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('password', user.password);
  }

  // Читаємо юзера з телефона
  @override
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    // Якщо пошти нема — значить ніхто не реєструвався
    if (email == null) return null;
    
    return UserModel(
      name: name ?? '', 
      email: email, 
      password: password ?? '',
    );
  }
}
