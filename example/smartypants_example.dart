import 'package:smartypants/smartypants.dart';

void main() {
  String input = '"Hello" -- world!';
  String output = SmartyPants.formatText(input);
  print(output); // Print: “Hello” – world!
}