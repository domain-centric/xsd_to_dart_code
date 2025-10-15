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
}

class ContentHeader {
  final AddDataInfo? addDataInfo;
  final AddData? addData;
  final String name;
  final DateTime creationDateTime;
  ContentHeader({
    this.addDataInfo,
    this.addData,
    required this.name,
    required this.creationDateTime,
  });
}

class AddDataInfo {
  final List<Info>? info;
  AddDataInfo({this.info});
}

class Info {
  final String name;
  final double version;
  final String vendor;
  Info({required this.name, required this.version, required this.vendor});
}

class Types {
  final GlobalNamespace globalNamespace;
  Types({required this.globalNamespace});
}

class GlobalNamespace extends TextualObjectBase {
  final List<GlobalNamespaceItem>? items;
  GlobalNamespace({
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.items,
  });
}

/// Common interface for: [NamespaceDecl], [UserDefinedTypeDecl], [Program], [FunctionBlock], [Function$]
abstract interface class GlobalNamespaceItem {}

class Instances {
  final List<Configuration>? configurations;
  Instances({this.configurations});
}

class Configuration extends TextualObjectBase {
  final List<Resource>? resources;
  final String name;
  Configuration({
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.resources,
    required this.name,
  });
}

class Resource extends TextualObjectBase {
  final List<VarList>? globalVars;
  final String name;
  final String resourceTypeName;
  Resource({
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.globalVars,
    required this.name,
    required this.resourceTypeName,
  });
}

abstract class TypeSpecBase {}

abstract class InstantlyDefinableTypeSpecBase extends TypeSpecBase
    implements TypeRefItem {}

abstract class BehaviorRepresentationBase {}

abstract class ProgrammingLanguageBase extends BehaviorRepresentationBase {}

abstract class IdentifiedObjectBase {
  final TextBase? documentation;
  final AddData? addData;
  IdentifiedObjectBase({this.documentation, this.addData});
}

abstract class GraphicalObjectBase extends IdentifiedObjectBase {
  GraphicalObjectBase({super.documentation, super.addData});
}

abstract class CommonObjectBase extends GraphicalObjectBase
    implements LadderRungItem {
  CommonObjectBase({super.documentation, super.addData});
}

abstract class FbdObjectBase extends GraphicalObjectBase
    implements LadderRungItem {
  FbdObjectBase({super.documentation, super.addData});
}

abstract class LdObjectBase extends GraphicalObjectBase
    implements LadderRungItem {
  LdObjectBase({super.documentation, super.addData});
}

abstract class NetworkBase extends GraphicalObjectBase {
  final String? label;
  final int evaluationOrder;
  NetworkBase({
    super.documentation,
    super.addData,
    this.label,
    required this.evaluationOrder,
  });
}

abstract class TextualObjectBase extends IdentifiedObjectBase {
  final List<String?>? usingDirectives;
  TextualObjectBase({super.documentation, super.addData, this.usingDirectives});
}

abstract class NamespaceContentBase extends TextualObjectBase {
  final String name;
  NamespaceContentBase({
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.name,
  });
}

class NamespaceDecl extends NamespaceContentBase
    implements GlobalNamespaceItem, NamespaceDeclItem {
  final List<NamespaceDeclItem>? items;
  NamespaceDecl({
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.items,
  });
}

/// Common interface for: [NamespaceDecl], [UserDefinedTypeDecl], [FunctionBlock], [Function$]
abstract interface class NamespaceDeclItem {}

class UserDefinedTypeDecl extends NamespaceContentBase
    implements GlobalNamespaceItem, NamespaceDeclItem {
  final TypeSpecBase userDefinedTypeSpec;
  UserDefinedTypeDecl({
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.userDefinedTypeSpec,
  });
}

class ArrayTypeSpec extends InstantlyDefinableTypeSpecBase {
  final TypeRef baseType;
  final List<DimensionSpec> dimensionSpecs;
  final AddData? addData;
  ArrayTypeSpec({
    required this.baseType,
    required this.dimensionSpecs,
    this.addData,
  });
}

class DimensionSpec {
  final DimensionSpecItem item;
  DimensionSpec({required this.item});
}

