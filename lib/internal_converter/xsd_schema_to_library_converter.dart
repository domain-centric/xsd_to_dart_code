import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/internal_converter/internal_converter.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class XsdSchemaToLibraryConverter implements XsdToDarConverter {
  const XsdSchemaToLibraryConverter();
  @override
  List<CodeModel> convertToDartCode(
    InternalConverter internalConverter,
    XmlElement xsdElement,
  ) {
    if (xsdElement.name.local != 'schema' ||
        xsdElement.namespaceUri != xsdNamespaceUri) {
      return const [];
    }
    var codeFromChildren = internalConverter
        .convertZeroOrMoreChildrenToDartCode(xsdElement);

    var codeNestedInsideChildren = <CodeModel>[];
    for (var codeModel in codeFromChildren) {
      if (codeModel is HasTypeCode) {
        codeNestedInsideChildren.addAll(findAllNestedCode(codeModel));
      }
    }

    var allCode = {...codeNestedInsideChildren, ...codeFromChildren};

    var library = LibraryFromXsd(
      schema: xsdElement as Schema,
      classes: allCode.whereType<Class>().toList(),
      enumerations: allCode.whereType<Enumeration>().toList(),
    );
    return [library];
  }

  List<CodeModel> findAllNestedCode(CodeModel codeModel) {
    if (codeModel is HasTypeCode) {
      var childCode = (codeModel as HasTypeCode).typeCode;
      return [
        codeModel,

        ///recursive call
        ...childCode.map((c) => findAllNestedCode(c)).expand((e) => e),
      ];
    }
    return [codeModel];
  }
}
