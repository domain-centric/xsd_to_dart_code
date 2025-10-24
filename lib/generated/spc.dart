import 'package:xml/xml.dart' as i1;
import 'spc.dart' as i2;

class Project {
  final FileHeader fileHeader;
  final ContentHeader contentHeader;
  final Types types;
  final Instances instances;
  final double schemaVersion;
  Project({
    required this.fileHeader,
    required this.contentHeader,
    required this.types,
    required this.instances,
    required this.schemaVersion,
  });
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Project'),
    [i1.XmlAttribute(i1.XmlName('schemaVersion'), schemaVersion.toString())],
    [
      fileHeader.toXml(),
      contentHeader.toXml(),
      types.toXml(),
      instances.toXml(),
    ],
  );
}

class FileHeader {
  final String companyName;
  final String productName;
  final String productVersion;
  FileHeader({
    required this.companyName,
    required this.productName,
    required this.productVersion,
  });
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('FileHeader'), [
    i1.XmlAttribute(i1.XmlName('companyName'), companyName),
    i1.XmlAttribute(i1.XmlName('productName'), productName),
    i1.XmlAttribute(i1.XmlName('productVersion'), productVersion),
  ], []);
}

class ContentHeader {
  final AddDataInfo? addDataInfo;
  final i2.AddData addData;
  final String name;
  final DateTime creationDateTime;
  ContentHeader({
    this.addDataInfo,
    required this.addData,
    required this.name,
    required this.creationDateTime,
  });
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('ContentHeader'),
    [
      i1.XmlAttribute(i1.XmlName('name'), name),
      i1.XmlAttribute(
        i1.XmlName('creationDateTime'),
        creationDateTime.toIso8601String(),
      ),
    ],
    [if (addDataInfo != null) addDataInfo!.toXml(), addData.toXml()],
  );
}

class AddDataInfo {
  final List<Info>? info;
  AddDataInfo({this.info});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('AddDataInfo'), [], [
    if (info != null) ...info!.map((e) => e.toXml()),
  ]);
}

class Info {
  final Uri name;
  final double version;
  final Uri vendor;
  Info({required this.name, required this.version, required this.vendor});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('Info'), [
    i1.XmlAttribute(i1.XmlName('name'), name.toString()),
    i1.XmlAttribute(i1.XmlName('version'), version.toString()),
    i1.XmlAttribute(i1.XmlName('vendor'), vendor.toString()),
  ], []);
}

class Types {
  final GlobalNamespace globalNamespace;
  Types({required this.globalNamespace});
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('Types'), [], [globalNamespace.toXml()]);
}

class GlobalNamespace extends i2.TextualObjectBase {
  final List<GlobalNamespaceItem>? items;
  GlobalNamespace({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.items,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('GlobalNamespace'), [], [
    if (usingDirectives != null) ...usingDirectives!.map((e) => i1.XmlText(e!)),
    documentation.toXml(),
    addData.toXml(),
    if (items != null) ...items!.map((e) => e.toXml()),
  ]);
}

/// Common interface for: [ToBeResolvedLater], [ToBeResolvedLater], [ToBeResolvedLater], [ToBeResolvedLater], [ToBeResolvedLater]
abstract interface class GlobalNamespaceItem {
  i1.XmlNode toXml();
}

class Instances {
  final List<Configuration>? configurations;
  Instances({this.configurations});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('Instances'), [], [
    if (configurations != null) ...configurations!.map((e) => e.toXml()),
  ]);
}

class Configuration extends i2.TextualObjectBase {
  final List<Resource>? resources;
  final String name;
  Configuration({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.resources,
    required this.name,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Configuration'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      if (resources != null) ...resources!.map((e) => e.toXml()),
    ],
  );
}

class Resource extends i2.TextualObjectBase {
  final List<i2.VarList>? globalVars;
  final String name;
  final String resourceTypeName;
  Resource({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.globalVars,
    required this.name,
    required this.resourceTypeName,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Resource'),
    [
      i1.XmlAttribute(i1.XmlName('name'), name),
      i1.XmlAttribute(i1.XmlName('resourceTypeName'), resourceTypeName),
    ],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      if (globalVars != null) ...globalVars!.map((e) => e.toXml()),
    ],
  );
}

abstract class TypeSpecBase {
  i1.XmlNode toXml();
}

abstract class InstantlyDefinableTypeSpecBase extends i2.TypeSpecBase {}

