import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/field.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdChoiceToTypeConverter implements XsdToDarConverter {
  const XsdChoiceToTypeConverter();

  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'choice' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }

    var codeFromChildren = internalConverter
        .convertZeroOrMoreChildrenToDartCode(xsdElement);

    var typesThatImplement = <TypeFromXsdReference>[];
    for (var childCode in codeFromChildren) {
      if (childCode is! FieldFromXsd) {
        log.warning(
          '${lookUpText(xsdElement)}: unexpected child code: $childCode',
        );
        continue;
      }

      var childType = getOrCreateChildType(internalConverter, childCode);

      if (childType is! TypeFromXsdReference) {
        log.warning(
          '${lookUpText(xsdElement)}: unexpected choice type: $childType',
        );
        continue;
      }
      typesThatImplement.add(childType);
    }

    var name =
        '${findTypeName(internalConverter.namePathMapper, xsdElement)}Item';

    var type = TypeFromXsdChoice(name, xsdElement, typesThatImplement);
    return [type];
  }

  BaseType? getOrCreateChildType(
    InternalConverter internalConverter,
    FieldFromXsd field,
  ) {
    var xsdElement = field.xsdElement;
    var fieldTypeExpression = xsdElement.getAttribute('type');
    if (fieldTypeExpression == null) {
      return field.type;
    }
    var fieldTypeConverter = internalConverter.simpleTypeConverters
        .findForXsdType(fieldTypeExpression!.split(':').last);
    if (fieldTypeConverter == null) {
      return field.type;
    }
    var fieldType = fieldTypeConverter!.dartType;

    var className = findTypeName(internalConverter.namePathMapper, xsdElement);
    var fields = [createField(xsdElement, fieldType)];
    var clasz = ClassFromXsd(className, fields: fields, xsdElement: xsdElement);
    return TypeFromXsdReference.toClass(xsdElement, clasz);
  }

  FieldFromXsd createField(XmlElement xsdElement, Type fieldType) {
    var isList = xsdElementIsList(xsdElement);
    var isNullable = xsdElementIsNullable(xsdElement);
    if (isList) {
      return FieldFromXsd(
        'items',
        xsdElement: xsdElement,
        type: Type.ofList(genericType: fieldType, nullable: isNullable),
      );
    } else {
      return FieldFromXsd(
        'item',
        xsdElement: xsdElement,
        type: fieldType.copyWith(nullable: isNullable),
      );
    }
  }
}
