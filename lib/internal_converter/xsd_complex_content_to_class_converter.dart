import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdComplexContentToClassConverter implements XsdToDarConverter {
  const XsdComplexContentToClassConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'complexContent' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }
    var onlyChild = findOnlyChild(xsdElement);
    if (onlyChild == null) {
      return const [];
    }
    verifyElementName(onlyChild, 'extension');

    var code = internalConverter.convertToDartCode(onlyChild);
    return code;
  }
}
