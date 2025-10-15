import 'package:collection/collection.dart';
import 'package:dart_code/dart_code.dart';
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';

class AddConstructors implements XsdToDartGeneratorStep {
  @override
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
    var newLibraries = <LibraryFromXsd>[];
    for (var library in libraries) {
      var newClasses = generateClassesWithConstructors(libraries, library);
      var newLibrary = library.copyWith(classes: newClasses);
      newLibraries.add(newLibrary);
    }
    return newLibraries;
  }

  List<ClassFromXsd> generateClassesWithConstructors(
    List<LibraryFromXsd> libraries,
    LibraryFromXsd library,
  ) {
    var newClasses = <ClassFromXsd>[];
    for (var clasz in library.classes ?? []) {
      var constructor = createConstructor(libraries, clasz);
      if (constructor == null) {
        // add as is
        newClasses.add(clasz);
      } else {
        /// add with constructor
        var newClass = clasz.copyWith(constructors: [constructor]);
        newClasses.add(newClass);
      }
    }
    return newClasses;
  }

  List<ClassFromXsd> findSuperClasses(
    ClassFromXsd clasz,
    List<LibraryFromXsd> libraries,
  ) {
    if (clasz.superClass == null) {
      return [];
    }
    var superClass = findClass(
      clasz.superClass! as TypeFromXsdReference,
      libraries,
    );
    return findSuperClassesRecursively([superClass], libraries);
  }

  List<ClassFromXsd> findSuperClassesRecursively(
    List<ClassFromXsd> foundSuperClasses,
    List<LibraryFromXsd> libraries,
  ) {
    var last = foundSuperClasses.last;
    if (last.superClass == null) {
      return foundSuperClasses;
    }
    var superClass = findClass(
      last.superClass! as TypeFromXsdReference,
      libraries,
    );
    foundSuperClasses.add(superClass);
    return findSuperClassesRecursively(foundSuperClasses, libraries);
  }

  ClassFromXsd findClass(
    TypeFromXsdReference classToFind,
    List<LibraryFromXsd> libraries,
  ) {
    var nameSpaceUri = classToFind.namespaceUri;
    var library = findLibrary(libraries, nameSpaceUri);
    var foundClass = (library.classes ?? []).firstWhereOrNull(
      (c) => c.name.toString() == classToFind.name,
    );
    if (foundClass == null) {
      log.warning('Could not find class: ${classToFind.name}');
      return library.classes?.first
          as ClassFromXsd; //FIXME remove this temporary fix
    }
    return foundClass as ClassFromXsd;
  }

  LibraryFromXsd findLibrary(
    List<LibraryFromXsd> libraries,
    String nameSpaceUri,
  ) => libraries.firstWhere((l) => l.schema.targetNameSpaceUri == nameSpaceUri);

  Constructor? createConstructor(
    List<LibraryFromXsd> libraries,
    ClassFromXsd clasz,
  ) {
    var constructParameters = createConstructorParameters(clasz, libraries);
    if (constructParameters.parameters.isEmpty) {
      return null;
    }
    return Constructor(
      Type(clasz.name.toString()),
      parameters: constructParameters,
    );
  }

  ConstructorParameters createConstructorParameters(
    ClassFromXsd clasz,
    List<LibraryFromXsd> libraries,
  ) {
    var localFields = clasz.fields ?? [];
    var superClasses = findSuperClasses(clasz, libraries);
    var superFields = superClasses
        .map((c) => c.fields ?? [])
        .expand((e) => e)
        .toList();
    var constructParameters = ConstructorParameters([
      for (var superField in superFields)
        ConstructorParameter.named(
          superField.name,
          type: superField.type,
          qualifier: Qualifier.super$,
          required: isRequired(superField),
        ),
      for (var localField in localFields)
        ConstructorParameter.named(
          localField.name,
          type: localField.type,
          qualifier: Qualifier.this$,
          required: isRequired(localField),
        ),
    ]);
    return constructParameters;
  }

  bool isRequired(Field field) =>
      (field.type is Type) ? !(field.type as Type).nullable : false;
}
