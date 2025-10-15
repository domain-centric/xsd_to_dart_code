import 'package:plural_noun/plural_noun.dart';

class XsdPluralConverter extends PluralEngine {
  XsdPluralConverter([super.ruleSet]);

  @override
  // ignore: avoid_renaming_method_parameters
  String convertToPluralNoun(String identifierName) {
    var words = splitCamelCase(identifierName);
    var lastWordToPlural = super.convertToPluralNoun(words.last);
    var newWords = [
      if (words.length > 1) ...words.sublist(0, words.length - 1),
      lastWordToPlural,
    ];
    return newWords.join();
  }

  List<String> splitCamelCase(String input) {
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    return input.split(regex);
  }
}