abstract class BehaviorRepresentationBase {
  i1.XmlNode toXml();
}

abstract class ProgrammingLanguageBase extends i2.BehaviorRepresentationBase {}

abstract class IdentifiedObjectBase {
  final i2.TextBase documentation;
  final i2.AddData addData;
  IdentifiedObjectBase({required this.documentation, required this.addData});
  i1.XmlNode toXml();
}

abstract class GraphicalObjectBase extends i2.IdentifiedObjectBase {
  GraphicalObjectBase({required super.documentation, required super.addData});
}

abstract class CommonObjectBase extends i2.GraphicalObjectBase {
  CommonObjectBase({required super.documentation, required super.addData});
}

abstract class FbdObjectBase extends i2.GraphicalObjectBase {
  FbdObjectBase({required super.documentation, required super.addData});
}

abstract class LdObjectBase extends i2.GraphicalObjectBase {
  LdObjectBase({required super.documentation, required super.addData});
}

abstract class NetworkBase extends i2.GraphicalObjectBase {
  final String? label;
  final int evaluationOrder;
  NetworkBase({
    required super.documentation,
    required super.addData,
    this.label,
    required this.evaluationOrder,
  });
}

abstract class TextualObjectBase extends i2.IdentifiedObjectBase {
  final List<String?>? usingDirectives;
  TextualObjectBase({
    required super.documentation,
    required super.addData,
    this.usingDirectives,
  });
}

abstract class NamespaceContentBase extends i2.TextualObjectBase {
  final String name;
  NamespaceContentBase({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.name,
  });
}

class NamespaceDecl extends i2.NamespaceContentBase {
  final List<NamespaceDeclItem>? items;
  NamespaceDecl({
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.items,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('NamespaceDecl'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      if (items != null) ...items!.map((e) => e.toXml()),
    ],
  );
}

/// Common interface for: [ToBeResolvedLater], [ToBeResolvedLater], [ToBeResolvedLater], [ToBeResolvedLater]
abstract interface class NamespaceDeclItem {
  i1.XmlNode toXml();
}

class UserDefinedTypeDecl extends i2.NamespaceContentBase {
  final i2.TypeSpecBase userDefinedTypeSpec;
  UserDefinedTypeDecl({
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.userDefinedTypeSpec,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('UserDefinedTypeDecl'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      userDefinedTypeSpec.toXml(),
    ],
  );
}

class ArrayTypeSpec extends i2.InstantlyDefinableTypeSpecBase {
  final i2.TypeRef baseType;
  final List<DimensionSpec> dimensionSpecs;
  final i2.AddData addData;
  ArrayTypeSpec({
    required this.baseType,
    required this.dimensionSpecs,
    required this.addData,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('ArrayTypeSpec'), [], [
    baseType.toXml(),
    ...dimensionSpecs.map((e) => e.toXml()),
    addData.toXml(),
  ]);
}

class DimensionSpec {
  final DimensionSpecItem item;
  DimensionSpec({required this.item});
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('DimensionSpec'), [], [item.toXml()]);
}

/// Common interface for: [IndexRange], [VariableLength]
abstract interface class DimensionSpecItem {
  i1.XmlNode toXml();
}

class IndexRange implements DimensionSpecItem {
  final String lower;
  final String upper;
  IndexRange({required this.lower, required this.upper});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('IndexRange'), [
    i1.XmlAttribute(i1.XmlName('lower'), lower),
    i1.XmlAttribute(i1.XmlName('upper'), upper),
  ], []);
}

class VariableLength implements DimensionSpecItem {
  final bool item;
  VariableLength({required this.item});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('VariableLength'), [], [
    i1.XmlText(item.toString()),
  ]);
}

class EnumTypeSpec extends i2.TypeSpecBase {
  final List<EnumeratorWithoutValue> enumerators;
  final i2.AddData addData;
  EnumTypeSpec({required this.enumerators, required this.addData});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('EnumTypeSpec'), [], [
    ...enumerators.map((e) => e.toXml()),
    addData.toXml(),
  ]);
}

class EnumeratorWithoutValue {
  final i2.TextBase documentation;
  final String name;
  EnumeratorWithoutValue({required this.documentation, required this.name});
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Enumerator'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [documentation.toXml()],
  );
}

