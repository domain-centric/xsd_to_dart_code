import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
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
      var childType = childCode.type;
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
}
