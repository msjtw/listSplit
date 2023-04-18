double? correctCost(String s) {
  if ('.'.allMatches(s).length + ','.allMatches(s).length > 1 || s.isEmpty) {
    return null;
  }

  String ret = "";
  for (int i = 0; i < s.length; i++) {
    if (s[i] == ',') {
      ret += '.';
    } else {
      ret += s[i];
    }
  }
  return double.parse(ret);
}
