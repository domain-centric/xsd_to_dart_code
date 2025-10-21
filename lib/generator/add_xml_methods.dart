import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/generator/write_result_to_file.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/class.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/enumerator.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/field.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/type.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/simple_type_converter.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';

class AddXmlMethods implements XsdToDartGeneratorStep {
  final OutputPathConverter outputPathConverter;
  final SimpleTypeConverters simpleTypeConverters;

  AddXmlMethods(this.outputPathConverter, this.simpleTypeConverters);

  @override
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
    var newLibraries = <LibraryFromXsd>[];
    for (var library in libraries) {
      var newLibrary = createLibraryWithToXmlMethods(libraries, library);
      newLibraries.add(newLibrary);
    }
    return newLibraries;
  }

  static final xmlPackageUri = 'package:xml/xml.dart';

  static final xmlText = Type('XmlText', libraryUri: xmlPackageUri);

  static final xmlNode = Type('XmlNode', libraryUri: xmlPackageUri);

  static final xmlElementType = Type('XmlElement', libraryUri: xmlPackageUri);

  static final xmlAttributeType = Type(
    'XmlAttribute',
    libraryUri: xmlPackageUri,
  );
  static final xmlNameType = Type('XmlName', libraryUri: xmlPackageUri);

  // e.g:XmlElement toXml() => XmlElement(XmlName('Project'));
  Method createToXmlMethod(List<LibraryFromXsd> libraries, ClassFromXsd clasz) {
    var superClasses = findSuperClasses(clasz, libraries);
    var allFieldOwners = [...superClasses, clasz];
    var allFields = allFieldOwners
        .map((c) => c.fields ?? <FieldFromXsd>[])
        .expand((e) => e)
        .toList()
        .cast<FieldFromXsd>();

    return Method(
      'toXml',
      Expression.callConstructor(
        xmlElementType,
        parameterValues: ParameterValues([
          createToXmlNameParameterValue(clasz.xsdElement),
          createToXmlAttributesParameterValue(libraries, allFields),
          createToXmlElementsParameterValue(allFields),
        ]),
      ),
      annotations: [
        if (clasz.superClass != null || clasz.implements != null)
          Annotation.override(),
      ],
      returnType: xmlNode,
    );
  }

  ParameterValue createToXmlNameParameterValue(XmlElement xsdElement) {
    return ParameterValue(
      Expression.callConstructor(
        xmlNameType,
        parameterValues: ParameterValues([
          ParameterValue(Expression.ofString(findXsdName(xsdElement)!)),
          //TODO add elements from fields
        ]),
      ),
    );
  }

  File fileNameConverter(File file) => File(
    file.path.replaceAll(
      RegExp(r'.dart$', caseSensitive: false),
      '_xml_convertion.dart',
    ),
  );

  ParameterValue createToXmlAttributesParameterValue(
    List<LibraryFromXsd> libraries,
    List<FieldFromXsd> fields,
  ) => ParameterValue(
    Expression.ofList(
      fields
          .where((f) => f.fieldSource == FieldSource.attribute)
          .map((f) => createXmlAttributeCode(libraries, f))
          .toList(),
    ),
  );

  Expression createXmlAttributeCode(
    List<LibraryFromXsd> libraries,
    FieldFromXsd attributeField,
  ) => Expression([
    if (attributeField.isNullable)
      Expression([Code('if (${attributeField.name}!=null) ')]),
    Expression.callConstructor(
      xmlAttributeType,
      parameterValues: ParameterValues([
        ParameterValue(createXmlAttributeNameCode(attributeField)),
        ParameterValue(createXmlAttributeValueCode(libraries, attributeField)),
      ]),
    ),
  ]);

  Expression createXmlAttributeNameCode(FieldFromXsd attributeField) {
    return Expression.callConstructor(
      xmlNameType,
      parameterValues: ParameterValues([
        ParameterValue(
          Expression.ofString(findXsdName(attributeField.xsdElement)!),
        ),
      ]),
    );
  }

  Expression createXmlAttributeValueCode(
    List<LibraryFromXsd> libraries,
    FieldFromXsd attributeField,
  ) {
    var simpleTypeConverter = simpleTypeConverters.findForDartType(
      attributeField.type as Type,
    );
    if (simpleTypeConverter != null) {
      var valueExpression = Expression.ofVariable(attributeField.name);
      return simpleTypeConverter.toXmlCode(
        valueExpression,
        attributeField.isNullable,
      );
    }

    var enumerator = findEnumeration(libraries, attributeField.type as Type);
    if (enumerator != null) {
      return createToXmlEnumerationExpression(
        enumerator,
        Expression.ofVariable(attributeField.name).assertNotNull(),
        wrapInXmlText: false,
      );
    }

    log.warning(
      '${lookUpText(attributeField.xsdElement)} Could not translate the attribute type.',
    );

    return Expression.ofString('UNKNOWN_TYPE');
  }

  ParameterValue createToXmlElementsParameterValue(List<FieldFromXsd> fields) =>
      ParameterValue(
        Expression.ofList(
          fields
              .where((f) => f.fieldSource == FieldSource.element)
              .map((f) => createXmlElementCode(f))
              .toList(),
        ),
      );

  Expression createXmlElementCode(FieldFromXsd field) {
    var code = <CodeNode>[];
    if (field.isNullable) {
      code.add(Code('if (${field.name}!=null) '));
    }

    if (xsdElementIsList(field.xsdElement)) {
      var typeConverter = createTypeConverter(
        (field.type as Type).generics.first,
      );
      code.add(
        Expression([
          Code('...'),
          fieldNameCode(field).callMethod(
            'map',
            parameterValues: ParameterValues([
              ParameterValue(
                Expression([
                  Code(
                    '(e)=>${typeConverter.toXmlCode(Expression.ofVariable('e').assertNotNull(), false)}',
                  ),
                ]),
              ),
            ]),
          ),
        ]),
      );
    } else {
      var typeConverter = createTypeConverter(field.type as Type);
      code.add(
        typeConverter.toXmlCode(
          Expression.ofVariable(field.name),
          //fieldNameCode(field),
          field.isNullable,
        ),
      );
    }
    return Expression(code);
  }

  XmlTypeConverter createTypeConverter(Type type) {
    var simpleTypeConverter = simpleTypeConverters.findForDartType(type);
    if (simpleTypeConverter == null) {
      return XmlConverterUsingMethods();
    }
    return XmlTextConverter(simpleTypeConverter);
  }

  Expression fieldNameCode(FieldFromXsd field) => field.isNullable
      ? Expression.ofVariable(field.name).assertNotNull()
      : Expression.ofVariable(field.name);

  LibraryFromXsd createLibraryWithToXmlMethods(
    List<LibraryFromXsd> libraries,
    LibraryFromXsd library,
  ) {
    var classes = (library.classes ?? []).cast<ClassFromXsd>();
    var newClasses = classes
        .map((c) => createClassWithToXmlMethod(libraries, c))
        .toList();
    var enums = (library.enumerations ?? []).cast<EnumerationFromXsd>();
    var newEnums = enums.map((e) => createEnumWithToXmlMethod(e)).toList();
    return library.copyWith(classes: newClasses, enumerations: newEnums);
  }

  ClassFromXsd createClassWithToXmlMethod(
    List<LibraryFromXsd> libraries,
    ClassFromXsd clasz,
  ) {
    var newMethods = clasz.methods ?? <Method>[];
    if (clasz.modifier.toString().contains('abstract')) {
      if (clasz.superClass == null) {
        newMethods.add(createAbstractToXmlMethod());
      }
    } else {
      newMethods.add(createToXmlMethod(libraries, clasz));
    }
    var newClass = clasz.copyWith(methods: newMethods);
    return newClass;
  }

  EnumerationFromXsd createEnumWithToXmlMethod(EnumerationFromXsd enumeration) {
    var newMethods = enumeration.methods ?? <Method>[];
    newMethods.add(createToXmlEnumerationMethod(enumeration));
    var newEnumeration = enumeration.copyWith(methods: newMethods);
    return newEnumeration;
  }

  Method createToXmlEnumerationMethod(EnumerationFromXsd enumerator) => Method(
    'toXml',
    createToXmlEnumerationExpression(
      enumerator,
      Expression.ofThis(),
      wrapInXmlText: true,
    ),
    returnType: xmlNode,
  );

  Expression createToXmlEnumerationExpression(
    EnumerationFromXsd enumerator,
    Expression valueExpression, {
    required bool wrapInXmlText,
  }) {
    return Expression([
      Code('switch ('),
      valueExpression,
      Code(') {'),
      for (var value in enumerator.values.cast<EnumerationValueFromXsd>())
        createToXmlEnumValueConversion(
          enumerator,
          value,
          wrapInXmlText: wrapInXmlText,
        ),
      Code('}'),
    ]);
  }

  Expression createToXmlEnumValueConversion(
    EnumerationFromXsd enumerator,
    EnumerationValueFromXsd value, {
    required bool wrapInXmlText,
  }) => Expression([
    Code('${enumerator.name.toString()}.${value.dartValue} =>'),
    if (wrapInXmlText)
      Expression.callConstructor(
        xmlText,
        parameterValues: ParameterValues([
          ParameterValue(Expression([Code("'${value.xmlValue}'")])),
        ]),
      ),
    if (!wrapInXmlText) Expression([Code("'${value.xmlValue}'")]),
    Code(', '),
  ]);

  Method createAbstractToXmlMethod() =>
      Method.abstract('toXml', returnType: xmlNode);

  EnumerationFromXsd? findEnumeration(
    List<LibraryFromXsd> libraries,
    Type typeToFind,
  ) {
    //TODO handle namespaces?
    for (var library in libraries) {
      var enums = (library.enumerations ?? []).cast<EnumerationFromXsd>();
      var enumeration = enums.firstWhereOrNull(
        (e) => e.name.toString() == typeToFind.name,
      );
      if (enumeration != null) {
        return enumeration;
      }
    }
    return null;
  }
}

class XmlTextConverter implements XmlTypeConverter {
  final XmlTypeConverter simpleTypeConverter;

  XmlTextConverter(this.simpleTypeConverter);

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      simpleTypeConverter.fromXmlCode(
        valueExpression.callMethod('text'),
        nullable,
      );

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) =>
      Expression.callConstructor(
        AddXmlMethods.xmlText,
        parameterValues: ParameterValues([
          ParameterValue(
            simpleTypeConverter.toXmlCode(valueExpression, nullable),
          ),
        ]),
      );

  @override
  final Type dartType = Type.ofDynamic(); //Not used

  @override
  List<String> get xsdTypes => []; //Not used
}

class XmlConverterUsingMethods implements XmlTypeConverter {
  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      valueExpression.callMethod('fromXml');

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) => nullable
      ? valueExpression.assertNotNull().callMethod('toXml')
      : valueExpression.callMethod('toXml');
  @override
  final Type dartType = Type.ofDynamic(); //Not used

  @override
  List<String> get xsdTypes => []; //Not used
}
