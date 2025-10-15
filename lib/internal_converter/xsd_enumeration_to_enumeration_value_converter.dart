import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/enumerator.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdEnumerationToEnumerationValueConverter implements XsdToDarConverter {
  const XsdEnumerationToEnumerationValueConverter();
  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'enumeration' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }
    var xmlValue = xsdElement.getAttribute('value');
    if (xmlValue == null) {
      log.warning(
        '${lookUpText(xsdElement)}: expected to have a value attribute',
      );
      return const [];
    }
    var dartValue = toValidDartNameStartingWitLowerCase(xmlValue);
    var enumerationValue = EnumerationValueFromXsd(
      xmlValue: xmlValue,
      dartValue: dartValue,
    );
    return [enumerationValue];
  }
}
