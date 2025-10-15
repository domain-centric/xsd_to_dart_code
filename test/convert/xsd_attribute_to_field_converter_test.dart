import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd_attribute_to_field_converter.dart';

import 'xml_util.dart';

void main() {
  group('XsdElementToFieldConverter class', () {
    late InternalConverter converter;
    setUp(() {
      converter = InternalConverter(
        converters: [XsdAttributeToFieldConverter()],
      );
    });
    test('xsd:element should return no code', () {
      var element = toSchemaElement(
        '<xsd:element name="version" type="xsd:decimal"/>',
      );
      converter.convertToDartCode(element).should.beEmpty();
    });

    test('xsd:attribute should return a correct Field', () {
      var element = toSchemaElement(
        '<xsd:attribute name="version" type="xsd:decimal"/>',
      );
      var code = converter.convertToDartCode(element).toString();
      code.should.be('[final double version;]');
    });
    test(
      'xsd:attribute with maxOccurs="unbounded" should return a correct Field',
      () {
        var element = toSchemaElement(
          '<xsd:attribute name="name" type="xsd:string"  maxOccurs="unbounded"/>',
        );
        var code = converter.convertToDartCode(element).toString();
        code.should.be('[final List<String> names;]');
      },
    );

    //TODO more tests for createTypeFromChild
  });
}