class EnumTypeWithNamedValueSpec extends i2.TypeSpecBase {
  final List<Enumerator> enumerators;
  final i2.ElementaryType baseType;
  final i2.AddData addData;
  EnumTypeWithNamedValueSpec({
    required this.enumerators,
    required this.baseType,
    required this.addData,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('EnumTypeWithNamedValueSpec'),
    [],
    [...enumerators.map((e) => e.toXml()), baseType.toXml(), addData.toXml()],
  );
}

class Enumerator {
  final i2.TextBase documentation;
  final String name;
  final String value;
  Enumerator({
    required this.documentation,
    required this.name,
    required this.value,
  });
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Enumerator'),
    [
      i1.XmlAttribute(i1.XmlName('name'), name),
      i1.XmlAttribute(i1.XmlName('value'), value),
    ],
    [documentation.toXml()],
  );
}

class StructTypeSpec extends i2.TypeSpecBase {
  final List<i2.VariableDecl> members;
  final i2.AddData addData;
  final bool? overlap;
  StructTypeSpec({required this.members, required this.addData, this.overlap});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('StructTypeSpec'),
    [
      if (overlap != null)
        i1.XmlAttribute(i1.XmlName('overlap'), overlap!.toString()),
    ],
    [...members.map((e) => e.toXml()), addData.toXml()],
  );
}

class Program extends i2.NamespaceContentBase {
  final List<i2.ExternalVarList>? externalVars;
  final List<i2.VarListWithAccessSpec>? vars;
  final i2.Body mainBody;
  Program({
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.externalVars,
    this.vars,
    required this.mainBody,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Program'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      if (externalVars != null) ...externalVars!.map((e) => e.toXml()),
      if (vars != null) ...vars!.map((e) => e.toXml()),
      mainBody.toXml(),
    ],
  );
}

class FunctionBlock extends i2.NamespaceContentBase {
  final i2.ParameterSet parameters;
  final List<i2.ExternalVarList>? externalVars;
  final List<i2.VarListWithAccessSpec>? vars;
  final i2.Body mainBody;
  FunctionBlock({
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.parameters,
    this.externalVars,
    this.vars,
    required this.mainBody,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('FunctionBlock'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      parameters.toXml(),
      if (externalVars != null) ...externalVars!.map((e) => e.toXml()),
      if (vars != null) ...vars!.map((e) => e.toXml()),
      mainBody.toXml(),
    ],
  );
}

class Function$ extends i2.NamespaceContentBase {
  final i2.TypeRef resultType;
  final i2.ParameterSet parameters;
  final List<i2.ExternalVarList>? externalVars;
  final List<i2.VarList>? tempVars;
  final i2.BodyWithoutSFC mainBody;
  Function$({
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.resultType,
    required this.parameters,
    this.externalVars,
    this.tempVars,
    required this.mainBody,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Function'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      resultType.toXml(),
      parameters.toXml(),
      if (externalVars != null) ...externalVars!.map((e) => e.toXml()),
      if (tempVars != null) ...tempVars!.map((e) => e.toXml()),
      mainBody.toXml(),
    ],
  );
}

class ParameterSet {
  final List<ParameterSetItem>? items;
  ParameterSet({this.items});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('ParameterSet'), [], [
    if (items != null) ...items!.map((e) => e.toXml()),
  ]);
}

/// Common interface for: [InoutVars], [InputVars], [OutputVars]
abstract interface class ParameterSetItem {
  i1.XmlNode toXml();
}

class InoutVars implements ParameterSetItem {
  final List<ParameterInoutVariable>? variables;
  InoutVars({this.variables});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('InoutVars'), [], [
    if (variables != null) ...variables!.map((e) => e.toXml()),
  ]);
}

class ParameterInoutVariable extends i2.VariableDecl {
  final int orderWithinParamSet;
  ParameterInoutVariable({
    required super.initialValue,
    required super.address,
    required super.type,
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.orderWithinParamSet,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Variable'),
    [
      i1.XmlAttribute(i1.XmlName('name'), name),
      i1.XmlAttribute(
        i1.XmlName('orderWithinParamSet'),
        orderWithinParamSet.toString(),
      ),
    ],
    [
      initialValue.toXml(),
      address.toXml(),
      type.toXml(),
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
    ],
  );
}

class InputVars implements ParameterSetItem {
  final List<ParameterInputVariable>? variables;
  final bool? retain;
  final bool? nonRetain;
  InputVars({this.variables, this.retain, this.nonRetain});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('InputVars'),
    [
      if (retain != null)
        i1.XmlAttribute(i1.XmlName('retain'), retain!.toString()),
      if (nonRetain != null)
        i1.XmlAttribute(i1.XmlName('non_retain'), nonRetain!.toString()),
    ],
    [if (variables != null) ...variables!.map((e) => e.toXml())],
  );
}

