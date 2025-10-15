import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdComplexTypeToClassConverter implements XsdToDarConverter {
  const XsdComplexTypeToClassConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'complexType' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }
    var isAbstract = xsdElement.getAttribute('abstract') == 'true';
    var modifier = isAbstract ? ClassModifier.abstract : null;
    var clasz = createClassFromXsdElement(
      internalConverter,
      xsdElement,
      modifier: modifier,
    );
    return [clasz];
  }
}
