import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

abstract class HasTypeCode {
  /// Code model of the type if available
  List<CodeModel> get typeCode;
}

/// A reference to another (to be) generated class or generated enum
/// [libraryUri] to be defined during post processing
class TypeFromXsdReference extends Type implements HasTypeCode {
  final XmlElement xsdElement;
  final String namespaceUri;
  @override
  final List<CodeModel> typeCode;

  TypeFromXsdReference(
    super.name, {
    super.libraryUri,
    super.generics = const [],
    super.nullable = false,
    this.typeCode = const [],
    required this.xsdElement,
    required this.namespaceUri,
  });

  factory TypeFromXsdReference.fromTypeAttribute(
    NamePathMapper namePathMapper,
    XmlElement xsdElement,
  ) {
    var typeAttribute = (xsdElement.getAttribute('type') ?? '');
    var namespacePrefix = typeAttribute.split(":").first;
    var schema = Schema.of(xsdElement);
    var namespaceUri = schema.findNameSpaceUri(namespacePrefix) ?? '';
    var typeName = _findTypeName(
      //FIXME do this at post processing when all classes are available?
      namePathMapper,
      schema,
      xsdElement,
      typeAttribute,
    );

    return TypeFromXsdReference(
      typeName,
      xsdElement: xsdElement,
      namespaceUri: namespaceUri,
    );
  }

  factory TypeFromXsdReference.toClass(XmlElement xsdElement, Class clasz) {
    var schema = Schema.of(xsdElement);
    var namespaceUri = schema.targetNameSpaceUri!;
    return TypeFromXsdReference(
      clasz.name.toString(),
      xsdElement: xsdElement,
      namespaceUri: namespaceUri,
      typeCode: [clasz],
    );
  }

  factory TypeFromXsdReference.toEnumeration(
    XmlElement xsdElement,
    Enumeration enumeration,
  ) {
    var schema = Schema.of(xsdElement);
    var namespaceUri = schema.targetNameSpaceUri!;
    return TypeFromXsdReference(
      enumeration.name.toString(),
      xsdElement: xsdElement,
      namespaceUri: namespaceUri,
      typeCode: [enumeration],
    );
  }

  factory TypeFromXsdReference.toLibraryMember(
    XmlElement xsdElement,
    String libraryMemberName,
  ) {
    var schema = Schema.of(xsdElement);
    var namespaceUri = schema.targetNameSpaceUri!;
    return TypeFromXsdReference(
      libraryMemberName,
      xsdElement: xsdElement,
      namespaceUri: namespaceUri,
    );
  }

  static String _findTypeName(
    NamePathMapper namePathMapper,
    Schema schema,
    XmlElement xsdElement,
    String typeAttribute,
  ) {
    var nameToFind = typeAttribute.split(":").last;
    var elements = schema
        .findAllElements('*', namespace: xsdNamespaceUri)
        .where(
          (e) =>
              e.getAttribute('name') == nameToFind &&
              e.getAttribute('type') == null,
        );
    if (elements.length != 1) {
      log.warning(
        '${lookUpText(xsdElement)}: could not determine name: $nameToFind',
      );
      return 'Object';
    } else {
      return findTypeName(namePathMapper, elements.first);
    }
  }

  @override
  Type copyWith({String? name, bool? nullable, List<Type>? generics}) {
    return TypeFromXsdReference(
      name ?? this.name,
      libraryUri: libraryUri,
      generics: generics?? const [],
      nullable: nullable ?? this.nullable,
      typeCode: typeCode,
      xsdElement: xsdElement,
      namespaceUri: namespaceUri,
    );
  }
}

class TypeFromXsdChoice extends Type implements HasTypeCode {
  final XmlElement xsdElement;
  final List<TypeFromXsdReference> typesThatImplementThisType;

  TypeFromXsdChoice(
    super.name,
    this.xsdElement,
    this.typesThatImplementThisType, {
    super.nullable,
  });

  @override
  Type copyWith({String? name, bool? nullable, List<Type>? generics}) {
    return TypeFromXsdChoice(
      name ?? this.name,
      xsdElement,
      typesThatImplementThisType,
      nullable: nullable ?? this.nullable,
    );
  }

  @override
  late final List<CodeModel> typeCode = [InterfaceFromXsdChoice(this)];
}

bool xsdElementIsList(XmlElement element) =>
    element.getAttribute("maxOccurs") == "unbounded" ||
    (element.getAttribute("maxOccurs") != null &&
        int.tryParse(element.getAttribute("maxOccurs")!) != null &&
        int.parse(element.getAttribute("maxOccurs")!) > 1);

bool xsdElementIsNullable(XmlElement element) {
  return element.getAttribute("nillable") == "true" ||
      element.getAttribute("minOccurs") == "0" ||
      element.getAttribute("use") == "optional";
}

Type wrapInListIfNeeded(XmlElement xsdElement, Type type) {
  if (xsdElementIsList(xsdElement)) {
    return Type.ofList(genericType: type);
  }
  return type;
}

Type setNullable(XmlElement xsdElement, Type type) {
  var isNullable = xsdElementIsNullable(xsdElement);
  return type.copyWith(nullable: isNullable);
}

List<BaseType> findAllTypes(BaseType? type) {
  if (type == null) {
    return [];
  }
  var types = <BaseType>[type];

  if (type is Type) {
    for (var internal in type.generics) {
      types.addAll(findAllTypes(internal));
    }
  }
  return types;
}
