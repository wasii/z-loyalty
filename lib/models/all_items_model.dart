class AllItemsResponse {
  final int error;
  final List<Item> items;

  AllItemsResponse({required this.error, required this.items});

  factory AllItemsResponse.fromJson(Map<String, dynamic> json) {
    return AllItemsResponse(
      error: int.tryParse(json['error'].toString()) ?? 0,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'error': error, 'items': items.map((e) => e.toJson()).toList()};
  }
}

class Item {
  final String id;
  final String name;

  Item({required this.id, required this.name});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
