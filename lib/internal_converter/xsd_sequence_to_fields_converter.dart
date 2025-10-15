import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdSequenceToFieldsConverter implements XsdToDarConverter {
  const XsdSequenceToFieldsConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'sequence' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }
    var code = internalConverter.convertZeroOrMoreChildrenToDartCode(
      xsdElement,
    );
    return code;
  }
}