/// Common interface for: [IndexRange]
abstract interface class DimensionSpecItem {}

class IndexRange implements DimensionSpecItem {
  final String lower;
  final String upper;
  IndexRange({required this.lower, required this.upper});
}

class EnumTypeSpec extends TypeSpecBase {
  final List<EnumeratorWithoutValue> enumerators;
  final AddData? addData;
  EnumTypeSpec({required this.enumerators, this.addData});
}

class EnumeratorWithoutValue {
  final TextBase? documentation;
  final String name;
  EnumeratorWithoutValue({this.documentation, required this.name});
}

class EnumTypeWithNamedValueSpec extends TypeSpecBase {
  final List<Enumerator> enumerators;
  final ElementaryType baseType;
  final AddData? addData;
  EnumTypeWithNamedValueSpec({
    required this.enumerators,
    required this.baseType,
    this.addData,
  });
}

class Enumerator {
  final TextBase? documentation;
  final String name;
  final String value;
  Enumerator({this.documentation, required this.name, required this.value});
}

class StructTypeSpec extends TypeSpecBase {
  final List<VariableDecl> members;
  final AddData? addData;
  final bool? overlap;
  StructTypeSpec({required this.members, this.addData, this.overlap});
}

class Program extends NamespaceContentBase implements GlobalNamespaceItem {
  final List<ExternalVarList>? externalVars;
  final List<VarListWithAccessSpec>? vars;
  final Body mainBody;
  Program({
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.externalVars,
    this.vars,
    required this.mainBody,
  });
}

class FunctionBlock extends NamespaceContentBase
    implements GlobalNamespaceItem, NamespaceDeclItem {
  final ParameterSet? parameters;
  final List<ExternalVarList>? externalVars;
  final List<VarListWithAccessSpec>? vars;
  final Body mainBody;
  FunctionBlock({
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.parameters,
    this.externalVars,
    this.vars,
    required this.mainBody,
  });
}

class Function$ extends NamespaceContentBase
    implements GlobalNamespaceItem, NamespaceDeclItem {
  final TypeRef? resultType;
  final ParameterSet parameters;
  final List<ExternalVarList>? externalVars;
  final List<VarList>? tempVars;
  final BodyWithoutSFC mainBody;
  Function$({
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.resultType,
    required this.parameters,
    this.externalVars,
    this.tempVars,
    required this.mainBody,
  });
}

class ParameterSet {
  final List<ParameterSetItem>? items;
  ParameterSet({this.items});
}

/// Common interface for: [InoutVars], [InputVars], [OutputVars]
abstract interface class ParameterSetItem {}

class InoutVars implements ParameterSetItem {
  final List<ParameterInoutVariable>? variables;
  InoutVars({this.variables});
}

class ParameterInoutVariable extends VariableDecl {
  final int orderWithinParamSet;
  ParameterInoutVariable({
    super.initialValue,
    super.address,
    required super.type,
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.orderWithinParamSet,
  });
}

class InputVars implements ParameterSetItem {
  final List<ParameterInputVariable>? variables;
  final bool? retain;
  final bool? nonRetain;
  InputVars({this.variables, this.retain, this.nonRetain});
}

class ParameterInputVariable extends VariableDecl {
  final int orderWithinParamSet;
  final EdgeModifierType? edgeDetection;
  ParameterInputVariable({
    super.initialValue,
    super.address,
    required super.type,
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.orderWithinParamSet,
    this.edgeDetection,
  });
}

class OutputVars implements ParameterSetItem {
  final List<ParameterOutputVariable>? variables;
  final bool? retain;
  final bool? nonRetain;
  OutputVars({this.variables, this.retain, this.nonRetain});
}

class ParameterOutputVariable extends VariableDecl {
  final int orderWithinParamSet;
  ParameterOutputVariable({
    super.initialValue,
    super.address,
    required super.type,
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.orderWithinParamSet,
  });
}

class VarListWithAccessSpec extends VarList {
  final AccessSpecifiers accessSpecifier;
  VarListWithAccessSpec({
    super.variables,
    super.constant,
    super.retain,
    super.nonRetain,
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.accessSpecifier,
  });
}

