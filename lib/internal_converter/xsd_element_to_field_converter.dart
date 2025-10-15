import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/field.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdElementToFieldConverter implements XsdToDarConverter {
  const XsdElementToFieldConverter();
  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'element' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }

    var field = createFieldFromXsdElement(internalConverter, xsdElement);
    return [field];
  }
}
