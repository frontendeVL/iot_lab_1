class AppValidators {
  // Перевірка пошти: шукаємо собачку @
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Поле порожнє';
    if (!value.contains('@')) return 'Пошта має містити @';
    return null; // Значить все добре
  }

  // Перевірка імені: шукаємо цифри
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Введіть ім\'я';
    // Якщо в тексті є цифри від 0 до 9
    if (value.contains(RegExp(r'[0-9]'))) return 'Ім\'я не може мати цифр';
    return null;
  }

  // Перевірка пароля: щоб не був занадто коротким
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Введіть пароль';
    if (value.length < 6) return 'Пароль має бути від 6 символів';
    return null;
  }
}
