import 'dart:io';

import 'package:dart_code/dart_code.dart';
import 'package:path/path.dart' as p;
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/generator/write_result_to_file.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';

class AddXmlConverterLibraries implements XsdToDartGeneratorStep {
  final OutputPathConverter outputPathConverter;
  AddXmlConverterLibraries(this.outputPathConverter);

  @override
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
    var xmlConvertionLibraries = <LibraryFromXsd>[];
    for (var library in libraries) {
      var xmlConvertionLibrary = createXmlConversionLibrary(library);
      xmlConvertionLibraries.add(xmlConvertionLibrary);
    }
    return [...libraries, ...xmlConvertionLibraries];
  }

  LibraryFromXsd createXmlConversionLibrary(LibraryFromXsd library) {
    var file = dartFile(outputPathConverter, library);
    final filename = p.basename(file.path);
    final relativeLibraryUri = filename;

    var extensions = <Extension>[];
    for (var clasz in library.classes ?? <Class>[]) {
      if (clasz is ClassFromXsd &&
          clasz.modifier != ClassModifier.abstract &&
          clasz.modifier != ClassModifier.abstract_interface) {
        var classExtension = createClassExtension(relativeLibraryUri, clasz);
        extensions.add(classExtension);
      }
    }
    // for (var enumeration in library.enumerations ?? []) {
    //   var enumExtension = createEnumExtension(enumeration);
    //   extensions.add(enumExtension);
    // }

    return LibraryFromXsd(
      schema: library.schema,
      extensions: extensions,
      fileNameConverter: fileNameConverter,
    );
  }

  // e.g,: extension ProjectXmlConverterExtension on Project {
  // XmlElement toXml() => XmlElement(XmlName('Project'));
  //}
  Extension createClassExtension(
    String relativeLibraryUri,
    ClassFromXsd clasz,
  ) => Extension(
    '${clasz.name.toString()}XmlConverterExtension',
    Type(clasz.name.toString(), libraryUri: relativeLibraryUri),
    methods: [createToXmlMethod(clasz)],
  );

  static final xmlElementType = Type(
    'XmlElement',
    libraryUri: 'package:xml/xml.dart',
  );
  static final xmlNameType = Type(
    'XmlName',
    libraryUri: 'package:xml/xml.dart',
  );

  // e.g:XmlElement toXml() => XmlElement(XmlName('Project'));
  Method createToXmlMethod(ClassFromXsd clasz) => Method(
    'toXml',
    Expression.callConstructor(
      xmlElementType,
      parameterValues: ParameterValues([
        ParameterValue(
          Expression.callConstructor(
            xmlNameType,
            parameterValues: ParameterValues([
              ParameterValue(
                Expression.ofString(findXsdName(clasz.xsdElement)!),
              ),
              //TODO add attributes from fields
              //TODO add elements from fields
            ]),
          ),
        ),
      ]),
    ),
    returnType: xmlElementType,
  );

  File fileNameConverter(File file) => File(
    file.path.replaceAll(
      RegExp(r'.dart$', caseSensitive: false),
      '_xml_convertion.dart',
    ),
  );
}
