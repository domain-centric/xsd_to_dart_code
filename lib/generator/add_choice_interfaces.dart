import 'package:dart_code/dart_code.dart';
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';

class AddChoiceInterfaces implements XsdToDartGeneratorStep {
  /// Lets classes implement the interface from xsd:choice
  AddChoiceInterfaces();

  @override
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
    var processedLibraries = <LibraryFromXsd>[];

    for (var library in libraries) {
      var classes = (library.classes ?? []).cast<ClassFromXsd>();

      var xsdChoiceTypes = classes.whereType<InterfaceFromXsdChoice>().map(
        (c) => c.typeFromXsdChoice,
      );

      var newClasses = <ClassFromXsd>[];

      for (var clasz in classes) {
        var toImplement = findTypesToImplement(clasz, xsdChoiceTypes);
        if (toImplement.isEmpty) {
          newClasses.add(clasz);
        } else {
          newClasses.add(letClassImplement(clasz, toImplement));
        }
      }
      var newLibrary = library.copyWith(classes: newClasses);
      processedLibraries.add(newLibrary);
    }
    return processedLibraries;
  }

  List<TypeFromXsdChoice> findTypesToImplement(
    Class clasz,
    Iterable<TypeFromXsdChoice> xsdChoiceTypes,
  ) {
    var className = clasz.name.toString();
    var implementedNames = (clasz.implements ?? []).map((type) => type.name);
    var typesToImplement = <TypeFromXsdChoice>[];
    for (var xsdChoiceType in xsdChoiceTypes) {
      var classNamesToFind = xsdChoiceType.typesThatImplementThisType.map(
        (t) => t.name,
      );
      if (!implementedNames.contains(xsdChoiceType.name) &&
          classNamesToFind.contains(className)) {
        typesToImplement.add(xsdChoiceType);
      }
    }
    return typesToImplement;
  }

  ClassFromXsd letClassImplement(
    Class clasz,
    List<TypeFromXsdChoice> toImplement,
  ) => (clasz as ClassFromXsd).copyWith(
    implements: [
      if (clasz.implements != null) ...clasz.implements!,
      ...toImplement,
    ],
  );
}
