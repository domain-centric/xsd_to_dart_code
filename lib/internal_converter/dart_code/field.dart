import 'package:xml/xml.dart';
import 'package:dart_code/dart_code.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';

/// A [Field] that represents a XsdElement
class FieldFromXsd extends Field implements HasTypeCode {
  final XmlElement xsdElement;

  FieldFromXsd(
    super.name, {
    super.docComments = const [],
    super.annotations = const [],
    super.static = false,
    super.modifier = Modifier.final$,
    super.type,
    super.value,
    required this.xsdElement,
  });

  late final fieldSource = FieldSource.of(xsdElement);

  @override
  late final List<CodeModel> typeCode = findAllTypes(
    type,
  ).whereType<HasTypeCode>().map((t) => t.typeCode).expand((c) => c).toList();

  late final bool isNullable = (type is Type) && (type as Type).nullable;
}

enum FieldSource {
  element,
  attribute;

  static FieldSource of(XmlElement xsdElement) =>
      xsdElement.name.local == 'attribute' ? attribute : element;
}

FieldFromXsd createFieldFromXsdElement(
  InternalConverter internalConverter,
  XmlElement xsdElement,
) {
  var name = _createFieldName(internalConverter, xsdElement);
  var type = _createFieldType(internalConverter, xsdElement);

  return FieldFromXsd(name, type: type, xsdElement: xsdElement);
}

String _createFieldName(
  InternalConverter internalConverter,
  XmlElement xsdElement,
) {
  var name = toValidDartNameStartingWitLowerCase(
    xsdElement.getAttribute('name'),
  );
  if (xsdElementIsList(xsdElement)) {
    return internalConverter.pluralConverter.convertToPluralNoun(name);
  }
  return name;
}

Type _createFieldType(
  InternalConverter internalConverter,
  XmlElement xsdElement,
) {
  var type =
      _createFieldTypeFromAttribute(internalConverter, xsdElement) ??
      _createFieldTypeFromChild(internalConverter, xsdElement);
  type = wrapInListIfNeeded(xsdElement, type);
  type = setNullable(xsdElement, type);
  return type;
}

Type? _createFieldTypeFromAttribute(
  InternalConverter internalConverter,
  XmlElement xsdElement,
) {
  var typeAttribute = xsdElement.getAttribute("type");
  if (typeAttribute == null) {
    return null;
  }

  var isNullable = xsdElementIsNullable(xsdElement);
  var xsdNameSpacePrefix = xsdElement.name.prefix!;
  if (typeAttribute.startsWith(xsdNameSpacePrefix)) {
    return _createTypeFromExpression(
      internalConverter,
      typeAttribute,
      isNullable,
    );
  }

  // assume it is a reference to another generated class or generated enum
  var type = TypeFromXsdReference.fromTypeAttribute(
    internalConverter.namePathMapper,
    xsdElement,
  );
  return type;
}

Type? _createTypeFromExpression(
  InternalConverter internalConverter,
  String typeAttribute,
  bool isNullable,
) {
  var typeExpression = typeAttribute.split(":").last;
  var converter = internalConverter.simpleTypeConverters.findForXsdType(
    typeExpression,
  );
  if (converter == null) {
    return null;
  }
  return converter.dartType.copyWith(nullable: isNullable);
}

Type _createFieldTypeFromChild(
  InternalConverter internalConverter,
  XmlElement xsdElement,
) {
  var children = xsdElement.childElements;
  if (children.length != 1) {
    log.warning('${lookUpText(xsdElement)}: expected only one child');
  }
  if (children.isEmpty) {
    return Type.ofDynamic();
  }
  var child = xsdElement.childElements.first;
  var code = internalConverter.convertToDartCode(child);
  if (code.isEmpty) {
    return Type.ofDynamic();
  }
  if (code.length > 1) {
    log.warning(
      '${lookUpText(xsdElement)}: expected a single type, '
      'but got: ${code.map((c) => c.runtimeType).join(', ')}',
    );
  }

  var type = code.first;
  if (type is Class) {
    return TypeFromXsdReference.toClass(child, type);
  }
  if (type is Enumeration) {
    return TypeFromXsdReference.toEnumeration(child, type);
  }
  if (type is Type) {
    return type;
  }
  log.warning(
    '${lookUpText(xsdElement)}: converted to an unsupported dart type: ${type.runtimeType}',
  );
  return Type.ofDynamic();
}
