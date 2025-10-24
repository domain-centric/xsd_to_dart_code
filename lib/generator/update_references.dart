import 'package:dart_code/dart_code.dart';
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/generator/write_result_to_file.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/field.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';

/// Updates references in field types and super classes (extends)
/// Because these could reference a library member in another library.
/// See [TypeFromXsdReference.resolve]
class UpdateReferences implements XsdToDartGeneratorStep {
  final NamePathMapper namePathMapper;
  final OutputPathConverter outputPathConverter;

  UpdateReferences(this.namePathMapper, this.outputPathConverter);

  @override
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
    var newLibraries = <LibraryFromXsd>[];
    for (var library in libraries) {
      var updatedClasses = updateClassReferencesOfLibrary(library, libraries);
      newLibraries.add(library.copyWith(classes: updatedClasses));
    }
    return newLibraries;
  }

  List<ClassFromXsd> updateClassReferencesOfLibrary(
    LibraryFromXsd library,
    List<LibraryFromXsd> libraries,
  ) {
    var classes = (library.classes ?? <ClassFromXsd>[]).cast<ClassFromXsd>();
    var updatedClasses = classes
        .map((c) => updateClassReferences(c, libraries))
        .toList();
    return updatedClasses;
  }

  ClassFromXsd updateClassReferences(
    ClassFromXsd clasz,
    List<LibraryFromXsd> libraries,
  ) {
    List<FieldFromXsd> updatedFields = updateFieldReferences(clasz, libraries);
    var updatedSuperClass = updateSuperClass(clasz, libraries);
    return clasz.copyWith(fields: updatedFields, superClass: updatedSuperClass);
  }

  List<FieldFromXsd> updateFieldReferences(
    ClassFromXsd clasz,
    List<LibraryFromXsd> libraries,
  ) {
    var fields = (clasz.fields ?? <FieldFromXsd>[]).cast<FieldFromXsd>();
    var updatedFields = fields.map((field) {
      var updatedFieldType = updateType(field.type!, libraries);
      var updatedField = field.copyWith(type: updatedFieldType);
      return updatedField;
    }).toList();
    return updatedFields;
  }

  Type updateType(BaseType type, List<LibraryFromXsd> libraries) {
    if (type is Type && type.name == 'List' && type.generics.isNotEmpty) {
      var updatedGenericType = updateType(type.generics.first, libraries);
      return type.copyWith(generics: [updatedGenericType]);
    }
    if (type is TypeFromXsdReference) {
      return type.resolve(namePathMapper, outputPathConverter, libraries);
    }
    return type as Type;
  }

  Type? updateSuperClass(ClassFromXsd clasz, List<LibraryFromXsd> libraries) {
    var superClass = clasz.superClass;
    if (superClass == null) {
      return null;
    }
    return updateType(superClass, libraries);
  }
}
