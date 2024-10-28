class UPIApp {
  final String name;
  final List<int> icon;
  final String packageName;

  static UPIApp fromMap(Map data) {
    return UPIApp(
      name: data['name'],
      icon: data['icon'],
      packageName: data['packageName'],
    );
  }

  UPIApp({required this.name, required this.icon, required this.packageName});
}
