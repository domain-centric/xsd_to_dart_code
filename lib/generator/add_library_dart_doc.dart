import 'package:dart_code/dart_code.dart';
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';

class AddLibraryDartDoc implements XsdToDartGeneratorStep {
  final DartDocFactory dartDocFactory;

  AddLibraryDartDoc({required this.dartDocFactory});

  @override
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
    var processedLibraries = <LibraryFromXsd>[];

    for (var library in libraries) {
      var docText = dartDocFactory.createDartDocText(library);
      var docComments = DocComment.fromString(docText);
      var newLibrary = library.copyWith(docComments: [docComments]);
      processedLibraries.add(newLibrary);
    }
    return processedLibraries;
  }
}

abstract class DartDocFactory {
  String createDartDocText(LibraryFromXsd library);
}

class DefaultDartDocFactory extends DartDocFactory {
  @override
  String createDartDocText(LibraryFromXsd library) =>
      'This library was created by the [xsd_to_dart_code](TODO URI) package and should not be modified\n'
      'Customize by extending classes or make extensions\n'
      'Source: ${library.schema.xsdFile}';
}
