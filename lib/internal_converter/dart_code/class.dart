import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/field.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';

/// This class is a placeholder for a class that needs to be post-processed
/// to add the correct superclass and constructor.
class ClassFromXsd extends Class implements HasTypeCode {
  final XmlElement xsdElement;
  ClassFromXsd(
    super.name, {
    super.docComments,
    super.annotations,
    super.modifier,
    super.superClass,
    super.implements,
    super.mixins,
    super.fields,
    super.constructors,
    super.methods,
    required this.xsdElement,
  });

  ClassFromXsd copyWith({
    String? name,
    List<DocComment>? docComments,
    List<Annotation>? annotations,
    ClassModifier? modifier,
    Type? superClass,
    List<Type>? implements,
    List<Type>? mixins,
    List<Field>? fields,
    List<Constructor>? constructors,
    List<Method>? methods,
    XmlElement? xsdElement,
  }) {
    return ClassFromXsd(
      name ?? this.name.toString(),
      docComments: docComments ?? this.docComments,
      annotations: annotations ?? this.annotations,
      modifier: modifier ?? this.modifier,
      superClass: superClass ?? this.superClass,
      implements: implements ?? this.implements,
      mixins: mixins ?? this.mixins,
      fields: fields ?? this.fields,
      constructors: constructors ?? this.constructors,
      methods: methods ?? this.methods,
      xsdElement: xsdElement ?? this.xsdElement,
    );
  }

  @override
  List<CodeModel> get typeCode => (fields ?? [])
      .whereType<HasTypeCode>()
      .map((t) => t.typeCode)
      .expand((c) => c)
      .toList();

  // findAllTypesInClass()
  //     .whereType<HasTypeCode>()
  //     .map((t) => t.typeCode)
  //     .expand((c) => c)
  //     .toList();

  // List<BaseType?> findAllTypesInClass() => [
  //   if (superClass != null) superClass,
  //   ...findAllFieldTypes(),
  // ];

  // Iterable<BaseType> findAllFieldTypes() =>
  //     (fields ?? []).map((f) => findAllTypes(f.type)).expand((t) => t);
}

class InterfaceFromXsdChoice extends ClassFromXsd {
  final TypeFromXsdChoice typeFromXsdChoice;

  InterfaceFromXsdChoice._(
    super.name, {
    super.docComments,
    required super.xsdElement,
    required this.typeFromXsdChoice,
  }) : super(modifier: ClassModifier.abstract_interface);

  factory InterfaceFromXsdChoice(TypeFromXsdChoice xsdChoiceType) {
    var owners = xsdChoiceType.typesThatImplementThisType.map(
      (c) => '[${c.name}]',
    );
    var docComments = [
      DocComment.fromString('Common interface for: ${owners.join(', ')}'),
    ];
    return InterfaceFromXsdChoice._(
      xsdChoiceType.name,
      xsdElement: xsdChoiceType.xsdElement,
      typeFromXsdChoice: xsdChoiceType,
      docComments: docComments,
    );
  }

  @override
  late final List<CodeModel> typeCode = [
    ...typeFromXsdChoice.typesThatImplementThisType,
  ];
}

/// [xsdElement] could be one of the following:
/// * xsd:complexType
/// * xsd:complexContent
/// * xsd:extension?
ClassFromXsd createClassFromXsdElement(
  InternalConverter internalConverter,
  XmlElement xsdElement, {
  ClassModifier? modifier,
  Type? superClass,
}) {
  /// was it created by its child? In other words:
  /// is it a single child of e.g. xsd:complexContent or xsd:extension?
  var singleClass = findSingleClass(internalConverter, xsdElement);
  if (singleClass != null) {
    return singleClass.copyWith(modifier: modifier, superClass: superClass);
  }

  /// create a class using the fields created by its children (if any)
  var fields = _findFields(internalConverter, xsdElement);
  var name = findTypeName(internalConverter.namePathMapper, xsdElement);
  var clasz = ClassFromXsd(
    name,
    xsdElement: xsdElement,
    fields: fields,
    modifier: modifier,
    superClass: superClass,
  );
  return clasz;
}

ClassFromXsd? findSingleClass(
  InternalConverter internalConverter,
  XmlElement xsdElement,
) {
  var codeFromChildren = internalConverter.convertZeroOrMoreChildrenToDartCode(
    xsdElement,
  );
  if (codeFromChildren.length != 1) {
    return null;
  }
  var singleCodeModel = codeFromChildren.first;
  if (singleCodeModel is! ClassFromXsd) {
    return null;
  }
  return singleCodeModel;
}

List<Field> _findFields(
  InternalConverter internalConverter,
  XmlElement xsdElement,
) {
  var codeFromChildren = internalConverter.convertZeroOrMoreChildrenToDartCode(
    xsdElement,
  );
  var typeFromXsdChoice = findTypeFromXsdChoice(codeFromChildren);
  if (typeFromXsdChoice == null) {
    /// children are fields
    return codeFromChildren.whereType<Field>().toList();
  }

  /// child is a xsd:choice
  var xsdChoiceElement = typeFromXsdChoice.xsdElement;
  var isList = xsdElementIsList(xsdChoiceElement);
  var isNullable = xsdElementIsNullable(xsdChoiceElement);
  if (isList) {
    return [
      FieldFromXsd(
        'items',
        xsdElement: xsdChoiceElement,
        type: Type.ofList(genericType: typeFromXsdChoice, nullable: isNullable),
      ),
    ];
  } else {
    return [
      FieldFromXsd(
        'item',
        xsdElement: xsdChoiceElement,
        type: typeFromXsdChoice.copyWith(nullable: isNullable),
      ),
    ];
  }
}

TypeFromXsdChoice? findTypeFromXsdChoice(Iterable<CodeModel> codeFromChildren) {
  var allChoices = codeFromChildren.whereType<TypeFromXsdChoice>();
  if (allChoices.length != 1) {
    return null;
  }
  return allChoices.first;
}
