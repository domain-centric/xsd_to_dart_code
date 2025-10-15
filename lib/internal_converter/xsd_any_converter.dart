import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdAnyConverter implements XsdToDarConverter {
  const XsdAnyConverter();
  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'any' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }

    var clasz = ClassFromXsd(
      'Anything',
      xsdElement: xsdElement,
      modifier: ClassModifier.abstract_interface,
    );
    return [clasz];
  }
}
