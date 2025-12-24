// Простий модельний клас для елемента списку (API)
// Я зробила мінімальну структуру: ідентифікатор та заголовок
class Item {
  final int id;
  final String title;

  Item({required this.id, required this.title});

  factory Item.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['id'];
    final int idVal = rawId is int ? rawId : int.tryParse('$rawId') ?? 0;
    return Item(
      id: idVal,
      title: '${json['title']}',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}
