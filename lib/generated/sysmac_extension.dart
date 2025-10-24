import 'package:xml/xml.dart' as i1;
import 'spc.dart' as i2;
import 'sysmac_extension.dart' as i3;

class DeviceInfo {
  final String modelName;
  final String version;
  DeviceInfo({required this.modelName, required this.version});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('DeviceInfo'), [
    i1.XmlAttribute(i1.XmlName('modelName'), modelName),
    i1.XmlAttribute(i1.XmlName('version'), version),
  ], []);
}

class PouInfo {
  final String version;
  final String author;
  final DateTime creationDateTime;
  final DateTime modificationDateTime;
  PouInfo({
    required this.version,
    required this.author,
    required this.creationDateTime,
    required this.modificationDateTime,
  });
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('PouInfo'), [
    i1.XmlAttribute(i1.XmlName('version'), version),
    i1.XmlAttribute(i1.XmlName('author'), author),
    i1.XmlAttribute(
      i1.XmlName('creationDateTime'),
      creationDateTime.toIso8601String(),
    ),
    i1.XmlAttribute(
      i1.XmlName('modificationDateTime'),
      modificationDateTime.toIso8601String(),
    ),
  ], []);
}

class DebugProgram extends i2.Program {
  DebugProgram({
    super.externalVars,
    super.vars,
    required super.mainBody,
    required super.name,
    super.usingDirectives,
    required super.documentation,
    required super.addData,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('DebugProgram'),
    [i1.XmlAttribute(i1.XmlName('name'), name)],
    [
      if (externalVars != null) ...externalVars!.map((e) => e.toXml()),
      if (vars != null) ...vars!.map((e) => e.toXml()),
      mainBody.toXml(),
      if (usingDirectives != null)
        ...usingDirectives!.map((e) => i1.XmlText(e!)),
      documentation.toXml(),
      addData.toXml(),
    ],
  );
}

class ConnectionPointInOrder {
  final int order;
  ConnectionPointInOrder({required this.order});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('ConnectionPointInOrder'), [
    i1.XmlAttribute(i1.XmlName('order'), order.toString()),
  ], []);
}

class ConnectionPointOutOrder {
  final int order;
  ConnectionPointOutOrder({required this.order});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('ConnectionPointOutOrder'), [
    i1.XmlAttribute(i1.XmlName('order'), order.toString()),
  ], []);
}

class SmcSize {
  final double width;
  final double height;
  SmcSize({required this.width, required this.height});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('SmcSize'), [
    i1.XmlAttribute(i1.XmlName('width'), width.toString()),
    i1.XmlAttribute(i1.XmlName('height'), height.toString()),
  ], []);
}

class LdSection extends i2.LD {
  final String name;
  final int evaluationOrder;
  LdSection({super.rungs, required this.name, required this.evaluationOrder});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('LdSection'),
    [
      i1.XmlAttribute(i1.XmlName('name'), name),
      i1.XmlAttribute(
        i1.XmlName('evaluationOrder'),
        evaluationOrder.toString(),
      ),
    ],
    [if (rungs != null) ...rungs!.map((e) => e.toXml())],
  );
}

class InlineST extends i2.LdObjectBase {
  final i2.ConnectionPointIn connectionPointIn;
  final i2.ConnectionPointOut connectionPointOut;
  final i2.ST st;
  InlineST({
    required super.documentation,
    required super.addData,
    required this.connectionPointIn,
    required this.connectionPointOut,
    required this.st,
  });
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('InlineST'), [], [
    documentation.toXml(),
    addData.toXml(),
    connectionPointIn.toXml(),
    connectionPointOut.toXml(),
    st.toXml(),
  ]);
}

class StructTypeSpecAdditionalProperties {
  final OffsetType offsetType;
  StructTypeSpecAdditionalProperties({required this.offsetType});
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('StructTypeSpecAdditionalProperties'), [
        i1.XmlAttribute(i1.XmlName('offsetType'), switch (offsetType) {
          OffsetType.nj => 'NJ',
          OffsetType.cj => 'CJ',
          OffsetType.user => 'User',
        }),
      ], []);
}

