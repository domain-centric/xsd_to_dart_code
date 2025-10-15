import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';

// Enumeration? createEnumerationFromXsdElement(
//   NamePathMapper namePathMapper,
//   XmlElement xsdElement,
// ) {
//   var name = findTypeName(namePathMapper, xsdElement);

//   var enumerationElements = xsdElement
//       .findAllElements('enumeration', namespace: xsdNamespaceUri)
//       .toList();
//   if (enumerationElements.isEmpty) {
//     throw ArgumentError('restriction does not have any enumeration children');
//   }

//   var enumValues = <EnumerationValueFromXsd>{};
//   for (var enumElement in enumerationElements) {
//     var xmlEnumValue = enumElement.getAttribute('value');
//     var dartEnumValue = toValidDartNameStartingWitLowerCase(
//       xmlEnumValue ?? '',
//     ).toString();
//     var enumValue = EnumerationValueFromXsd(
//       xmlValue: xmlEnumValue!,
//       dartValue: dartEnumValue,
//     );
//     enumValues.add(enumValue);
//   }

//   if (enumValues.isEmpty) {
//     throw ArgumentError('No valid enumeration values found');
//   }

//   return EnumerationFromXsd(name, enumValues, xsdElement);
// }

class EnumerationFromXsd extends Enumeration {
  final XmlElement xsdElement;

  EnumerationFromXsd(
    super.name,
    super.values,
    this.xsdElement, {
    super.docComments,
    super.annotations,
    super.implements,
    super.constructor,
    super.methods,
  });
}

/// convenience class for XML conversion
class EnumerationValueFromXsd extends EnumValue {
  final String dartValue;
  final String xmlValue;
  EnumerationValueFromXsd({required this.dartValue, required this.xmlValue})
    : super(dartValue);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumerationValueFromXsd &&
          runtimeType == other.runtimeType &&
          dartValue == other.dartValue &&
          xmlValue == other.xmlValue;

  @override
  int get hashCode => dartValue.hashCode ^ xmlValue.hashCode;
}
