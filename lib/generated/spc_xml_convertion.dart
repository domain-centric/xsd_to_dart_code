import 'spc.dart' as i1;
import 'package:xml/xml.dart' as i2;

extension ProjectXmlConverterExtension on i1.Project {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Project'));
}

extension FileHeaderXmlConverterExtension on i1.FileHeader {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('FileHeader'));
}

extension ContentHeaderXmlConverterExtension on i1.ContentHeader {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ContentHeader'));
}

extension AddDataInfoXmlConverterExtension on i1.AddDataInfo {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('AddDataInfo'));
}

extension InfoXmlConverterExtension on i1.Info {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Info'));
}

extension TypesXmlConverterExtension on i1.Types {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Types'));
}

extension GlobalNamespaceXmlConverterExtension on i1.GlobalNamespace {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('GlobalNamespace'));
}

extension InstancesXmlConverterExtension on i1.Instances {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Instances'));
}

extension ConfigurationXmlConverterExtension on i1.Configuration {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Configuration'));
}

extension ResourceXmlConverterExtension on i1.Resource {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Resource'));
}

extension NamespaceDeclXmlConverterExtension on i1.NamespaceDecl {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('NamespaceDecl'));
}

extension UserDefinedTypeDeclXmlConverterExtension on i1.UserDefinedTypeDecl {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('UserDefinedTypeDecl'));
}

extension ArrayTypeSpecXmlConverterExtension on i1.ArrayTypeSpec {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ArrayTypeSpec'));
}

extension DimensionSpecXmlConverterExtension on i1.DimensionSpec {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('DimensionSpec'));
}

extension IndexRangeXmlConverterExtension on i1.IndexRange {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('IndexRange'));
}

extension EnumTypeSpecXmlConverterExtension on i1.EnumTypeSpec {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('EnumTypeSpec'));
}

extension EnumeratorWithoutValueXmlConverterExtension
    on i1.EnumeratorWithoutValue {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Enumerator'));
}

extension EnumTypeWithNamedValueSpecXmlConverterExtension
    on i1.EnumTypeWithNamedValueSpec {
  i2.XmlElement toXml() =>
      i2.XmlElement(i2.XmlName('EnumTypeWithNamedValueSpec'));
}

extension EnumeratorXmlConverterExtension on i1.Enumerator {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Enumerator'));
}

extension StructTypeSpecXmlConverterExtension on i1.StructTypeSpec {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('StructTypeSpec'));
}

extension ProgramXmlConverterExtension on i1.Program {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Program'));
}

extension FunctionBlockXmlConverterExtension on i1.FunctionBlock {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('FunctionBlock'));
}

extension Function$XmlConverterExtension on i1.Function$ {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Function'));
}

extension ParameterSetXmlConverterExtension on i1.ParameterSet {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ParameterSet'));
}

extension InoutVarsXmlConverterExtension on i1.InoutVars {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('InoutVars'));
}

extension ParameterInoutVariableXmlConverterExtension
    on i1.ParameterInoutVariable {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Variable'));
}

extension InputVarsXmlConverterExtension on i1.InputVars {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('InputVars'));
}

extension ParameterInputVariableXmlConverterExtension
    on i1.ParameterInputVariable {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Variable'));
}

extension OutputVarsXmlConverterExtension on i1.OutputVars {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('OutputVars'));
}

extension ParameterOutputVariableXmlConverterExtension
    on i1.ParameterOutputVariable {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Variable'));
}

extension VarListWithAccessSpecXmlConverterExtension
    on i1.VarListWithAccessSpec {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('VarListWithAccessSpec'));
}

extension BodyXmlConverterExtension on i1.Body {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Body'));
}

extension BodyWithoutSFCXmlConverterExtension on i1.BodyWithoutSFC {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('BodyWithoutSFC'));
}

extension VarListXmlConverterExtension on i1.VarList {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('VarList'));
}

extension ExternalVarListXmlConverterExtension on i1.ExternalVarList {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ExternalVarList'));
}

extension VariableDeclXmlConverterExtension on i1.VariableDecl {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('VariableDecl'));
}

extension VariableDeclPlainXmlConverterExtension on i1.VariableDeclPlain {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('VariableDeclPlain'));
}

extension TypeRefXmlConverterExtension on i1.TypeRef {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('TypeRef'));
}

extension ValueXmlConverterExtension on i1.Value {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Value'));
}

extension SimpleValueXmlConverterExtension on i1.SimpleValue {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('SimpleValue'));
}

extension ArrayValueXmlConverterExtension on i1.ArrayValue {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ArrayValue'));
}

extension ArrayValueItemXmlConverterExtension on i1.ArrayValueItem {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Value'));
}

extension StructValueXmlConverterExtension on i1.StructValue {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('StructValue'));
}

extension StructValueItemXmlConverterExtension on i1.StructValueItem {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Value'));
}

extension AddressExpressionXmlConverterExtension on i1.AddressExpression {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('AddressExpression'));
}

extension FixedAddressExpressionXmlConverterExtension
    on i1.FixedAddressExpression {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('FixedAddressExpression'));
}

extension STXmlConverterExtension on i1.ST {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ST'));
}

extension LDXmlConverterExtension on i1.LD {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('LD'));
}

extension LadderRungXmlConverterExtension on i1.LadderRung {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('LadderRung'));
}

extension CommentXmlConverterExtension on i1.Comment {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Comment'));
}

extension BlockXmlConverterExtension on i1.Block {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Block'));
}

extension InOutVariablesXmlConverterExtension on i1.InOutVariables {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('InOutVariables'));
}

extension InOutVariableXmlConverterExtension on i1.InOutVariable {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('InOutVariable'));
}

extension InputVariablesXmlConverterExtension on i1.InputVariables {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('InputVariables'));
}

extension InputVariableXmlConverterExtension on i1.InputVariable {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('InputVariable'));
}

extension OutputVariablesXmlConverterExtension on i1.OutputVariables {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('OutputVariables'));
}

extension OutputVariableXmlConverterExtension on i1.OutputVariable {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('OutputVariable'));
}

extension DataSourceXmlConverterExtension on i1.DataSource {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('DataSource'));
}

extension DataSinkXmlConverterExtension on i1.DataSink {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('DataSink'));
}

extension JumpXmlConverterExtension on i1.Jump {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Jump'));
}

extension LeftPowerRailXmlConverterExtension on i1.LeftPowerRail {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('LeftPowerRail'));
}

extension RightPowerRailXmlConverterExtension on i1.RightPowerRail {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('RightPowerRail'));
}

extension CoilXmlConverterExtension on i1.Coil {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Coil'));
}

extension ContactXmlConverterExtension on i1.Contact {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Contact'));
}

extension ConnectionPointInXmlConverterExtension on i1.ConnectionPointIn {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ConnectionPointIn'));
}

extension ConnectionXmlConverterExtension on i1.Connection {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Connection'));
}

extension ConnectionPointOutXmlConverterExtension on i1.ConnectionPointOut {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('ConnectionPointOut'));
}

extension XyDecimalValueXmlConverterExtension on i1.XyDecimalValue {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('XyDecimalValue'));
}

extension AddDataXmlConverterExtension on i1.AddData {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('AddData'));
}

extension DataXmlConverterExtension on i1.Data {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('Data'));
}

extension SimpleTextXmlConverterExtension on i1.SimpleText {
  i2.XmlElement toXml() => i2.XmlElement(i2.XmlName('SimpleText'));
}
