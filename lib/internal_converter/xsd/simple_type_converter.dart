import 'package:change_case/change_case.dart';
import 'package:collection/collection.dart';
import 'package:dart_code/dart_code.dart';

// /// maps a simple Xsd type to a simple dart type
// @Deprecated('Use XmlTypeConverter instead')
// abstract class SimpleTypeMapper {
//   Type? convert(String xsdType, {required bool isNullable});
// }

// /// Default implementation of a [SimpleTypeMapper]
// @Deprecated('Use DefaultSimpleTypeConverters instead')
// class DefaultSimpleTypeMapper implements SimpleTypeMapper {
//   const DefaultSimpleTypeMapper();

//   @override
//   Type? convert(String xsdType, {required bool isNullable}) {
//     isNullable = isNullable || xsdType.endsWith("?");
//     var safeType = xsdType.replaceAll("?", "");
//     switch (safeType) {
//       // bool
//       case "boolean":
//         return Type.ofBool(nullable: isNullable);
//       // int
//       case "int":
//       case "byte":
//       case "short":
//       case "long":
//       case "unsignedLong":
//       case "unsignedInt":
//       case "unsignedShort":
//       case "unsignedByte":
//       case "positiveInteger":
//       case "nonNegativeInteger":
//       case "nonPositiveInteger":
//       case "negativeInteger":
//       case "integer":
//         return Type.ofInt(nullable: isNullable);
//       // double
//       case "double":
//       case "decimal":
//       case "float":
//         return Type.ofDouble(nullable: isNullable);
//       // String
//       case "string":
//       case "language":
//       case "anyURI":
//       case "token":
//       case "QName":
//       case "Name":
//       case "NCName":
//       case "ENTITY":
//       case "ID":
//       case "IDREF":
//       case "NMTOKEN":
//       case "NOTATION":
//         return Type.ofString(nullable: isNullable);
//       // date and time
//       case "dateTime":
//         return Type.ofDateTime(nullable: isNullable);
//       // Uint8List
//       case "base64Binary":
//       case "hexBinary":
//         return Type('Uint8List', nullable: isNullable);
//       // List<String>
//       case "ENTITIES":
//       case "IDREFS":
//       case "NMTOKENS":
//         return Type.ofList(genericType: Type.ofString(), nullable: isNullable);
//       // duration
//       case "duration":
//         return Type.ofDuration(nullable: isNullable);
//       default:
//         return null;
//     }
//   }
// }

abstract class XmlTypeConverter {
  List<String> get xsdTypes;

  /// always none nullable!
  Type get dartType;

  /// converts a value from an object field [valueExpression] to the correct Xml expression
  Expression toXmlCode(Expression valueExpression, bool nullable);

  /// converts a the value from xml [valueExpression] to the correct Dart type
  Expression fromXmlCode(Expression valueExpression, bool nullable);
}

abstract class SimpleTypeConverters extends DelegatingList<XmlTypeConverter> {
  SimpleTypeConverters(super.base);

  XmlTypeConverter? findForDartType(Type typeToFind) {
    // TODO List???
    var toFind = typeToFind.copyWith(nullable: false).toString();
    return firstWhereOrNull(
      (converter) => converter.dartType.toString() == toFind,
    );
  }

  XmlTypeConverter? findForXsdType(String xsdTypeExpression) =>
      firstWhereOrNull(
        (converter) => converter.xsdTypes.contains(xsdTypeExpression),
      );
}

class DefaultSimpleTypeConverters extends SimpleTypeConverters {
  DefaultSimpleTypeConverters()
    : super([
        BoolConversion(),
        IntConversion(),
        DoubleConversion(),
        StringConversion(),
        DateTimeConversion(),
        DurationConversion(),
        UriConversion(),
      ]);
}

class BoolConversion implements XmlTypeConverter {
  BoolConversion();
  @override
  final List<String> xsdTypes = const ['boolean'];

