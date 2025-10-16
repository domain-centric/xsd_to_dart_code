import 'package:xml/xml.dart';

import 'package:dart_code/dart_code.dart';
import 'package:change_case/change_case.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';

/// maps a Xsd type name path to a unique name
abstract class NamePathMapper {
  /// e.g. maps 'Work.Address' to 'BusinessAddress'
  /// returns null if there is no name mapping
  /// in this case the last part of the name path will be used
  String? toUniqueName(String xsdNamePath);
}

/// TODO implement automatic mapping by adding numbers to the name when the last path of the name part turns out to be not unique
class DefaultNamePathMapper implements NamePathMapper {
  final Map<
    /// xsd name path like 'Work.Address'
    String,

    /// unique Dart library member name like 'BusinessAddress'
    String
  >
  customMapping;

  const DefaultNamePathMapper([this.customMapping = const {}]);

  @override
  String? toUniqueName(String xsdNamePath) => customMapping[xsdNamePath];
}

/// FIXME: create a implementation that adds a number to make it unique, but also supports custom overrides

List<String> findXsdNamePath(
  XmlElement element, [
  List<String>? foundXsdNames,
]) {
  foundXsdNames = foundXsdNames ?? [];
  var nameAttribute = element.getAttribute('name');
  if (nameAttribute != null) {
    foundXsdNames.insert(0, nameAttribute);
  }
  if (element.parentElement == null) {
    return foundXsdNames;
  }
  var parent = element.parentElement!;
  return findXsdNamePath(parent, foundXsdNames);
}

String? findXsdName(XmlElement element) {
  var nameAttributeValue = element.getAttribute('name');
  if (nameAttributeValue != null) {
    return nameAttributeValue;
  }
  if (element.parentElement == null) {
    return null;
  }
  return findXsdName(element.parentElement!);
}

/// text to identify a xsdElement (e.g. for debugging)
String lookUpText(XmlElement xsdElement) =>
    '${xsdElement.qualifiedName} in ${findXsdNamePath(xsdElement).join('.')}';

String findTypeName(NamePathMapper namePathMapper, XmlElement xsdElement) {
  var namePathList = findXsdNamePath(xsdElement);
  if (namePathList.isEmpty) {
    throw ArgumentError('Xsd element or its parents have no name attribute');
  }

  var namePath = namePathList.join('.');
  var mappedName = namePathMapper.toUniqueName(namePath);
  if (mappedName != null) {
    return toValidDartNameStartingWitUpperCase(mappedName);
  }
  var name = namePathList.last;
  return toValidDartNameStartingWitUpperCase(name);
}

final RegExp _notLettersNumbersUnderscoreOrDollar = RegExp(r'[^\w\$]');

String toValidDartNameStartingWitLowerCase(String? name) {
  if (name == null) {
    throw ArgumentError("Name cannot be null");
  }

  var candidate = name.toCamelCase().toLowerFirstCase().replaceAll(
    _notLettersNumbersUnderscoreOrDollar,
    '',
  );
  if (KeyWord.allNames.contains(candidate)) {
    candidate = "$candidate\$";
  }

  /// throws an error when still invalid
  return IdentifierStartingWithLowerCase(candidate).toString();
}

String toValidDartNameStartingWitUpperCase(String? name) {
  if (name == null) {
    throw ArgumentError("Name cannot be null");
  }
  var candidate = name.toUpperFirstCase().replaceAll(
    _notLettersNumbersUnderscoreOrDollar,
    '',
  );
  if (KeyWord.allNames.contains(candidate)) {
    candidate = "$candidate\$";
  }

  /// throws an error when still invalid
  return IdentifierStartingWithUpperCase(candidate).toString();
}

/// Allows the developer to map names, e.g.:
/// {'ParameterSet.OutputVars.Variable': 'OutputVariable'}
typedef XsdNamePathToTypeNameMapping = Map<String, String>;

void verifyElementName(XmlElement element, String expectedElementName) {
  if (element.name.local != expectedElementName) {
    log.warning(
      '${lookUpText(element)}: expected element name: $expectedElementName',
    );
  }
}
