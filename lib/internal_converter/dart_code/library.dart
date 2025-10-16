import 'dart:io';

import 'package:dart_code/dart_code.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

class LibraryFromXsd extends Library {
  final Schema schema;
  final File Function(File file)? fileNameConverter;
  LibraryFromXsd({
    super.name,
    super.docComments,
    super.annotations,
    super.functions,
    super.classes,
    super.enumerations,
    super.typeDefs,
    super.extensions,
    required this.schema,
    this.fileNameConverter,
  });

  @override
  LibraryFromXsd copyWith({
    String? name,
    List<DocComment>? docComments,
    List<Annotation>? annotations,
    List<DartFunction>? functions,
    List<Class>? classes,
    List<Enumeration>? enumerations,
    List<TypeDef>? typeDefs,
    List<Extension>? extensions,
    File? xsdSourceFile,
    Schema? schema,
  }) {
    return LibraryFromXsd(
      docComments: docComments ?? this.docComments,
      annotations: annotations ?? this.annotations,
      functions: functions ?? this.functions,
      classes: classes ?? this.classes,
      enumerations: enumerations ?? this.enumerations,
      typeDefs: typeDefs ?? this.typeDefs,
      extensions: extensions ?? this.extensions,
      schema: schema ?? this.schema,
    );
  }
}
