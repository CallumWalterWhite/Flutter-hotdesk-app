
class Position {
  final int id;
  final double posX;
  final double posY;
  final String type;

  Position(this.id, this.posX, this.posY, this.type);

  //take documentSnapshot and extracts the data to create a Position object
  static Position create(dynamic documentSnapshot){
    Position position =
    Position(
      int.parse(documentSnapshot["id"].toString()),
      double.parse(documentSnapshot["posX"].toString()),
      double.parse(documentSnapshot["posY"].toString()),
      (documentSnapshot["type"].toString())
    );
    return position;
  }
}