import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/enumerator.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdSimpleTypeConverter implements XsdToDarConverter {
  const XsdSimpleTypeConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'simpleType' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }

    var onlyChild = findOnlyChild(xsdElement);
    if (onlyChild == null) {
      return const [];
    }

    var codeFromChildren = internalConverter.convertToDartCode(onlyChild);

    // return enumeration if it was created by ith child
    if (codeFromChildren.length == 1 && codeFromChildren.first is Enumeration) {
      return codeFromChildren;
    }

    var enumerationValues = codeFromChildren
        .whereType<EnumerationValueFromXsd>()
        .toSet();

    if (enumerationValues.isNotEmpty) {
      var name = findTypeName(internalConverter.namePathMapper, xsdElement);
      var enumeration = EnumerationFromXsd(name, enumerationValues, xsdElement);
      return [enumeration];
    }

    //So far only enumeration supported
    return const [];
  }
}