class ParameterInputVariable extends i2.VariableDecl {
  final int orderWithinParamSet;
  final i2.EdgeModifierType edgeDetection;
  ParameterInputVariable({
    required super.initialValue,
    required super.address,
    required super.type,
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.orderWithinParamSet,
    required this.edgeDetection,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Variable'),
    [
      i1.XmlAttribute(i1.XmlName('name'), name),
      i1.XmlAttribute(
        i1.XmlName('orderWithinParamSet'),
        orderWithinParamSet.toString(),
      ),
      i1.XmlAttribute(i1.XmlName('edgeDetection'), switch (edgeDetection) {
        EdgeModifierType.none => 'none',
        EdgeModifierType.falling => 'falling',
        EdgeModifierType.rising => 'rising',
      }),
    ],
    [
      initialValue.toXml(),
      address.toXml(),
      type.toXml(),
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
    ],
  );
}

class OutputVars implements ParameterSetItem {
  final List<ParameterOutputVariable>? variables;
  final bool? retain;
  final bool? nonRetain;
  OutputVars({this.variables, this.retain, this.nonRetain});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('OutputVars'),
    [
      if (retain != null)
        i1.XmlAttribute(i1.XmlName('retain'), retain!.toString()),
      if (nonRetain != null)
        i1.XmlAttribute(i1.XmlName('non_retain'), nonRetain!.toString()),
    ],
    [if (variables != null) ...variables!.map((e) => e.toXml())],
  );
}

