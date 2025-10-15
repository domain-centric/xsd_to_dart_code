import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdGroupToFieldsConverter implements XsdToDarConverter {
  const XsdGroupToFieldsConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'group' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }

    // is a group reference
    var ref = xsdElement.getAttribute('ref');
    if (ref != null) {
      var schema = Schema.of(xsdElement);
      var nameToFind = ref.split(':').last;
      var elements = schema
          .findAllElements('group', namespace: xsdNamespaceUri)
          .where((g) => g.getAttribute('name') == nameToFind);
      if (elements.length != 1) {
        log.warning(
          '${lookUpText(xsdElement)}: could not find a group named: $ref',
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
    var parent = findParent(xsdElement);

    var code = internalConverter.convertZeroOrMoreChildrenToDartCode(parent);
    var fieldCode = code.whereType<Field>().toList();
    if (fieldCode.length < code.length) {
      log.warning('${lookUpText(xsdElement)}: only xsd:element expected');
    }
    return fieldCode;
  }

  XmlElement findParent(XmlElement xsdElement) {
    var children = xsdElement.childElements;
    if (children.length == 1 &&
        ['sequence', 'choice'].contains(children.first.name.local)) {
      return children.first;
    }
    return xsdElement;
  }
}
