import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd_complex_type_to_class_converter.dart';

import 'xml_util.dart';

void main() {
  group('XsdComplexTypeToClassConverter class', () {
    late InternalConverter converter;
    setUp(() {
      converter = InternalConverter(
        converters: [XsdComplexTypeToClassConverter()],
      );
    });
    test(
      'xsd:complexType abstract is true, no fields should return correct code',
      () {
        var element = toSchemaElement(
          '  <xsd:complexType name="TextBase" abstract="true"/>',
        );
        converter
            .convertToDartCode(element)
            .toString()
            .should
            .be('[abstract class TextBase {}]');
      },
    );
  });
}