  @override
  final Type dartType = Type.ofBool();

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      createToDartCode(nullable, dartType, valueExpression);

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) => nullable
      ? valueExpression.assertNotNull().callMethod('toString')
      : valueExpression.callMethod('toString');
}

class StringConversion implements XmlTypeConverter {
  @override
  final List<String> xsdTypes = ['string'];

  @override
  final Type dartType = Type.ofString();

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      valueExpression; //TODO test

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) =>
      nullable ? valueExpression.assertNotNull() : valueExpression;
}

class IntConversion implements XmlTypeConverter {
  @override
  final List<String> xsdTypes = [
    "int",
    "byte",
    "short",
    "long",
    "unsignedLong",
    "unsignedInt",
    "unsignedShort",
    "unsignedByte",
    "positiveInteger",
    "nonNegativeInteger",
    "nonPositiveInteger",
    "negativeInteger",
    "integer",
  ];

  @override
  final Type dartType = Type.ofInt();

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      createToDartCode(nullable, dartType, valueExpression);

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) => nullable
      ? valueExpression.assertNotNull().callMethod('toString')
      : valueExpression.callMethod('toString');
}

class DoubleConversion implements XmlTypeConverter {
  @override
  final List<String> xsdTypes = ['double', 'decimal', 'float'];

  @override
  final Type dartType = Type.ofDouble();

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      createToDartCode(nullable, dartType, valueExpression);

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) => nullable
      ? valueExpression.assertNotNull().callMethod('toString')
      : valueExpression.callMethod('toString');
}

class DateTimeConversion implements XmlTypeConverter {
  @override
  final List<String> xsdTypes = ['dateTime', 'date'];

  @override
  final Type dartType = Type.ofDateTime();

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      createToDartCode(nullable, dartType, valueExpression);

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) => nullable
      ? valueExpression.assertNotNull().callMethod('toIso8601String')
      : valueExpression.callMethod('toIso8601String');
}

class DurationConversion implements XmlTypeConverter {
  @override
  final List<String> xsdTypes = ['duration'];

  @override
  final Type dartType = Type.ofDuration();

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      createToDartCode(nullable, dartType, valueExpression);

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) => nullable
      ? valueExpression.assertNotNull().callMethod('toString')
      : valueExpression.callMethod('toString');
}

class UriConversion implements XmlTypeConverter {
  @override
  final List<String> xsdTypes = ['anyURI'];

  @override
  final Type dartType = Type.ofUri();

  @override
  Expression fromXmlCode(Expression valueExpression, bool nullable) =>
      createToDartCode(nullable, dartType, valueExpression);

  @override
  Expression toXmlCode(Expression valueExpression, bool nullable) => nullable
      ? valueExpression.assertNotNull().callMethod('toString')
      : valueExpression.callMethod('toString');
}

Expression createToDartCode(
  bool nullable,
  Type dartType,
  Expression valueExpression,
) => nullable
    ? Expression.callMethodOrFunction(
        'toNullableDartType',
        genericType: dartType,
        parameterValues: ParameterValues([
          ParameterValue(valueExpression),
          ParameterValue(
            Expression.callMethodOrFunction(
              'toDart${dartType.name.toPascalCase}',
              parameterValues: ParameterValues([
                ParameterValue(valueExpression),
              ]),
            ),
          ),
        ]),
      )
    : Expression.callMethodOrFunction(
        'toDart${dartType.name.toPascalCase()}',
        parameterValues: ParameterValues([ParameterValue(valueExpression)]),
      );

/// returns null if [xmlValue] is null,
/// otherwise it uses [toDartTypeConverter] to return the converted value
T? toNullableDartType<T>(
  String? xmlValue,
  T Function(String xmlValue) toDartTypeConverter,
) => xmlValue == null ? null : toDartTypeConverter(xmlValue);

bool toDartBool(String xmlValue) =>
    xmlValue.toLowerCase() == 'true' || xmlValue == '1';