class ParameterOutputVariable extends i2.VariableDecl {
  final int orderWithinParamSet;
  ParameterOutputVariable({
    required super.initialValue,
    required super.address,
    required super.type,
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.orderWithinParamSet,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Variable'),
    [
      i1.XmlAttribute(i1.XmlName('name'), name),
      i1.XmlAttribute(
        i1.XmlName('orderWithinParamSet'),
        orderWithinParamSet.toString(),
      ),
    ],
    [
      initialValue.toXml(),
      address.toXml(),
      type.toXml(),
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
    ],
  );
}

class VarListWithAccessSpec extends i2.VarList {
  final i2.AccessSpecifiers accessSpecifier;
  VarListWithAccessSpec({
    super.variables,
    super.constant,
    super.retain,
    super.nonRetain,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.accessSpecifier,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('VarListWithAccessSpec'),
    [
      if (constant != null)
        i1.XmlAttribute(i1.XmlName('constant'), constant!.toString()),
      if (retain != null)
        i1.XmlAttribute(i1.XmlName('retain'), retain!.toString()),
      if (nonRetain != null)
        i1.XmlAttribute(i1.XmlName('non_retain'), nonRetain!.toString()),
      i1.XmlAttribute(i1.XmlName('accessSpecifier'), switch (accessSpecifier) {
        AccessSpecifiers.private => 'private',
      }),
    ],
    [
      if (variables != null) ...variables!.map((e) => e.toXml()),
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
    ],
  );
}

class Body extends i2.TextualObjectBase {
  final List<i2.BehaviorRepresentationBase> bodyContents;
  Body({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.bodyContents,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('Body'), [], [
    if (usingDirectives != null) ...usingDirectives!.map((e) => i1.XmlText(e!)),
    documentation.toXml(),
    addData.toXml(),
    ...bodyContents.map((e) => e.toXml()),
  ]);
}

class BodyWithoutSFC extends i2.TextualObjectBase {
  final List<i2.ProgrammingLanguageBase> bodyContents;
  BodyWithoutSFC({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.bodyContents,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('BodyWithoutSFC'), [], [
    if (usingDirectives != null) ...usingDirectives!.map((e) => i1.XmlText(e!)),
    documentation.toXml(),
    addData.toXml(),
    ...bodyContents.map((e) => e.toXml()),
  ]);
}

class VarList extends i2.TextualObjectBase {
  final List<i2.VariableDecl>? variables;
  final bool? constant;
  final bool? retain;
  final bool? nonRetain;
  VarList({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.variables,
    this.constant,
    this.retain,
    this.nonRetain,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('VarList'),
    [
      if (constant != null)
        i1.XmlAttribute(i1.XmlName('constant'), constant!.toString()),
      if (retain != null)
        i1.XmlAttribute(i1.XmlName('retain'), retain!.toString()),
      if (nonRetain != null)
        i1.XmlAttribute(i1.XmlName('non_retain'), nonRetain!.toString()),
    ],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      if (variables != null) ...variables!.map((e) => e.toXml()),
    ],
  );
}

class ExternalVarList extends i2.TextualObjectBase {
  final List<i2.VariableDeclPlain>? variables;
  final bool? constant;
  ExternalVarList({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.variables,
    this.constant,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('ExternalVarList'),
    [
      if (constant != null)
        i1.XmlAttribute(i1.XmlName('constant'), constant!.toString()),
    ],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      if (variables != null) ...variables!.map((e) => e.toXml()),
    ],
  );
}

class VariableDecl extends i2.VariableDeclPlain {
  final i2.Value initialValue;
  final i2.AddressExpression address;
  VariableDecl({
    required super.type,
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.initialValue,
    required this.address,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('VariableDecl'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      type.toXml(),
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      initialValue.toXml(),
      address.toXml(),
    ],
  );
}

class VariableDeclPlain extends i2.TextualObjectBase {
  final i2.TypeRef type;
  final String name;
  VariableDeclPlain({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    required this.type,
    required this.name,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('VariableDeclPlain'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
      type.toXml(),
    ],
  );
}

class TypeRef {
  final TypeRefItem item;
  TypeRef({required this.item});
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('TypeRef'), [], [item.toXml()]);
}

/// Common interface for: [TypeName], [ToBeResolvedLater]
abstract interface class TypeRefItem {
  i1.XmlNode toXml();
}

class TypeName implements TypeRefItem {
  final String item;
  TypeName({required this.item});
  @override
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('TypeName'), [], [i1.XmlText(item)]);
}

class Value {
  final ValueItem item;
  Value({required this.item});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('Value'), [], [item.toXml()]);
}

/// Common interface for: [SimpleValue], [ArrayValue], [StructValue]
abstract interface class ValueItem {
  i1.XmlNode toXml();
}

class SimpleValue implements ValueItem {
  final String? value;
  SimpleValue({this.value});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('SimpleValue'), [
    if (value != null) i1.XmlAttribute(i1.XmlName('value'), value!),
  ], []);
}

class ArrayValue implements ValueItem {
  final ArrayValueItem value;
  ArrayValue({required this.value});
  @override
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('ArrayValue'), [], [value.toXml()]);
}

class ArrayValueItem extends i2.Value {
  final String? repetitionValue;
  ArrayValueItem({required super.item, this.repetitionValue});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Value'),
    [
      if (repetitionValue != null)
        i1.XmlAttribute(i1.XmlName('repetitionValue'), repetitionValue!),
    ],
    [item.toXml()],
  );
}

class StructValue implements ValueItem {
  final StructValueItem value;
  StructValue({required this.value});
  @override
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('StructValue'), [], [value.toXml()]);
}

class StructValueItem extends i2.Value {
  final String member;
  StructValueItem({required super.item, required this.member});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Value'),
    [i1.XmlAttribute(i1.XmlName('member'), member)],
    [item.toXml()],
  );
}

class AddressExpression extends i2.FixedAddressExpression {
  AddressExpression({
    super.address,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('AddressExpression'),
    [if (address != null) i1.XmlAttribute(i1.XmlName('address'), address!)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
    ],
  );
}

class FixedAddressExpression extends i2.TextualObjectBase {
  final String? address;
  FixedAddressExpression({
    super.usingDirectives,
    required super.documentation,
    required super.addData,
    this.address,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('FixedAddressExpression'),
    [if (address != null) i1.XmlAttribute(i1.XmlName('address'), address!)],
    [
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
    ],
  );
}

class ST extends i2.ProgrammingLanguageBase {
  final String st;
  ST({required this.st});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('ST'), [], [i1.XmlText(st)]);
}

class LD extends i2.ProgrammingLanguageBase {
  final List<i2.LadderRung>? rungs;
  LD({this.rungs});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('LD'), [], [
    if (rungs != null) ...rungs!.map((e) => e.toXml()),
  ]);
}

