import 'package:xsd_to_dart_code/generator/add_xml_methods.dart';
import 'package:xsd_to_dart_code/generator/update_references.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
import 'package:xsd_to_dart_code/generator/add_choice_interfaces.dart';
import 'package:xsd_to_dart_code/generator/add_constructors.dart';
import 'package:xsd_to_dart_code/generator/write_result_to_file.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/plural.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/simple_type_converter.dart';

abstract class XsdToDartGeneratorStep {
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries);
}

class XsdToDartGenerator {
  final OutputPathConverter outputPathConverter;
  final NamePathMapper namePathMapper;
  final XsdPluralConverter pluralConverter;
  final SimpleTypeConverters simpleTypeConverters;
  final List<XsdToDarConverter> converters;

  XsdToDartGenerator({
    this.namePathMapper = const DefaultNamePathMapper(),
    this.converters = defaultConverters,
    XsdPluralConverter? pluralConverter,
    SimpleTypeConverters? simpleTypeConverters,
    OutputPathConverter? outputPathConverter,
  }) : pluralConverter = pluralConverter ?? XsdPluralConverter(),
       outputPathConverter = outputPathConverter ??=
           DefaultOutputPathConverter(),
       simpleTypeConverters =
           simpleTypeConverters ?? DefaultSimpleTypeConverters();

  late final steps = <XsdToDartGeneratorStep>[
    AddChoiceInterfaces(),
    // MergeEqualClasses(),
    // CheckIfLibraryMemberNamesAreUnique(),
    UpdateReferences(namePathMapper, outputPathConverter),
    AddConstructors(),
    AddXmlMethods(outputPathConverter, simpleTypeConverters),
    WriteResultToFile(outputPathConverter),
  ];

  List<LibraryFromXsd> process(List<Schema> schemas) {
    var converter = InternalConverter(
      converters: converters,
      namePathMapper: namePathMapper,
      pluralConverter: pluralConverter,
      simpleTypeConverters: simpleTypeConverters,
    );
    List<LibraryFromXsd> libraries = [];
    for (var schema in schemas) {
      var code = converter.convertToDartCode(schema);
      var newLibrary = code.first as LibraryFromXsd;
      libraries.add(newLibrary);
    }
    for (var step in steps) {
      libraries = step.process(libraries);
    }
    return libraries;
  }
}
