import 'dart:io';
import 'package:plural_noun/plural_noun.dart';
import 'package:xsd_to_dart_code/internal_converter/plural.dart';
import 'package:xsd_to_dart_code/logger/logger.dart';
import 'package:xsd_to_dart_code/generator/generator.dart';
import 'package:xsd_to_dart_code/generator/write_result_to_file.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/name.dart';
import 'package:xsd_to_dart_code/internal_converter/xsd/schema.dart';

void main(List<String> arguments) {
  initLog();
  var xsdDirectory = Directory('xsd');
  List<File> xsdFiles = xsdDirectory
      .listSync(recursive: false)
      .whereType<File>()
      .where((file) => file.path.endsWith('.xsd'))
      .toList();
  List<Schema> xmlSchemas = xsdFiles
      .map((xsdFile) => Schema.fromFile(xsdFile))
      .toList();

  // var xsdFile = File(r'xsd\IEC61131_10_Ed1_0_Spc1_0.xsd');
  // var schema = Schema.fromFile(xsdFile);
  var generator = XsdToDartGenerator(
    outputPathConverter: CustomizedOutputPathConverter(),
    namePathMapper: CustomizedNamePathMapper(),
    pluralConverter: XsdPluralConverter(CustomizedRuleSet()),
  );
  generator.process(xmlSchemas);
  exit(0);
}

class CustomizedOutputPathConverter extends DefaultOutputPathConverter {
  CustomizedOutputPathConverter()
    : super(
        fileNameMappings: {
          'IEC61131_10_Ed1_0_Spc1_0': 'spc',
          'IEC61131_10_Ed1_0_SmcExt1_0_Spc1_0': 'sysmac_extension',
        },
      );
}

class CustomizedRuleSet extends PluralRuleSet {
  CustomizedRuleSet()
    : super([
        PluralRule.ifMatches('vars').noChange(),
        PluralRule.ifMatches('var').replaceWith('vars'),
        PluralRule.ifMatches('connection').replaceWith('connections'),
        ...EnglishPluralRuleSet().rules,
      ]);
}

class CustomizedNamePathMapper extends DefaultNamePathMapper {
  CustomizedNamePathMapper()
    : super({
        'EnumTypeSpec.Enumerator': 'EnumeratorWithoutValue',
        'ParameterSet.InoutVars.Variable': 'ParameterInoutVariable',
        'ParameterSet.OutputVars.Variable': 'ParameterOutputVariable',
        'ParameterSet.InputVars.Variable': 'ParameterInputVariable',
        'Value.ArrayValue.Value': 'ArrayValueItem',
        'Value.StructValue.Value': 'StructValueItem',
      });
}
