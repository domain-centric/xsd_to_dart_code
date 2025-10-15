import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';

class XsdExtentionToClassConverter implements XsdToDarConverter {
  const XsdExtentionToClassConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'extension' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }
    TypeFromXsdReference? superClass = createSuperClassType(xsdElement);
    var clasz = createClassFromXsdElement(
      internalConverter,
      xsdElement,
      superClass: superClass,
    );
    return [clasz];
  }

  TypeFromXsdReference? createSuperClassType(XmlElement xsdElement) {
    var base = xsdElement.getAttribute('base');
    if (base == null || base.isEmpty) {
      log.warning(
        '${lookUpText(xsdElement)}: expected a base attribute with a valid name',
      );
      return null;
    }
    var xsdElementName = base.split(":").last;
    var superClassName = toValidDartNameStartingWitUpperCase(xsdElementName);
    return TypeFromXsdReference.toLibraryMember(xsdElement, superClassName);
  }
}