class Body extends TextualObjectBase {
  final List<BehaviorRepresentationBase> bodyContents;
  Body({
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.bodyContents,
  });
}

class BodyWithoutSFC extends TextualObjectBase {
  final List<ProgrammingLanguageBase> bodyContents;
  BodyWithoutSFC({
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.bodyContents,
  });
}

class VarList extends TextualObjectBase {
  final List<VariableDecl>? variables;
  final bool? constant;
  final bool? retain;
  final bool? nonRetain;
  VarList({
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.variables,
    this.constant,
    this.retain,
    this.nonRetain,
  });
}

class ExternalVarList extends TextualObjectBase {
  final List<VariableDeclPlain>? variables;
  final bool? constant;
  ExternalVarList({
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.variables,
    this.constant,
  });
}

class VariableDecl extends VariableDeclPlain {
  final Object? initialValue;
  final AddressExpression? address;
  VariableDecl({
    required super.type,
    required super.name,
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.initialValue,
    this.address,
  });
}

class VariableDeclPlain extends TextualObjectBase {
  final TypeRef type;
  final String name;
  VariableDeclPlain({
    super.usingDirectives,
    super.documentation,
    super.addData,
    required this.type,
    required this.name,
  });
}

class TypeRef {
  final TypeRefItem item;
  TypeRef({required this.item});
}

/// Common interface for: [InstantlyDefinableTypeSpecBase]
abstract interface class TypeRefItem {}

class Value {
  final ValueItem item;
  Value({required this.item});
}

/// Common interface for: [SimpleValue], [ArrayValue], [StructValue]
abstract interface class ValueItem {}

class SimpleValue implements ValueItem {
  final String? value;
  SimpleValue({this.value});
}

class ArrayValue implements ValueItem {
  final ArrayValueItem value;
  ArrayValue({required this.value});
}

class ArrayValueItem extends Value {
  final String? repetitionValue;
  ArrayValueItem({required super.item, this.repetitionValue});
}

class StructValue implements ValueItem {
  final StructValueItem value;
  StructValue({required this.value});
}

class StructValueItem extends Value {
  final String member;
  StructValueItem({required super.item, required this.member});
}

class AddressExpression extends FixedAddressExpression {
  AddressExpression({
    super.address,
    super.usingDirectives,
    super.documentation,
    super.addData,
  });
}

class FixedAddressExpression extends TextualObjectBase {
  final String? address;
  FixedAddressExpression({
    super.usingDirectives,
    super.documentation,
    super.addData,
    this.address,
  });
}

class ST extends ProgrammingLanguageBase {
  final String st;
  ST({required this.st});
}

class LD extends ProgrammingLanguageBase {
  final List<LadderRung>? rungs;
  LD({this.rungs});
}

class LadderRung extends NetworkBase {
  final List<LadderRungItem>? items;
  LadderRung({
    super.label,
    required super.evaluationOrder,
    super.documentation,
    super.addData,
    this.items,
  });
}

/// Common interface for: [CommonObjectBase], [LdObjectBase], [FbdObjectBase]
abstract interface class LadderRungItem {}

class Comment extends CommonObjectBase {
  final TextBase content;
  Comment({super.documentation, super.addData, required this.content});
}

class Block extends FbdObjectBase {
  final InOutVariables? inOutVariables;
  final InputVariables? inputVariables;
  final OutputVariables? outputVariables;
  final String typeName;
  final String? instanceName;
  Block({
    super.documentation,
    super.addData,
    this.inOutVariables,
    this.inputVariables,
    this.outputVariables,
    required this.typeName,
    this.instanceName,
  });
}

class InOutVariables {
  final List<InOutVariable>? inOutVariables;
  InOutVariables({this.inOutVariables});
}

class InOutVariable extends IdentifiedObjectBase {
  final ConnectionPointIn? connectionPointIn;
  final ConnectionPointOut? connectionPointOut;
  final String parameterName;
  final bool? negated;
  InOutVariable({
    super.documentation,
    super.addData,
    this.connectionPointIn,
    this.connectionPointOut,
    required this.parameterName,
    this.negated,
  });
}