class LadderRung extends i2.NetworkBase {
  final List<LadderRungItem>? items;
  LadderRung({
    super.label,
    required super.evaluationOrder,
    required super.documentation,
    required super.addData,
    this.items,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('LadderRung'),
    [
      if (label != null) i1.XmlAttribute(i1.XmlName('label'), label!),
      i1.XmlAttribute(
        i1.XmlName('evaluationOrder'),
        evaluationOrder.toString(),
      ),
    ],
    [
      documentation.toXml(),
      addData.toXml(),
      if (items != null) ...items!.map((e) => e.toXml()),
    ],
  );
}

/// Common interface for: [ToBeResolvedLater], [ToBeResolvedLater], [ToBeResolvedLater]
abstract interface class LadderRungItem {
  i1.XmlNode toXml();
}

class Comment extends i2.CommonObjectBase {
  final i2.TextBase content;
  Comment({
    required super.documentation,
    required super.addData,
    required this.content,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('Comment'), [], [
    documentation.toXml(),
    addData.toXml(),
    content.toXml(),
  ]);
}

class Block extends i2.FbdObjectBase {
  final InOutVariables? inOutVariables;
  final InputVariables? inputVariables;
  final OutputVariables? outputVariables;
  final String typeName;
  final String? instanceName;
  Block({
    required super.documentation,
    required super.addData,
    this.inOutVariables,
    this.inputVariables,
    this.outputVariables,
    required this.typeName,
    this.instanceName,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Block'),
    [
      i1.XmlAttribute(i1.XmlName('typeName'), typeName),
      if (instanceName != null)
        i1.XmlAttribute(i1.XmlName('instanceName'), instanceName!),
    ],
    [
      documentation.toXml(),
      addData.toXml(),
      if (inOutVariables != null) inOutVariables!.toXml(),
      if (inputVariables != null) inputVariables!.toXml(),
      if (outputVariables != null) outputVariables!.toXml(),
    ],
  );
}

class InOutVariables {
  final List<InOutVariable>? inOutVariables;
  InOutVariables({this.inOutVariables});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('InOutVariables'), [], [
    if (inOutVariables != null) ...inOutVariables!.map((e) => e.toXml()),
  ]);
}

class InOutVariable extends i2.IdentifiedObjectBase {
  final i2.ConnectionPointIn connectionPointIn;
  final i2.ConnectionPointOut connectionPointOut;
  final String parameterName;
  final bool? negated;
  InOutVariable({
    required super.documentation,
    required super.addData,
    required this.connectionPointIn,
    required this.connectionPointOut,
    required this.parameterName,
    this.negated,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('InOutVariable'),
    [
      i1.XmlAttribute(i1.XmlName('parameterName'), parameterName),
      if (negated != null)
        i1.XmlAttribute(i1.XmlName('negated'), negated!.toString()),
    ],
    [
      documentation.toXml(),
      addData.toXml(),
      connectionPointIn.toXml(),
      connectionPointOut.toXml(),
    ],
  );
}

class InputVariables {
  final List<InputVariable>? inputVariables;
  InputVariables({this.inputVariables});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('InputVariables'), [], [
    if (inputVariables != null) ...inputVariables!.map((e) => e.toXml()),
  ]);
}

class InputVariable extends i2.IdentifiedObjectBase {
  final i2.ConnectionPointIn connectionPointIn;
  final String parameterName;
  final bool? negated;
  final i2.EdgeModifierType edge;
  final bool? suppressName;
  InputVariable({
    required super.documentation,
    required super.addData,
    required this.connectionPointIn,
    required this.parameterName,
    this.negated,
    required this.edge,
    this.suppressName,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('InputVariable'),
    [
      i1.XmlAttribute(i1.XmlName('parameterName'), parameterName),
      if (negated != null)
        i1.XmlAttribute(i1.XmlName('negated'), negated!.toString()),
      i1.XmlAttribute(i1.XmlName('edge'), switch (edge) {
        EdgeModifierType.none => 'none',
        EdgeModifierType.falling => 'falling',
        EdgeModifierType.rising => 'rising',
      }),
      if (suppressName != null)
        i1.XmlAttribute(i1.XmlName('suppressName'), suppressName!.toString()),
    ],
    [documentation.toXml(), addData.toXml(), connectionPointIn.toXml()],
  );
}

class OutputVariables {
  final List<OutputVariable>? outputVariables;
  OutputVariables({this.outputVariables});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('OutputVariables'), [], [
    if (outputVariables != null) ...outputVariables!.map((e) => e.toXml()),
  ]);
}

class OutputVariable extends i2.IdentifiedObjectBase {
  final i2.ConnectionPointOut connectionPointOut;
  final String parameterName;
  final bool? negated;
  final bool? suppressName;
  OutputVariable({
    required super.documentation,
    required super.addData,
    required this.connectionPointOut,
    required this.parameterName,
    this.negated,
    this.suppressName,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('OutputVariable'),
    [
      i1.XmlAttribute(i1.XmlName('parameterName'), parameterName),
      if (negated != null)
        i1.XmlAttribute(i1.XmlName('negated'), negated!.toString()),
      if (suppressName != null)
        i1.XmlAttribute(i1.XmlName('suppressName'), suppressName!.toString()),
    ],
    [documentation.toXml(), addData.toXml(), connectionPointOut.toXml()],
  );
}

class DataSource extends i2.FbdObjectBase {
  final i2.ConnectionPointOut connectionPointOut;
  final String identifier;
  DataSource({
    required super.documentation,
    required super.addData,
    required this.connectionPointOut,
    required this.identifier,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('DataSource'),
    [i1.XmlAttribute(i1.XmlName('identifier'), identifier)],
    [documentation.toXml(), addData.toXml(), connectionPointOut.toXml()],
  );
}

class DataSink extends i2.FbdObjectBase {
  final i2.ConnectionPointIn connectionPointIn;
  final String identifier;
  DataSink({
    required super.documentation,
    required super.addData,
    required this.connectionPointIn,
    required this.identifier,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('DataSink'),
    [i1.XmlAttribute(i1.XmlName('identifier'), identifier)],
    [documentation.toXml(), addData.toXml(), connectionPointIn.toXml()],
  );
}

class Jump extends i2.FbdObjectBase {
  final i2.ConnectionPointIn connectionPointIn;
  final String targetNetworkLabel;
  Jump({
    required super.documentation,
    required super.addData,
    required this.connectionPointIn,
    required this.targetNetworkLabel,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Jump'),
    [i1.XmlAttribute(i1.XmlName('targetNetworkLabel'), targetNetworkLabel)],
    [documentation.toXml(), addData.toXml(), connectionPointIn.toXml()],
  );
}

class LeftPowerRail extends i2.LdObjectBase {
  final List<i2.ConnectionPointOut>? connectionPointOuts;
  LeftPowerRail({
    required super.documentation,
    required super.addData,
    this.connectionPointOuts,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('LeftPowerRail'), [], [
    documentation.toXml(),
    addData.toXml(),
    if (connectionPointOuts != null)
      ...connectionPointOuts!.map((e) => e.toXml()),
  ]);
}

class RightPowerRail extends i2.LdObjectBase {
  final List<i2.ConnectionPointIn>? connectionPointIns;
  RightPowerRail({
    required super.documentation,
    required super.addData,
    this.connectionPointIns,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('RightPowerRail'), [], [
    documentation.toXml(),
    addData.toXml(),
    if (connectionPointIns != null)
      ...connectionPointIns!.map((e) => e.toXml()),
  ]);
}

class Coil extends i2.LdObjectBase {
  final i2.ConnectionPointIn connectionPointIn;
  final i2.ConnectionPointOut connectionPointOut;
  final bool? negated;
  final i2.EdgeModifierType edge;
  final Latch? latch;
  final String operand;
  Coil({
    required super.documentation,
    required super.addData,
    required this.connectionPointIn,
    required this.connectionPointOut,
    this.negated,
    required this.edge,
    this.latch,
    required this.operand,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Coil'),
    [
      if (negated != null)
        i1.XmlAttribute(i1.XmlName('negated'), negated!.toString()),
      i1.XmlAttribute(i1.XmlName('edge'), switch (edge) {
        EdgeModifierType.none => 'none',
        EdgeModifierType.falling => 'falling',
        EdgeModifierType.rising => 'rising',
      }),
      if (latch != null)
        i1.XmlAttribute(i1.XmlName('latch'), switch (latch!) {
          Latch.none => 'none',
          Latch.set$ => 'set',
          Latch.reset => 'reset',
        }),
      i1.XmlAttribute(i1.XmlName('operand'), operand),
    ],
    [
      documentation.toXml(),
      addData.toXml(),
      connectionPointIn.toXml(),
      connectionPointOut.toXml(),
    ],
  );
}

class Contact extends i2.LdObjectBase {
  final i2.ConnectionPointIn connectionPointIn;
  final i2.ConnectionPointOut connectionPointOut;
  final bool? negated;
  final i2.EdgeModifierType edge;
  final String operand;
  Contact({
    required super.documentation,
    required super.addData,
    required this.connectionPointIn,
    required this.connectionPointOut,
    this.negated,
    required this.edge,
    required this.operand,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Contact'),
    [
      if (negated != null)
        i1.XmlAttribute(i1.XmlName('negated'), negated!.toString()),
      i1.XmlAttribute(i1.XmlName('edge'), switch (edge) {
        EdgeModifierType.none => 'none',
        EdgeModifierType.falling => 'falling',
        EdgeModifierType.rising => 'rising',
      }),
      i1.XmlAttribute(i1.XmlName('operand'), operand),
    ],
    [
      documentation.toXml(),
      addData.toXml(),
      connectionPointIn.toXml(),
      connectionPointOut.toXml(),
    ],
  );
}

class ConnectionPointIn extends i2.IdentifiedObjectBase {
  final List<i2.Connection>? connections;
  ConnectionPointIn({
    required super.documentation,
    required super.addData,
    this.connections,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('ConnectionPointIn'), [], [
    documentation.toXml(),
    addData.toXml(),
    if (connections != null) ...connections!.map((e) => e.toXml()),
  ]);
}

class Connection extends i2.IdentifiedObjectBase {
  final int refConnectionPointOutId;
  Connection({
    required super.documentation,
    required super.addData,
    required this.refConnectionPointOutId,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('Connection'),
    [
      i1.XmlAttribute(
        i1.XmlName('refConnectionPointOutId'),
        refConnectionPointOutId.toString(),
      ),
    ],
    [documentation.toXml(), addData.toXml()],
  );
}

class ConnectionPointOut extends i2.IdentifiedObjectBase {
  final int connectionPointOutId;
  ConnectionPointOut({
    required super.documentation,
    required super.addData,
    required this.connectionPointOutId,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('ConnectionPointOut'),
    [
      i1.XmlAttribute(
        i1.XmlName('connectionPointOutId'),
        connectionPointOutId.toString(),
      ),
    ],
    [documentation.toXml(), addData.toXml()],
  );
}

class XyDecimalValue {
  final double x;
  final double y;
  XyDecimalValue({required this.x, required this.y});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('XyDecimalValue'), [
    i1.XmlAttribute(i1.XmlName('x'), x.toString()),
    i1.XmlAttribute(i1.XmlName('y'), y.toString()),
  ], []);
}

class AddData {
  final List<Data>? data;
  AddData({this.data});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('AddData'), [], [
    if (data != null) ...data!.map((e) => e.toXml()),
  ]);
}

class Data {
  final Uri name;
  final HandleUnknown handleUnknown;
  Data({required this.name, required this.handleUnknown});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('Data'), [
    i1.XmlAttribute(i1.XmlName('name'), name.toString()),
    i1.XmlAttribute(i1.XmlName('handleUnknown'), switch (handleUnknown) {
      HandleUnknown.discard => 'discard',
    }),
  ], []);
}

abstract class TextBase {
  i1.XmlNode toXml();
}

class SimpleText extends i2.TextBase {
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('SimpleText'), [], []);
}

enum Latch {
  none,
  set$,
  reset;

  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('latch'), [], [
    switch (this) {
      Latch.none => i1.XmlText('none'),
      Latch.set$ => i1.XmlText('set'),
      Latch.reset => i1.XmlText('reset'),
    },
  ]);
}

enum HandleUnknown {
  discard;

  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('handleUnknown'), [], [
    switch (this) {
      HandleUnknown.discard => i1.XmlText('discard'),
    },
  ]);
}

enum ElementaryType {
  dint;

  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('ElementaryType'), [], [
    switch (this) {
      ElementaryType.dint => i1.XmlText('DINT'),
    },
  ]);
}

enum AccessSpecifiers {
  private;

  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('AccessSpecifiers'), [], [
    switch (this) {
      AccessSpecifiers.private => i1.XmlText('private'),
    },
  ]);
}

enum EdgeModifierType {
  none,
  falling,
  rising;

  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('EdgeModifierType'), [], [
    switch (this) {
      EdgeModifierType.none => i1.XmlText('none'),
      EdgeModifierType.falling => i1.XmlText('falling'),
      EdgeModifierType.rising => i1.XmlText('rising'),
    },
  ]);
}
