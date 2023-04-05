import 'package:notes_app/providers/shoppinglistprovider.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ShoppingThingOBx {
  @Id()
  int id;
  String uuid;
  String listUuid;
  bool bought;

  ShoppingThingOBx(this.uuid, this.listUuid, this.bought, {this.id = 0});

  final list = ToOne<ShoppingListOBx>();
}

@Entity()
class ShoppingListOBx {
  @Id()
  int id;
  String uuid;
  String name;
  String description;

  ShoppingListOBx(this.uuid, this.name, this.description, {this.id = 0});
}

@Entity()
class PastThingOBx {
  @Id()
  int id;
  String uuid;
  String listUuid;
  bool bought;

  PastThingOBx(this.uuid, this.listUuid, this.bought, {this.id = 0});

  final list = ToOne<PastShoppingOBx>();
}

class PastShoppingOBx {
  @Id()
  int id;
  String uuid;
  String name;
  String listUuid;
  @Property(type: PropertyType.date)
  DateTime time;
  int cost;

  PastShoppingOBx(this.uuid, this.name, this.listUuid, this.time, this.cost,
      {this.id = 0});
}
