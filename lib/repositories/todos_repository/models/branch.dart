import 'package:meta/meta.dart';

import 'models.dart';

class Branch {
  String title;

  ColorTheme theme;

  List<Todo> todos;

  Branch({@required this.title, @required this.theme, @required this.todos});
}
