import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/internal_converter/dart_code/library.dart';

class WriteResultToFile implements XsdToDartGeneratorStep {
  final OutputPathConverter outputPathConverter;

  WriteResultToFile(this.outputPathConverter);

  @override
  List<LibraryFromXsd> process(List<LibraryFromXsd> libraries) {
    for (var library in libraries) {
      File file = dartFile(outputPathConverter, library);
      file.createSync(recursive: true);
      file.writeAsStringSync(library.toFormattedString());
    }
    return libraries;
  }
}

File dartFile(OutputPathConverter outputPathConverter, LibraryFromXsd library) {
  var dartFile = outputPathConverter.convertToDartFile(library.schema.xsdFile);
  if (library.fileNameConverter != null) {
    dartFile = library.fileNameConverter!(dartFile);
  }
  return dartFile;
}

abstract class OutputPathConverter {
  /// creates the output path (not the file contents)
  File convertToDartFile(File xsdFile);
}

class DefaultOutputPathConverter implements OutputPathConverter {
  /// maps a xsd file name (without path or file extension) to a dart file name (without path or file extension)
  final Map<String, String> fileNameMappings;
  final Directory dartDirectory;

  DefaultOutputPathConverter({
    Directory? dartDirectory,
    this.fileNameMappings = const {},
  }) : dartDirectory =
           dartDirectory ?? Directory('lib${Platform.pathSeparator}generated');

  @override
  File convertToDartFile(File xsdFile) => File(
    '${dartDirectory.path}'
    '${Platform.pathSeparator}'
    '${createDartFileName(xsdFile)}.dart',
  );

  String createDartFileName(File xsdFile) {
    var xsdFileName = p.basenameWithoutExtension(xsdFile.path);
    if (fileNameMappings.keys.contains(xsdFileName)) {
      return fileNameMappings[xsdFileName]!;
    }
    return normalizeFileName(xsdFileName);
  }

  String normalizeFileName(String xsdFileName) =>
      xsdFileName.replaceAll('.', '').toLowerCase();
}
