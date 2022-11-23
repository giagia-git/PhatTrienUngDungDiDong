void main() {
  var users = <int>[1,2,3,4,5,6];
  users.add(8);
  var rsl = users.where((element) => element<6);
  print(rsl);

}