class GlobalVariableAdditionalProperties {
  final NetworkPublish networkPublish;
  GlobalVariableAdditionalProperties({required this.networkPublish});
  i1.XmlNode toXml() =>
      i1.XmlElement(i1.XmlName('GlobalVariableAdditionalProperties'), [
        i1.XmlAttribute(i1.XmlName('networkPublish'), switch (networkPublish) {
          NetworkPublish.doNotPublish => 'DoNotPublish',
          NetworkPublish.publishOnly => 'PublishOnly',
          NetworkPublish.input => 'Input',
          NetworkPublish.output => 'Output',
        }),
      ], []);
}

class ParameterSetVariableAdditionalProperties {
  final bool constant;
  ParameterSetVariableAdditionalProperties({required this.constant});
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('ParameterSetVariableAdditionalProperties'),
    [i1.XmlAttribute(i1.XmlName('constant'), constant.toString())],
    [],
  );
}

class VariableComment extends i3.MultiComment {
  final List<ElementComment>? elementComments;
  VariableComment({super.texts, this.elementComments});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('VariableComment'), [], [
    if (texts != null) ...texts!.map((e) => e.toXml()),
    if (elementComments != null) ...elementComments!.map((e) => e.toXml()),
  ]);
}

class ElementComment extends i3.MultiComment {
  final String element;
  ElementComment({super.texts, required this.element});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('ElementComment'),
    [i1.XmlAttribute(i1.XmlName('element'), element)],
    [if (texts != null) ...texts!.map((e) => e.toXml())],
  );
}

class EnumeratorsComment {
  final List<EnumeratorComment>? enumeratorComments;
  EnumeratorsComment({this.enumeratorComments});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('EnumeratorsComment'), [], [
    if (enumeratorComments != null)
      ...enumeratorComments!.map((e) => e.toXml()),
  ]);
}

class EnumeratorComment extends i3.MultiComment {
  final String enumerator;
  EnumeratorComment({super.texts, required this.enumerator});
  @override
  i1.XmlNode toXml() => i1.XmlElement(
    i1.XmlName('EnumeratorComment'),
    [i1.XmlAttribute(i1.XmlName('enumerator'), enumerator)],
    [if (texts != null) ...texts!.map((e) => e.toXml())],
  );
}

class FunctionResultComment extends i3.MultiComment {
  FunctionResultComment({super.texts});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('FunctionResultComment'), [], [
    if (texts != null) ...texts!.map((e) => e.toXml()),
  ]);
}

class MultiComment {
  final List<i3.TextWithId>? texts;
  MultiComment({this.texts});
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('MultiComment'), [], [
    if (texts != null) ...texts!.map((e) => e.toXml()),
  ]);
}

class TextWithId extends i2.TextBase {
  final String id;
  TextWithId({required this.id});
  @override
  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('TextWithId'), [
    i1.XmlAttribute(i1.XmlName('id'), id),
  ], []);
}

enum OffsetType {
  nj,
  cj,
  user;

  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('offsetType'), [], [
    switch (this) {
      OffsetType.nj => i1.XmlText('NJ'),
      OffsetType.cj => i1.XmlText('CJ'),
      OffsetType.user => i1.XmlText('User'),
    },
  ]);
}

enum NetworkPublish {
  doNotPublish,
  publishOnly,
  input,
  output;

  i1.XmlNode toXml() => i1.XmlElement(i1.XmlName('networkPublish'), [], [
    switch (this) {
      NetworkPublish.doNotPublish => i1.XmlText('DoNotPublish'),
      NetworkPublish.publishOnly => i1.XmlText('PublishOnly'),
      NetworkPublish.input => i1.XmlText('Input'),
      NetworkPublish.output => i1.XmlText('Output'),
    },
  ]);
}
