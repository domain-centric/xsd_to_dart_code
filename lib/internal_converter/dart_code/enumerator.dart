import 'package:dart_code/dart_code.dart';
import 'package:xml/xml.dart';

class EnumerationFromXsd extends Enumeration {
  final XmlElement xsdElement;

  EnumerationFromXsd(
    super.name,
    super.values,
    this.xsdElement, {
    super.docComments,
    super.annotations,
    super.implements,
    super.constructor,
    super.methods,
  });

  EnumerationFromXsd copyWith({
    String? name,
    Set<EnumValue>? values,
    XmlElement? xsdElement,
    List<DocComment>? docComments,
    List<Annotation>? annotations,
    List<Type>? implements,
    Constructor? constructor,
    List<Method>? methods,
  }) {
    return EnumerationFromXsd(
      name ?? this.name.toString(),
      values ?? this.values,
      xsdElement ?? this.xsdElement,
      docComments: docComments ?? this.docComments,
      annotations: annotations ?? this.annotations,
      implements: implements ?? this.implements,
      constructor: constructor ?? this.constructor,
      methods: methods ?? this.methods,
    );
  }
}

/// convenience class for XML conversion
class EnumerationValueFromXsd extends EnumValue {
  final String dartValue;
  final String xmlValue;
  EnumerationValueFromXsd({required this.dartValue, required this.xmlValue})
    : super(dartValue);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumerationValueFromXsd &&
          runtimeType == other.runtimeType &&
          dartValue == other.dartValue &&
          xmlValue == other.xmlValue;

  @override
  int get hashCode => dartValue.hashCode ^ xmlValue.hashCode;
}
