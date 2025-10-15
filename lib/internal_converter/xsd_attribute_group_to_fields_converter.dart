import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdAttributeGroupToFieldsConverter implements XsdToDarConverter {
  const XsdAttributeGroupToFieldsConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'attributeGroup' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }

    // is a group reference
    var ref = xsdElement.getAttribute('ref');
    if (ref != null) {
      var schema = Schema.of(xsdElement);
      var nameToFind = ref.split(':').last;
      var elements = schema
          .findAllElements('attributeGroup', namespace: xsdNamespaceUri)
          .where((g) => g.getAttribute('name') == nameToFind);
      if (elements.length != 1) {
        log.warning(
          '${lookUpText(xsdElement)}: could not find a attributeGroup named: $ref',
        );
        return const [];
      }
      var found = elements.first;
      var groupCode = internalConverter.convertToDartCode(found);
      return groupCode;
    }

    // is a named group containing elements
    var fields = findFields(internalConverter, xsdElement);
    return fields;
  }

  List<Field> findFields(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    var code = internalConverter.convertZeroOrMoreChildrenToDartCode(
      xsdElement,
    );
    var fieldCode = code.whereType<Field>().toList();
    if (fieldCode.length < code.length) {
      log.warning('${lookUpText(xsdElement)}: only xsd:element expected');
    }
    return fieldCode;
  }
}
