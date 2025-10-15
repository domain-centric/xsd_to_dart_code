import 'package:xml/xml.dart';

XmlElement toSchemaElement(String innerXml) {
  var input =
      '<?xml version="1.0" encoding="UTF-8"?>'
      '<xsd:schema xmlns:ppx="www.iec.ch/public/TC65SC65BWG7TF10" '
      'xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
      'xmlns:xhtml="http://www.w3.org/1999/xhtml" '
      'targetNamespace="www.iec.ch/public/TC65SC65BWG7TF10" '
      'elementFormDefault="qualified" attributeFormDefault="unqualified" '
      'version="1.0">'
      '$innerXml'
      '</xsd:schema>';
  var doc = XmlDocument.parse(input);
  return doc.rootElement.childElements.first;
}
