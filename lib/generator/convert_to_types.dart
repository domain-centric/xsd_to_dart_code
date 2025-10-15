// import 'package:xsd_to_dart_code/generator/generator.dart';
// import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
// import 'package:dart_code/dart_code.dart';
// import 'package:xml/xml.dart';
// import 'package:xsd_to_dart_code/internal_converter/plural.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_any_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_attribute_group_to_fields_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_attribute_to_field_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_choice_to_type_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_complex_content_to_class_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_enumeration_to_enumeration_value_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_extension_to_class_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_complex_type_to_class_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_element_to_field_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_group_to_fields_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_restriction_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_schema_to_library_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_sequence_to_fields_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_simple_type_converter.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd_union_converter.dart';
// import 'package:xsd_to_dart_code/logger/logger.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
// import 'package:xsd_to_dart_code/internal_converter/xsd/simple_type_mapper.dart';

// /// converts Xsd elements to enumerations or (abstract interface) classes with fields
// class ConvertToTypes implements XsdToDartGeneratorStep {
//   final SimpleTypeMapper simpleTypeMapper;
//   final NamePathMapper namePathMapper;
//   final XsdPluralConverter pluralConverter;
//   final List<XsdToDarConverter> converters;

//   ConvertToTypes({
//     this.simpleTypeMapper = const DefaultSimpleTypeMapper(),
//     this.namePathMapper = const DefaultNamePathMapper(),
//     this.converters = defaultConverters,
//     XsdPluralConverter? pluralConverter,
//   }) : pluralConverter = pluralConverter ?? XsdPluralConverter();

//   @override
//   List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
//     var converter = InternalConverter(
//       converters: converters,
//       namePathMapper: namePathMapper,
//       pluralConverter: pluralConverter,
//       simpleTypeMapper: simpleTypeMapper,
//     );
//     List<LibraryFromXsd> newLibraries = [];
//     for (var library in libraries) {
//       var code = converter.convertToDartCode(library.schema);
//       var newLibrary = code.first as LibraryFromXsd;
//       newLibraries.add(newLibrary);
//     }
//     return newLibraries;
//   }
// }

// abstract class XsdToDarConverter {
//   /// Converts an Xml schema element to one or more Dart code artifacts
//   /// Returns an empty list if the [XsdToDarConverter] could not convert anything
//   /// [xsdElement] can be a xsd:schema element or any of its children
//   List<CodeModel> convertToDartCode(
//     InternalConverter internalConverter,
//     XmlElement xsdElement,
//   );
// }

// const defaultConverters = <XsdToDarConverter>[
//   XsdSchemaToLibraryConverter(),
//   XsdComplexTypeToClassConverter(),
//   XsdComplexContentToClassConverter(),
//   XsdExtentionToClassConverter(),
//   XsdSequenceToFieldsConverter(),
//   XsdGroupToFieldsConverter(),
//   XsdAttributeGroupToFieldsConverter(),
//   XsdElementToFieldConverter(),
//   XsdAttributeToFieldConverter(),
//   XsdAnyConverter(),
//   XsdSimpleTypeConverter(),
//   XsdUnionConverter(),
//   XsdRestrictionConverter(),
//   XsdEnumerationToEnumerationValueConverter(),
//   XsdChoiceToTypeConverter(),
// ];

// /// converts (almost) any Xsd element in a xml schema to dart code
// /// by delegating the work to its internal [converters]
// class InternalConverter {
//   final SimpleTypeMapper simpleTypeMapper;
//   final NamePathMapper namePathMapper;
//   final XsdPluralConverter pluralConverter;
//   final List<XsdToDarConverter> converters;

//   InternalConverter({
//     this.simpleTypeMapper = const DefaultSimpleTypeMapper(),
//     this.namePathMapper = const DefaultNamePathMapper(),
//     this.converters = defaultConverters,
//     XsdPluralConverter? pluralConverter,
//   }) : pluralConverter = pluralConverter ?? XsdPluralConverter();

//   List<CodeModel> convertToDartCode(XmlElement xsdElement) {
//     for (var converter in converters) {
//       var code = converter.convertToDartCode(this, xsdElement);
//       if (code.isNotEmpty) {
//         return code;
//       }
//     }
//     log.warning('${lookUpText(xsdElement)}: could not be converted');
//     return const [];
//   }

//   List<CodeModel> convertZeroOrMoreChildrenToDartCode(XmlElement xsdElement) =>
//       xsdElement.childElements
//           .map((childElement) => convertToDartCode(childElement))
//           .expand((code) => code)
//           .toList();
// }

// XmlElement? findOnlyChild(XmlElement element) {
//   var children = element.childElements;
//   if (children.length != 1) {
//     log.warning('${lookUpText(element)}: expected to have a single child');
//     return null;
//   }
//   return children.first;
// }