class InputVariables {
  final List<InputVariable>? inputVariables;
  InputVariables({this.inputVariables});
}

class InputVariable extends IdentifiedObjectBase {
  final ConnectionPointIn? connectionPointIn;
  final String parameterName;
  final bool? negated;
  final EdgeModifierType? edge;
  final bool? suppressName;
  InputVariable({
    super.documentation,
    super.addData,
    this.connectionPointIn,
    required this.parameterName,
    this.negated,
    this.edge,
    this.suppressName,
  });
}

class OutputVariables {
  final List<OutputVariable>? outputVariables;
  OutputVariables({this.outputVariables});
}

class OutputVariable extends IdentifiedObjectBase {
  final ConnectionPointOut? connectionPointOut;
  final String parameterName;
  final bool? negated;
  final bool? suppressName;
  OutputVariable({
    super.documentation,
    super.addData,
    this.connectionPointOut,
    required this.parameterName,
    this.negated,
    this.suppressName,
  });
}

class DataSource extends FbdObjectBase {
  final ConnectionPointOut? connectionPointOut;
  final String identifier;
  DataSource({
    super.documentation,
    super.addData,
    this.connectionPointOut,
    required this.identifier,
  });
}

class DataSink extends FbdObjectBase {
  final ConnectionPointIn? connectionPointIn;
  final String identifier;
  DataSink({
    super.documentation,
    super.addData,
    this.connectionPointIn,
    required this.identifier,
  });
}

class Jump extends FbdObjectBase {
  final ConnectionPointIn? connectionPointIn;
  final String targetNetworkLabel;
  Jump({
    super.documentation,
    super.addData,
    this.connectionPointIn,
    required this.targetNetworkLabel,
  });
}

class LeftPowerRail extends LdObjectBase {
  final List<ConnectionPointOut>? connectionPointOuts;
  LeftPowerRail({super.documentation, super.addData, this.connectionPointOuts});
}

class RightPowerRail extends LdObjectBase {
  final List<ConnectionPointIn>? connectionPointIns;
  RightPowerRail({super.documentation, super.addData, this.connectionPointIns});
}

class Coil extends LdObjectBase {
  final ConnectionPointIn? connectionPointIn;
  final ConnectionPointOut? connectionPointOut;
  final bool? negated;
  final EdgeModifierType? edge;
  final Latch? latch;
  final String operand;
  Coil({
    super.documentation,
    super.addData,
    this.connectionPointIn,
    this.connectionPointOut,
    this.negated,
    this.edge,
    this.latch,
    required this.operand,
  });
}

class Contact extends LdObjectBase {
  final ConnectionPointIn? connectionPointIn;
  final ConnectionPointOut? connectionPointOut;
  final bool? negated;
  final EdgeModifierType? edge;
  final String operand;
  Contact({
    super.documentation,
    super.addData,
    this.connectionPointIn,
    this.connectionPointOut,
    this.negated,
    this.edge,
    required this.operand,
  });
}

class ConnectionPointIn extends IdentifiedObjectBase {
  final List<Connection>? connections;
  ConnectionPointIn({super.documentation, super.addData, this.connections});
}

class Connection extends IdentifiedObjectBase {
  final int refConnectionPointOutId;
  Connection({
    super.documentation,
    super.addData,
    required this.refConnectionPointOutId,
  });
}

class ConnectionPointOut extends IdentifiedObjectBase {
  final int connectionPointOutId;
  ConnectionPointOut({
    super.documentation,
    super.addData,
    required this.connectionPointOutId,
  });
}

class XyDecimalValue {
  final double x;
  final double y;
  XyDecimalValue({required this.x, required this.y});
}

class AddData {
  final List<Data>? data;
  AddData({this.data});
}

class Data {
  final String name;
  final HandleUnknown handleUnknown;
  Data({required this.name, required this.handleUnknown});
}

abstract class TextBase {}

class SimpleText extends TextBase {}

enum Latch { none, set$, reset }

enum HandleUnknown { discard }

enum ElementaryType { dint }

enum AccessSpecifiers { private }

enum EdgeModifierType { none, falling, rising }
