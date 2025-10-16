import 'dart:io';

import 'package:xml/xml.dart';

const String xsdNamespaceUri = 'http://www.w3.org/2001/XMLSchema';

/// represents a [Xml Schema Definition](https://en.wikipedia.org/wiki/XML_Schema_(W3C))
class Schema extends XmlElement {
  final File xsdFile;

  factory Schema.fromFile(File xsdFile) {
    var xmlString = xsdFile.readAsStringSync();
    var document = XmlDocument.parse(xmlString);
    return Schema(xsdFile, document);
  }

  factory Schema(File xsdFile, XmlDocument xsdDocument) {
    XmlElement? element = xsdDocument
        .findElements("schema", namespace: xsdNamespaceUri)
        .firstOrNull;

    if (element == null) {
      throw ArgumentError("No schema element found in XSD document");
    }
    return Schema.fromSchemaElement(xsdFile, element);
  }

  // factory Schema.of( XmlElement xsdElement, [File? xsdFile]) {
  //   var rootElement = _findRootElement(xsdElement);
  //   return Schema.fromSchemaElement(xsdFile, rootElement);
  // }

  Schema.fromSchemaElement(this.xsdFile, XmlElement schema)
    : super(
        schema.name.copy(),
        List<XmlAttribute>.from(schema.attributes.map((a) => a.copy())),
        List<XmlNode>.from(schema.children.map((c) => c.copy())),
        schema.isSelfClosing,
      );

  String? findNameSpaceUri(String nameSpacePrefixToFind) {
    for (var attribute in attributes) {
      if (attribute.name.prefix == 'xmlns' &&
          attribute.name.local == nameSpacePrefixToFind) {
        return attribute.value;
      }
    }
    return null;
  }

  late String? targetNameSpaceUri = getAttribute('targetNamespace');

  static Schema findAsParentOf(XmlElement xsdElement) {
    /// Return the root of the tree in which this node is found, whether that's
    /// a document or another element.
    var candidate = xsdElement;
    while (candidate.parentElement != null) {
      candidate = candidate.parentElement!;
    }
    return candidate as Schema;
  }
}
