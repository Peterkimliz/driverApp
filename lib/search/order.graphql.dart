// import '../schema.gql.dart';
// import 'dart:async';
// import 'package:flutter/widgets.dart' as widgets;
// import 'package:gql/ast.dart';
// import 'package:graphql/client.dart' as graphql;
// import 'package:graphql_flutter/graphql_flutter.dart' as graphql_flutter;
// import 'package:safiri/graphql/scalars/timestamp.dart';
//
// class Variables$Query$getPlaces {
//   factory Variables$Query$getPlaces({
//     required String keyWord,
//     Input$PointInput? point,
//     required String language,
//     int? radius,
//     Enum$GeoProvider? provider,
//   }) =>
//       Variables$Query$getPlaces._({
//         r'keyWord': keyWord,
//         if (point != null) r'point': point,
//         r'language': language,
//         if (radius != null) r'radius': radius,
//         if (provider != null) r'provider': provider,
//       });
//
//   Variables$Query$getPlaces._(this._$data);
//
//   factory Variables$Query$getPlaces.fromJson(Map<String, dynamic> data) {
//     final result$data = <String, dynamic>{};
//     final l$keyWord = data['keyWord'];
//     result$data['keyWord'] = (l$keyWord as String);
//     if (data.containsKey('point')) {
//       final l$point = data['point'];
//       result$data['point'] = l$point == null
//           ? null
//           : Input$PointInput.fromJson((l$point as Map<String, dynamic>));
//     }
//     final l$language = data['language'];
//     result$data['language'] = (l$language as String);
//     if (data.containsKey('radius')) {
//       final l$radius = data['radius'];
//       result$data['radius'] = (l$radius as int?);
//     }
//     if (data.containsKey('provider')) {
//       final l$provider = data['provider'];
//       result$data['provider'] = l$provider == null
//           ? null
//           : fromJson$Enum$GeoProvider((l$provider as String));
//     }
//     return Variables$Query$getPlaces._(result$data);
//   }
//
//   Map<String, dynamic> _$data;
//
//   String get keyWord => (_$data['keyWord'] as String);
//
//   Input$PointInput? get point => (_$data['point'] as Input$PointInput?);
//
//   String get language => (_$data['language'] as String);
//
//   int? get radius => (_$data['radius'] as int?);
//
//   Enum$GeoProvider? get provider => (_$data['provider'] as Enum$GeoProvider?);
//
//   Map<String, dynamic> toJson() {
//     final result$data = <String, dynamic>{};
//     final l$keyWord = keyWord;
//     result$data['keyWord'] = l$keyWord;
//     if (_$data.containsKey('point')) {
//       final l$point = point;
//       result$data['point'] = l$point?.toJson();
//     }
//     final l$language = language;
//     result$data['language'] = l$language;
//     if (_$data.containsKey('radius')) {
//       final l$radius = radius;
//       result$data['radius'] = l$radius;
//     }
//     if (_$data.containsKey('provider')) {
//       final l$provider = provider;
//       result$data['provider'] =
//           l$provider == null ? null : toJson$Enum$GeoProvider(l$provider);
//     }
//     return result$data;
//   }
//
//   CopyWith$Variables$Query$getPlaces<Variables$Query$getPlaces> get copyWith =>
//       CopyWith$Variables$Query$getPlaces(
//         this,
//         (i) => i,
//       );
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Variables$Query$getPlaces) ||
//         runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$keyWord = keyWord;
//     final lOther$keyWord = other.keyWord;
//     if (l$keyWord != lOther$keyWord) {
//       return false;
//     }
//     final l$point = point;
//     final lOther$point = other.point;
//     if (_$data.containsKey('point') != other._$data.containsKey('point')) {
//       return false;
//     }
//     if (l$point != lOther$point) {
//       return false;
//     }
//     final l$language = language;
//     final lOther$language = other.language;
//     if (l$language != lOther$language) {
//       return false;
//     }
//     final l$radius = radius;
//     final lOther$radius = other.radius;
//     if (_$data.containsKey('radius') != other._$data.containsKey('radius')) {
//       return false;
//     }
//     if (l$radius != lOther$radius) {
//       return false;
//     }
//     final l$provider = provider;
//     final lOther$provider = other.provider;
//     if (_$data.containsKey('provider') !=
//         other._$data.containsKey('provider')) {
//       return false;
//     }
//     if (l$provider != lOther$provider) {
//       return false;
//     }
//     return true;
//   }
//
//   @override
//   int get hashCode {
//     final l$keyWord = keyWord;
//     final l$point = point;
//     final l$language = language;
//     final l$radius = radius;
//     final l$provider = provider;
//     return Object.hashAll([
//       l$keyWord,
//       _$data.containsKey('point') ? l$point : const {},
//       l$language,
//       _$data.containsKey('radius') ? l$radius : const {},
//       _$data.containsKey('provider') ? l$provider : const {},
//     ]);
//   }
// }
//
// abstract class CopyWith$Variables$Query$getPlaces<TRes> {
//   factory CopyWith$Variables$Query$getPlaces(
//     Variables$Query$getPlaces instance,
//     TRes Function(Variables$Query$getPlaces) then,
//   ) = _CopyWithImpl$Variables$Query$getPlaces;
//
//   factory CopyWith$Variables$Query$getPlaces.stub(TRes res) =
//       _CopyWithStubImpl$Variables$Query$getPlaces;
//
//   TRes call({
//     String? keyWord,
//     Input$PointInput? point,
//     String? language,
//     int? radius,
//     Enum$GeoProvider? provider,
//   });
// }
//
// class _CopyWithImpl$Variables$Query$getPlaces<TRes>
//     implements CopyWith$Variables$Query$getPlaces<TRes> {
//   _CopyWithImpl$Variables$Query$getPlaces(
//     this._instance,
//     this._then,
//   );
//
//   final Variables$Query$getPlaces _instance;
//
//   final TRes Function(Variables$Query$getPlaces) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({
//     Object? keyWord = _undefined,
//     Object? point = _undefined,
//     Object? language = _undefined,
//     Object? radius = _undefined,
//     Object? provider = _undefined,
//   }) =>
//       _then(Variables$Query$getPlaces._({
//         ..._instance._$data,
//         if (keyWord != _undefined && keyWord != null)
//           'keyWord': (keyWord as String),
//         if (point != _undefined) 'point': (point as Input$PointInput?),
//         if (language != _undefined && language != null)
//           'language': (language as String),
//         if (radius != _undefined) 'radius': (radius as int?),
//         if (provider != _undefined) 'provider': (provider as Enum$GeoProvider?),
//       }));
// }
//
// class _CopyWithStubImpl$Variables$Query$getPlaces<TRes>
//     implements CopyWith$Variables$Query$getPlaces<TRes> {
//   _CopyWithStubImpl$Variables$Query$getPlaces(this._res);
//
//   TRes _res;
//
//   call({
//     String? keyWord,
//     Input$PointInput? point,
//     String? language,
//     int? radius,
//     Enum$GeoProvider? provider,
//   }) =>
//       _res;
// }
//
// class Query$getPlaces {
//   Query$getPlaces({required this.getPlaces});
//
//   factory Query$getPlaces.fromJson(Map<String, dynamic> json) {
//     final l$getPlaces = json['getPlaces'];
//     return Query$getPlaces(
//         getPlaces: (l$getPlaces as List<dynamic>)
//             .map((e) =>
//                 Query$getPlaces$getPlaces.fromJson((e as Map<String, dynamic>)))
//             .toList());
//   }
//
//   final List<Query$getPlaces$getPlaces> getPlaces;
//
//   Map<String, dynamic> toJson() {
//     final _resultData = <String, dynamic>{};
//     final l$getPlaces = getPlaces;
//     _resultData['getPlaces'] = l$getPlaces.map((e) => e.toJson()).toList();
//     return _resultData;
//   }
//
//   @override
//   int get hashCode {
//     final l$getPlaces = getPlaces;
//     return Object.hashAll([Object.hashAll(l$getPlaces.map((v) => v))]);
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Query$getPlaces) || runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$getPlaces = getPlaces;
//     final lOther$getPlaces = other.getPlaces;
//     if (l$getPlaces.length != lOther$getPlaces.length) {
//       return false;
//     }
//     for (int i = 0; i < l$getPlaces.length; i++) {
//       final l$getPlaces$entry = l$getPlaces[i];
//       final lOther$getPlaces$entry = lOther$getPlaces[i];
//       if (l$getPlaces$entry != lOther$getPlaces$entry) {
//         return false;
//       }
//     }
//     return true;
//   }
// }
//
// extension UtilityExtension$Query$getPlaces on Query$getPlaces {
//   CopyWith$Query$getPlaces<Query$getPlaces> get copyWith =>
//       CopyWith$Query$getPlaces(
//         this,
//         (i) => i,
//       );
// }
//
// abstract class CopyWith$Query$getPlaces<TRes> {
//   factory CopyWith$Query$getPlaces(
//     Query$getPlaces instance,
//     TRes Function(Query$getPlaces) then,
//   ) = _CopyWithImpl$Query$getPlaces;
//
//   factory CopyWith$Query$getPlaces.stub(TRes res) =
//       _CopyWithStubImpl$Query$getPlaces;
//
//   TRes call({List<Query$getPlaces$getPlaces>? getPlaces});
//
//   TRes getPlaces(
//       Iterable<Query$getPlaces$getPlaces> Function(
//               Iterable<
//                   CopyWith$Query$getPlaces$getPlaces<
//                       Query$getPlaces$getPlaces>>)
//           _fn);
// }
//
// class _CopyWithImpl$Query$getPlaces<TRes>
//     implements CopyWith$Query$getPlaces<TRes> {
//   _CopyWithImpl$Query$getPlaces(
//     this._instance,
//     this._then,
//   );
//
//   final Query$getPlaces _instance;
//
//   final TRes Function(Query$getPlaces) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({Object? getPlaces = _undefined}) => _then(Query$getPlaces(
//       getPlaces: getPlaces == _undefined || getPlaces == null
//           ? _instance.getPlaces
//           : (getPlaces as List<Query$getPlaces$getPlaces>)));
//
//   TRes getPlaces(
//           Iterable<Query$getPlaces$getPlaces> Function(
//                   Iterable<
//                       CopyWith$Query$getPlaces$getPlaces<
//                           Query$getPlaces$getPlaces>>)
//               _fn) =>
//       call(
//           getPlaces: _fn(
//               _instance.getPlaces.map((e) => CopyWith$Query$getPlaces$getPlaces(
//                     e,
//                     (i) => i,
//                   ))).toList());
// }
//
// class _CopyWithStubImpl$Query$getPlaces<TRes>
//     implements CopyWith$Query$getPlaces<TRes> {
//   _CopyWithStubImpl$Query$getPlaces(this._res);
//
//   TRes _res;
//
//   call({List<Query$getPlaces$getPlaces>? getPlaces}) => _res;
//
//   getPlaces(_fn) => _res;
// }
//
// const documentNodeQuerygetPlaces = DocumentNode(definitions: [
//   OperationDefinitionNode(
//     type: OperationType.query,
//     name: NameNode(value: 'getPlaces'),
//     variableDefinitions: [
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'keyWord')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'String'),
//           isNonNull: true,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'point')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'PointInput'),
//           isNonNull: false,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'language')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'String'),
//           isNonNull: true,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'radius')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'Int'),
//           isNonNull: false,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'provider')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'GeoProvider'),
//           isNonNull: false,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//     ],
//     directives: [],
//     selectionSet: SelectionSetNode(selections: [
//       FieldNode(
//         name: NameNode(value: 'getPlaces'),
//         alias: null,
//         arguments: [
//           ArgumentNode(
//             name: NameNode(value: 'keyword'),
//             value: VariableNode(name: NameNode(value: 'keyWord')),
//           ),
//           ArgumentNode(
//             name: NameNode(value: 'location'),
//             value: VariableNode(name: NameNode(value: 'point')),
//           ),
//           ArgumentNode(
//             name: NameNode(value: 'language'),
//             value: VariableNode(name: NameNode(value: 'language')),
//           ),
//           ArgumentNode(
//             name: NameNode(value: 'radius'),
//             value: VariableNode(name: NameNode(value: 'radius')),
//           ),
//           ArgumentNode(
//             name: NameNode(value: 'provider'),
//             value: VariableNode(name: NameNode(value: 'provider')),
//           ),
//         ],
//         directives: [],
//         selectionSet: SelectionSetNode(selections: [
//           FieldNode(
//             name: NameNode(value: 'point'),
//             alias: null,
//             arguments: [],
//             directives: [],
//             selectionSet: SelectionSetNode(selections: [
//               FieldNode(
//                 name: NameNode(value: 'lat'),
//                 alias: null,
//                 arguments: [],
//                 directives: [],
//                 selectionSet: null,
//               ),
//               FieldNode(
//                 name: NameNode(value: 'lng'),
//                 alias: null,
//                 arguments: [],
//                 directives: [],
//                 selectionSet: null,
//               ),
//               FragmentSpreadNode(
//                 name: NameNode(value: 'Point'),
//                 directives: [],
//               ),
//             ]),
//           ),
//           FieldNode(
//             name: NameNode(value: 'title'),
//             alias: null,
//             arguments: [],
//             directives: [],
//             selectionSet: null,
//           ),
//           FieldNode(
//             name: NameNode(value: 'address'),
//             alias: null,
//             arguments: [],
//             directives: [],
//             selectionSet: null,
//           ),
//         ]),
//       )
//     ]),
//   ),
//   fragmentDefinitionPoint,
// ]);
//
// Query$getPlaces _parserFn$Query$getPlaces(Map<String, dynamic> data) =>
//     Query$getPlaces.fromJson(data);
//
// typedef OnQueryComplete$Query$getPlaces = FutureOr<void> Function(
//   Map<String, dynamic>?,
//   Query$getPlaces?,
// );
//
// class Options$Query$getPlaces extends graphql.QueryOptions<Query$getPlaces> {
//   Options$Query$getPlaces({
//     String? operationName,
//     required Variables$Query$getPlaces variables,
//     graphql.FetchPolicy? fetchPolicy,
//     graphql.ErrorPolicy? errorPolicy,
//     graphql.CacheRereadPolicy? cacheRereadPolicy,
//     Object? optimisticResult,
//     Query$getPlaces? typedOptimisticResult,
//     Duration? pollInterval,
//     graphql.Context? context,
//     OnQueryComplete$Query$getPlaces? onComplete,
//     graphql.OnQueryError? onError,
//   })  : onCompleteWithParsed = onComplete,
//         super(
//           variables: variables.toJson(),
//           operationName: operationName,
//           fetchPolicy: fetchPolicy,
//           errorPolicy: errorPolicy,
//           cacheRereadPolicy: cacheRereadPolicy,
//           optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
//           pollInterval: pollInterval,
//           context: context,
//           onComplete: onComplete == null
//               ? null
//               : (data) => onComplete(
//                     data,
//                     data == null ? null : _parserFn$Query$getPlaces(data),
//                   ),
//           onError: onError,
//           document: documentNodeQuerygetPlaces,
//           parserFn: _parserFn$Query$getPlaces,
//         );
//
//   final OnQueryComplete$Query$getPlaces? onCompleteWithParsed;
//
//   @override
//   List<Object?> get properties => [
//         ...super.onComplete == null
//             ? super.properties
//             : super.properties.where((property) => property != onComplete),
//         onCompleteWithParsed,
//       ];
// }
//
// class WatchOptions$Query$getPlaces
//     extends graphql.WatchQueryOptions<Query$getPlaces> {
//   WatchOptions$Query$getPlaces({
//     String? operationName,
//     required Variables$Query$getPlaces variables,
//     graphql.FetchPolicy? fetchPolicy,
//     graphql.ErrorPolicy? errorPolicy,
//     graphql.CacheRereadPolicy? cacheRereadPolicy,
//     Object? optimisticResult,
//     Query$getPlaces? typedOptimisticResult,
//     graphql.Context? context,
//     Duration? pollInterval,
//     bool? eagerlyFetchResults,
//     bool carryForwardDataOnException = true,
//     bool fetchResults = false,
//   }) : super(
//           variables: variables.toJson(),
//           operationName: operationName,
//           fetchPolicy: fetchPolicy,
//           errorPolicy: errorPolicy,
//           cacheRereadPolicy: cacheRereadPolicy,
//           optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
//           context: context,
//           document: documentNodeQuerygetPlaces,
//           pollInterval: pollInterval,
//           eagerlyFetchResults: eagerlyFetchResults,
//           carryForwardDataOnException: carryForwardDataOnException,
//           fetchResults: fetchResults,
//           parserFn: _parserFn$Query$getPlaces,
//         );
// }
//
// class FetchMoreOptions$Query$getPlaces extends graphql.FetchMoreOptions {
//   FetchMoreOptions$Query$getPlaces({
//     required graphql.UpdateQuery updateQuery,
//     required Variables$Query$getPlaces variables,
//   }) : super(
//           updateQuery: updateQuery,
//           variables: variables.toJson(),
//           document: documentNodeQuerygetPlaces,
//         );
// }
//
// extension ClientExtension$Query$getPlaces on graphql.GraphQLClient {
//   Future<graphql.QueryResult<Query$getPlaces>> query$getPlaces(
//           Options$Query$getPlaces options) async =>
//       await this.query(options);
//
//   graphql.ObservableQuery<Query$getPlaces> watchQuery$getPlaces(
//           WatchOptions$Query$getPlaces options) =>
//       this.watchQuery(options);
//
//   void writeQuery$getPlaces({
//     required Query$getPlaces data,
//     required Variables$Query$getPlaces variables,
//     bool broadcast = true,
//   }) =>
//       this.writeQuery(
//         graphql.Request(
//           operation: graphql.Operation(document: documentNodeQuerygetPlaces),
//           variables: variables.toJson(),
//         ),
//         data: data.toJson(),
//         broadcast: broadcast,
//       );
//
//   Query$getPlaces? readQuery$getPlaces({
//     required Variables$Query$getPlaces variables,
//     bool optimistic = true,
//   }) {
//     final result = this.readQuery(
//       graphql.Request(
//         operation: graphql.Operation(document: documentNodeQuerygetPlaces),
//         variables: variables.toJson(),
//       ),
//       optimistic: optimistic,
//     );
//     return result == null ? null : Query$getPlaces.fromJson(result);
//   }
// }
//
// graphql_flutter.QueryHookResult<Query$getPlaces> useQuery$getPlaces(
//         Options$Query$getPlaces options) =>
//     graphql_flutter.useQuery(options);
//
// graphql.ObservableQuery<Query$getPlaces> useWatchQuery$getPlaces(
//         WatchOptions$Query$getPlaces options) =>
//     graphql_flutter.useWatchQuery(options);
//
// class Query$getPlaces$Widget extends graphql_flutter.Query<Query$getPlaces> {
//   Query$getPlaces$Widget({
//     widgets.Key? key,
//     required Options$Query$getPlaces options,
//     required graphql_flutter.QueryBuilder<Query$getPlaces> builder,
//   }) : super(
//           key: key,
//           options: options,
//           builder: builder,
//         );
// }
//
// class Query$getPlaces$getPlaces {
//   Query$getPlaces$getPlaces({
//     required this.point,
//     this.title,
//     required this.address,
//   });
//
//   factory Query$getPlaces$getPlaces.fromJson(Map<String, dynamic> json) {
//     final l$point = json['point'];
//     final l$title = json['title'];
//     final l$address = json['address'];
//     return Query$getPlaces$getPlaces(
//       point: Query$getPlaces$getPlaces$point.fromJson(
//           (l$point as Map<String, dynamic>)),
//       title: (l$title as String?),
//       address: (l$address as String),
//     );
//   }
//
//   final Query$getPlaces$getPlaces$point point;
//
//   final String? title;
//
//   final String address;
//
//   Map<String, dynamic> toJson() {
//     final _resultData = <String, dynamic>{};
//     final l$point = point;
//     _resultData['point'] = l$point.toJson();
//     final l$title = title;
//     _resultData['title'] = l$title;
//     final l$address = address;
//     _resultData['address'] = l$address;
//     return _resultData;
//   }
//
//   @override
//   int get hashCode {
//     final l$point = point;
//     final l$title = title;
//     final l$address = address;
//     return Object.hashAll([
//       l$point,
//       l$title,
//       l$address,
//     ]);
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Query$getPlaces$getPlaces) ||
//         runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$point = point;
//     final lOther$point = other.point;
//     if (l$point != lOther$point) {
//       return false;
//     }
//     final l$title = title;
//     final lOther$title = other.title;
//     if (l$title != lOther$title) {
//       return false;
//     }
//     final l$address = address;
//     final lOther$address = other.address;
//     if (l$address != lOther$address) {
//       return false;
//     }
//     return true;
//   }
// }
//
// extension UtilityExtension$Query$getPlaces$getPlaces
//     on Query$getPlaces$getPlaces {
//   CopyWith$Query$getPlaces$getPlaces<Query$getPlaces$getPlaces> get copyWith =>
//       CopyWith$Query$getPlaces$getPlaces(
//         this,
//         (i) => i,
//       );
// }
//
// abstract class CopyWith$Query$getPlaces$getPlaces<TRes> {
//   factory CopyWith$Query$getPlaces$getPlaces(
//     Query$getPlaces$getPlaces instance,
//     TRes Function(Query$getPlaces$getPlaces) then,
//   ) = _CopyWithImpl$Query$getPlaces$getPlaces;
//
//   factory CopyWith$Query$getPlaces$getPlaces.stub(TRes res) =
//       _CopyWithStubImpl$Query$getPlaces$getPlaces;
//
//   TRes call({
//     Query$getPlaces$getPlaces$point? point,
//     String? title,
//     String? address,
//   });
//
//   CopyWith$Query$getPlaces$getPlaces$point<TRes> get point;
// }
//
// class _CopyWithImpl$Query$getPlaces$getPlaces<TRes>
//     implements CopyWith$Query$getPlaces$getPlaces<TRes> {
//   _CopyWithImpl$Query$getPlaces$getPlaces(
//     this._instance,
//     this._then,
//   );
//
//   final Query$getPlaces$getPlaces _instance;
//
//   final TRes Function(Query$getPlaces$getPlaces) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({
//     Object? point = _undefined,
//     Object? title = _undefined,
//     Object? address = _undefined,
//   }) =>
//       _then(Query$getPlaces$getPlaces(
//         point: point == _undefined || point == null
//             ? _instance.point
//             : (point as Query$getPlaces$getPlaces$point),
//         title: title == _undefined ? _instance.title : (title as String?),
//         address: address == _undefined || address == null
//             ? _instance.address
//             : (address as String),
//       ));
//
//   CopyWith$Query$getPlaces$getPlaces$point<TRes> get point {
//     final local$point = _instance.point;
//     return CopyWith$Query$getPlaces$getPlaces$point(
//         local$point, (e) => call(point: e));
//   }
// }
//
// class _CopyWithStubImpl$Query$getPlaces$getPlaces<TRes>
//     implements CopyWith$Query$getPlaces$getPlaces<TRes> {
//   _CopyWithStubImpl$Query$getPlaces$getPlaces(this._res);
//
//   TRes _res;
//
//   call({
//     Query$getPlaces$getPlaces$point? point,
//     String? title,
//     String? address,
//   }) =>
//       _res;
//
//   CopyWith$Query$getPlaces$getPlaces$point<TRes> get point =>
//       CopyWith$Query$getPlaces$getPlaces$point.stub(_res);
// }
//
// class Query$getPlaces$getPlaces$point implements Fragment$Point {
//   Query$getPlaces$getPlaces$point({
//     required this.lat,
//     required this.lng,
//   });
//
//   factory Query$getPlaces$getPlaces$point.fromJson(Map<String, dynamic> json) {
//     final l$lat = json['lat'];
//     final l$lng = json['lng'];
//     return Query$getPlaces$getPlaces$point(
//       lat: (l$lat as num).toDouble(),
//       lng: (l$lng as num).toDouble(),
//     );
//   }
//
//   final double lat;
//
//   final double lng;
//
//   Map<String, dynamic> toJson() {
//     final _resultData = <String, dynamic>{};
//     final l$lat = lat;
//     _resultData['lat'] = l$lat;
//     final l$lng = lng;
//     _resultData['lng'] = l$lng;
//     return _resultData;
//   }
//
//   @override
//   int get hashCode {
//     final l$lat = lat;
//     final l$lng = lng;
//     return Object.hashAll([
//       l$lat,
//       l$lng,
//     ]);
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Query$getPlaces$getPlaces$point) ||
//         runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$lat = lat;
//     final lOther$lat = other.lat;
//     if (l$lat != lOther$lat) {
//       return false;
//     }
//     final l$lng = lng;
//     final lOther$lng = other.lng;
//     if (l$lng != lOther$lng) {
//       return false;
//     }
//     return true;
//   }
// }
//
// extension UtilityExtension$Query$getPlaces$getPlaces$point
//     on Query$getPlaces$getPlaces$point {
//   CopyWith$Query$getPlaces$getPlaces$point<Query$getPlaces$getPlaces$point>
//       get copyWith => CopyWith$Query$getPlaces$getPlaces$point(
//             this,
//             (i) => i,
//           );
// }
//
// abstract class CopyWith$Query$getPlaces$getPlaces$point<TRes> {
//   factory CopyWith$Query$getPlaces$getPlaces$point(
//     Query$getPlaces$getPlaces$point instance,
//     TRes Function(Query$getPlaces$getPlaces$point) then,
//   ) = _CopyWithImpl$Query$getPlaces$getPlaces$point;
//
//   factory CopyWith$Query$getPlaces$getPlaces$point.stub(TRes res) =
//       _CopyWithStubImpl$Query$getPlaces$getPlaces$point;
//
//   TRes call({
//     double? lat,
//     double? lng,
//   });
// }
//
// class _CopyWithImpl$Query$getPlaces$getPlaces$point<TRes>
//     implements CopyWith$Query$getPlaces$getPlaces$point<TRes> {
//   _CopyWithImpl$Query$getPlaces$getPlaces$point(
//     this._instance,
//     this._then,
//   );
//
//   final Query$getPlaces$getPlaces$point _instance;
//
//   final TRes Function(Query$getPlaces$getPlaces$point) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({
//     Object? lat = _undefined,
//     Object? lng = _undefined,
//   }) =>
//       _then(Query$getPlaces$getPlaces$point(
//         lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
//         lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
//       ));
// }
//
// class _CopyWithStubImpl$Query$getPlaces$getPlaces$point<TRes>
//     implements CopyWith$Query$getPlaces$getPlaces$point<TRes> {
//   _CopyWithStubImpl$Query$getPlaces$getPlaces$point(this._res);
//
//   TRes _res;
//
//   call({
//     double? lat,
//     double? lng,
//   }) =>
//       _res;
// }
//
// class Variables$Query$reverseGeocode {
//   factory Variables$Query$reverseGeocode({
//     required Input$PointInput location,
//     Enum$GeoProvider? provider,
//     required String language,
//   }) =>
//       Variables$Query$reverseGeocode._({
//         r'location': location,
//         if (provider != null) r'provider': provider,
//         r'language': language,
//       });
//
//   Variables$Query$reverseGeocode._(this._$data);
//
//   factory Variables$Query$reverseGeocode.fromJson(Map<String, dynamic> data) {
//     final result$data = <String, dynamic>{};
//     final l$location = data['location'];
//     result$data['location'] =
//         Input$PointInput.fromJson((l$location as Map<String, dynamic>));
//     if (data.containsKey('provider')) {
//       final l$provider = data['provider'];
//       result$data['provider'] = l$provider == null
//           ? null
//           : fromJson$Enum$GeoProvider((l$provider as String));
//     }
//     final l$language = data['language'];
//     result$data['language'] = (l$language as String);
//     return Variables$Query$reverseGeocode._(result$data);
//   }
//
//   Map<String, dynamic> _$data;
//
//   Input$PointInput get location => (_$data['location'] as Input$PointInput);
//
//   Enum$GeoProvider? get provider => (_$data['provider'] as Enum$GeoProvider?);
//
//   String get language => (_$data['language'] as String);
//
//   Map<String, dynamic> toJson() {
//     final result$data = <String, dynamic>{};
//     final l$location = location;
//     result$data['location'] = l$location.toJson();
//     if (_$data.containsKey('provider')) {
//       final l$provider = provider;
//       result$data['provider'] =
//           l$provider == null ? null : toJson$Enum$GeoProvider(l$provider);
//     }
//     final l$language = language;
//     result$data['language'] = l$language;
//     return result$data;
//   }
//
//   CopyWith$Variables$Query$reverseGeocode<Variables$Query$reverseGeocode>
//       get copyWith => CopyWith$Variables$Query$reverseGeocode(
//             this,
//             (i) => i,
//           );
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Variables$Query$reverseGeocode) ||
//         runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$location = location;
//     final lOther$location = other.location;
//     if (l$location != lOther$location) {
//       return false;
//     }
//     final l$provider = provider;
//     final lOther$provider = other.provider;
//     if (_$data.containsKey('provider') !=
//         other._$data.containsKey('provider')) {
//       return false;
//     }
//     if (l$provider != lOther$provider) {
//       return false;
//     }
//     final l$language = language;
//     final lOther$language = other.language;
//     if (l$language != lOther$language) {
//       return false;
//     }
//     return true;
//   }
//
//   @override
//   int get hashCode {
//     final l$location = location;
//     final l$provider = provider;
//     final l$language = language;
//     return Object.hashAll([
//       l$location,
//       _$data.containsKey('provider') ? l$provider : const {},
//       l$language,
//     ]);
//   }
// }
//
// abstract class CopyWith$Variables$Query$reverseGeocode<TRes> {
//   factory CopyWith$Variables$Query$reverseGeocode(
//     Variables$Query$reverseGeocode instance,
//     TRes Function(Variables$Query$reverseGeocode) then,
//   ) = _CopyWithImpl$Variables$Query$reverseGeocode;
//
//   factory CopyWith$Variables$Query$reverseGeocode.stub(TRes res) =
//       _CopyWithStubImpl$Variables$Query$reverseGeocode;
//
//   TRes call({
//     Input$PointInput? location,
//     Enum$GeoProvider? provider,
//     String? language,
//   });
// }
//
// class _CopyWithImpl$Variables$Query$reverseGeocode<TRes>
//     implements CopyWith$Variables$Query$reverseGeocode<TRes> {
//   _CopyWithImpl$Variables$Query$reverseGeocode(
//     this._instance,
//     this._then,
//   );
//
//   final Variables$Query$reverseGeocode _instance;
//
//   final TRes Function(Variables$Query$reverseGeocode) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({
//     Object? location = _undefined,
//     Object? provider = _undefined,
//     Object? language = _undefined,
//   }) =>
//       _then(Variables$Query$reverseGeocode._({
//         ..._instance._$data,
//         if (location != _undefined && location != null)
//           'location': (location as Input$PointInput),
//         if (provider != _undefined) 'provider': (provider as Enum$GeoProvider?),
//         if (language != _undefined && language != null)
//           'language': (language as String),
//       }));
// }
//
// class _CopyWithStubImpl$Variables$Query$reverseGeocode<TRes>
//     implements CopyWith$Variables$Query$reverseGeocode<TRes> {
//   _CopyWithStubImpl$Variables$Query$reverseGeocode(this._res);
//
//   TRes _res;
//
//   call({
//     Input$PointInput? location,
//     Enum$GeoProvider? provider,
//     String? language,
//   }) =>
//       _res;
// }
//
// class Query$reverseGeocode {
//   Query$reverseGeocode({required this.reverseGeocode});
//
//   factory Query$reverseGeocode.fromJson(Map<String, dynamic> json) {
//     final l$reverseGeocode = json['reverseGeocode'];
//     return Query$reverseGeocode(
//         reverseGeocode: Query$reverseGeocode$reverseGeocode.fromJson(
//             (l$reverseGeocode as Map<String, dynamic>)));
//   }
//
//   final Query$reverseGeocode$reverseGeocode reverseGeocode;
//
//   Map<String, dynamic> toJson() {
//     final _resultData = <String, dynamic>{};
//     final l$reverseGeocode = reverseGeocode;
//     _resultData['reverseGeocode'] = l$reverseGeocode.toJson();
//     return _resultData;
//   }
//
//   @override
//   int get hashCode {
//     final l$reverseGeocode = reverseGeocode;
//     return Object.hashAll([l$reverseGeocode]);
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Query$reverseGeocode) || runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$reverseGeocode = reverseGeocode;
//     final lOther$reverseGeocode = other.reverseGeocode;
//     if (l$reverseGeocode != lOther$reverseGeocode) {
//       return false;
//     }
//     return true;
//   }
// }
//
// extension UtilityExtension$Query$reverseGeocode on Query$reverseGeocode {
//   CopyWith$Query$reverseGeocode<Query$reverseGeocode> get copyWith =>
//       CopyWith$Query$reverseGeocode(
//         this,
//         (i) => i,
//       );
// }
//
// abstract class CopyWith$Query$reverseGeocode<TRes> {
//   factory CopyWith$Query$reverseGeocode(
//     Query$reverseGeocode instance,
//     TRes Function(Query$reverseGeocode) then,
//   ) = _CopyWithImpl$Query$reverseGeocode;
//
//   factory CopyWith$Query$reverseGeocode.stub(TRes res) =
//       _CopyWithStubImpl$Query$reverseGeocode;
//
//   TRes call({Query$reverseGeocode$reverseGeocode? reverseGeocode});
//
//   CopyWith$Query$reverseGeocode$reverseGeocode<TRes> get reverseGeocode;
// }
//
// class _CopyWithImpl$Query$reverseGeocode<TRes>
//     implements CopyWith$Query$reverseGeocode<TRes> {
//   _CopyWithImpl$Query$reverseGeocode(
//     this._instance,
//     this._then,
//   );
//
//   final Query$reverseGeocode _instance;
//
//   final TRes Function(Query$reverseGeocode) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({Object? reverseGeocode = _undefined}) =>
//       _then(Query$reverseGeocode(
//           reverseGeocode: reverseGeocode == _undefined || reverseGeocode == null
//               ? _instance.reverseGeocode
//               : (reverseGeocode as Query$reverseGeocode$reverseGeocode)));
//
//   CopyWith$Query$reverseGeocode$reverseGeocode<TRes> get reverseGeocode {
//     final local$reverseGeocode = _instance.reverseGeocode;
//     return CopyWith$Query$reverseGeocode$reverseGeocode(
//         local$reverseGeocode, (e) => call(reverseGeocode: e));
//   }
// }
//
// class _CopyWithStubImpl$Query$reverseGeocode<TRes>
//     implements CopyWith$Query$reverseGeocode<TRes> {
//   _CopyWithStubImpl$Query$reverseGeocode(this._res);
//
//   TRes _res;
//
//   call({Query$reverseGeocode$reverseGeocode? reverseGeocode}) => _res;
//
//   CopyWith$Query$reverseGeocode$reverseGeocode<TRes> get reverseGeocode =>
//       CopyWith$Query$reverseGeocode$reverseGeocode.stub(_res);
// }
//
// const documentNodeQueryreverseGeocode = DocumentNode(definitions: [
//   OperationDefinitionNode(
//     type: OperationType.query,
//     name: NameNode(value: 'reverseGeocode'),
//     variableDefinitions: [
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'location')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'PointInput'),
//           isNonNull: true,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'provider')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'GeoProvider'),
//           isNonNull: false,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//       VariableDefinitionNode(
//         variable: VariableNode(name: NameNode(value: 'language')),
//         type: NamedTypeNode(
//           name: NameNode(value: 'String'),
//           isNonNull: true,
//         ),
//         defaultValue: DefaultValueNode(value: null),
//         directives: [],
//       ),
//     ],
//     directives: [],
//     selectionSet: SelectionSetNode(selections: [
//       FieldNode(
//         name: NameNode(value: 'reverseGeocode'),
//         alias: null,
//         arguments: [
//           ArgumentNode(
//             name: NameNode(value: 'location'),
//             value: VariableNode(name: NameNode(value: 'location')),
//           ),
//           ArgumentNode(
//             name: NameNode(value: 'provider'),
//             value: VariableNode(name: NameNode(value: 'provider')),
//           ),
//           ArgumentNode(
//             name: NameNode(value: 'language'),
//             value: VariableNode(name: NameNode(value: 'language')),
//           ),
//         ],
//         directives: [],
//         selectionSet: SelectionSetNode(selections: [
//           FieldNode(
//             name: NameNode(value: 'point'),
//             alias: null,
//             arguments: [],
//             directives: [],
//             selectionSet: SelectionSetNode(selections: [
//               FieldNode(
//                 name: NameNode(value: 'lat'),
//                 alias: null,
//                 arguments: [],
//                 directives: [],
//                 selectionSet: null,
//               ),
//               FieldNode(
//                 name: NameNode(value: 'lng'),
//                 alias: null,
//                 arguments: [],
//                 directives: [],
//                 selectionSet: null,
//               ),
//               FragmentSpreadNode(
//                 name: NameNode(value: 'Point'),
//                 directives: [],
//               ),
//             ]),
//           ),
//           FieldNode(
//             name: NameNode(value: 'title'),
//             alias: null,
//             arguments: [],
//             directives: [],
//             selectionSet: null,
//           ),
//           FieldNode(
//             name: NameNode(value: 'address'),
//             alias: null,
//             arguments: [],
//             directives: [],
//             selectionSet: null,
//           ),
//         ]),
//       )
//     ]),
//   ),
//   fragmentDefinitionPoint,
// ]);
//
// Query$reverseGeocode _parserFn$Query$reverseGeocode(
//         Map<String, dynamic> data) =>
//     Query$reverseGeocode.fromJson(data);
//
// typedef OnQueryComplete$Query$reverseGeocode = FutureOr<void> Function(
//   Map<String, dynamic>?,
//   Query$reverseGeocode?,
// );
//
// class Options$Query$reverseGeocode
//     extends graphql.QueryOptions<Query$reverseGeocode> {
//   Options$Query$reverseGeocode({
//     String? operationName,
//     required Variables$Query$reverseGeocode variables,
//     graphql.FetchPolicy? fetchPolicy,
//     graphql.ErrorPolicy? errorPolicy,
//     graphql.CacheRereadPolicy? cacheRereadPolicy,
//     Object? optimisticResult,
//     Query$reverseGeocode? typedOptimisticResult,
//     Duration? pollInterval,
//     graphql.Context? context,
//     OnQueryComplete$Query$reverseGeocode? onComplete,
//     graphql.OnQueryError? onError,
//   })  : onCompleteWithParsed = onComplete,
//         super(
//           variables: variables.toJson(),
//           operationName: operationName,
//           fetchPolicy: fetchPolicy,
//           errorPolicy: errorPolicy,
//           cacheRereadPolicy: cacheRereadPolicy,
//           optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
//           pollInterval: pollInterval,
//           context: context,
//           onComplete: onComplete == null
//               ? null
//               : (data) => onComplete(
//                     data,
//                     data == null ? null : _parserFn$Query$reverseGeocode(data),
//                   ),
//           onError: onError,
//           document: documentNodeQueryreverseGeocode,
//           parserFn: _parserFn$Query$reverseGeocode,
//         );
//
//   final OnQueryComplete$Query$reverseGeocode? onCompleteWithParsed;
//
//   @override
//   List<Object?> get properties => [
//         ...super.onComplete == null
//             ? super.properties
//             : super.properties.where((property) => property != onComplete),
//         onCompleteWithParsed,
//       ];
// }
//
// class WatchOptions$Query$reverseGeocode
//     extends graphql.WatchQueryOptions<Query$reverseGeocode> {
//   WatchOptions$Query$reverseGeocode({
//     String? operationName,
//     required Variables$Query$reverseGeocode variables,
//     graphql.FetchPolicy? fetchPolicy,
//     graphql.ErrorPolicy? errorPolicy,
//     graphql.CacheRereadPolicy? cacheRereadPolicy,
//     Object? optimisticResult,
//     Query$reverseGeocode? typedOptimisticResult,
//     graphql.Context? context,
//     Duration? pollInterval,
//     bool? eagerlyFetchResults,
//     bool carryForwardDataOnException = true,
//     bool fetchResults = false,
//   }) : super(
//           variables: variables.toJson(),
//           operationName: operationName,
//           fetchPolicy: fetchPolicy,
//           errorPolicy: errorPolicy,
//           cacheRereadPolicy: cacheRereadPolicy,
//           optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
//           context: context,
//           document: documentNodeQueryreverseGeocode,
//           pollInterval: pollInterval,
//           eagerlyFetchResults: eagerlyFetchResults,
//           carryForwardDataOnException: carryForwardDataOnException,
//           fetchResults: fetchResults,
//           parserFn: _parserFn$Query$reverseGeocode,
//         );
// }
//
// class FetchMoreOptions$Query$reverseGeocode extends graphql.FetchMoreOptions {
//   FetchMoreOptions$Query$reverseGeocode({
//     required graphql.UpdateQuery updateQuery,
//     required Variables$Query$reverseGeocode variables,
//   }) : super(
//           updateQuery: updateQuery,
//           variables: variables.toJson(),
//           document: documentNodeQueryreverseGeocode,
//         );
// }
//
// extension ClientExtension$Query$reverseGeocode on graphql.GraphQLClient {
//   Future<graphql.QueryResult<Query$reverseGeocode>> query$reverseGeocode(
//           Options$Query$reverseGeocode options) async =>
//       await this.query(options);
//
//   graphql.ObservableQuery<Query$reverseGeocode> watchQuery$reverseGeocode(
//           WatchOptions$Query$reverseGeocode options) =>
//       this.watchQuery(options);
//
//   void writeQuery$reverseGeocode({
//     required Query$reverseGeocode data,
//     required Variables$Query$reverseGeocode variables,
//     bool broadcast = true,
//   }) =>
//       this.writeQuery(
//         graphql.Request(
//           operation:
//               graphql.Operation(document: documentNodeQueryreverseGeocode),
//           variables: variables.toJson(),
//         ),
//         data: data.toJson(),
//         broadcast: broadcast,
//       );
//
//   Query$reverseGeocode? readQuery$reverseGeocode({
//     required Variables$Query$reverseGeocode variables,
//     bool optimistic = true,
//   }) {
//     final result = this.readQuery(
//       graphql.Request(
//         operation: graphql.Operation(document: documentNodeQueryreverseGeocode),
//         variables: variables.toJson(),
//       ),
//       optimistic: optimistic,
//     );
//     return result == null ? null : Query$reverseGeocode.fromJson(result);
//   }
// }
//
// graphql_flutter.QueryHookResult<Query$reverseGeocode> useQuery$reverseGeocode(
//         Options$Query$reverseGeocode options) =>
//     graphql_flutter.useQuery(options);
//
// graphql.ObservableQuery<Query$reverseGeocode> useWatchQuery$reverseGeocode(
//         WatchOptions$Query$reverseGeocode options) =>
//     graphql_flutter.useWatchQuery(options);
//
// class Query$reverseGeocode$Widget
//     extends graphql_flutter.Query<Query$reverseGeocode> {
//   Query$reverseGeocode$Widget({
//     widgets.Key? key,
//     required Options$Query$reverseGeocode options,
//     required graphql_flutter.QueryBuilder<Query$reverseGeocode> builder,
//   }) : super(
//           key: key,
//           options: options,
//           builder: builder,
//         );
// }
//
// class Query$reverseGeocode$reverseGeocode {
//   Query$reverseGeocode$reverseGeocode({
//     required this.point,
//     this.title,
//     required this.address,
//   });
//
//   factory Query$reverseGeocode$reverseGeocode.fromJson(
//       Map<String, dynamic> json) {
//     final l$point = json['point'];
//     final l$title = json['title'];
//     final l$address = json['address'];
//     return Query$reverseGeocode$reverseGeocode(
//       point: Query$reverseGeocode$reverseGeocode$point.fromJson(
//           (l$point as Map<String, dynamic>)),
//       title: (l$title as String?),
//       address: (l$address as String),
//     );
//   }
//
//   final Query$reverseGeocode$reverseGeocode$point point;
//
//   final String? title;
//
//   final String address;
//
//   Map<String, dynamic> toJson() {
//     final _resultData = <String, dynamic>{};
//     final l$point = point;
//     _resultData['point'] = l$point.toJson();
//     final l$title = title;
//     _resultData['title'] = l$title;
//     final l$address = address;
//     _resultData['address'] = l$address;
//     return _resultData;
//   }
//
//   @override
//   int get hashCode {
//     final l$point = point;
//     final l$title = title;
//     final l$address = address;
//     return Object.hashAll([
//       l$point,
//       l$title,
//       l$address,
//     ]);
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Query$reverseGeocode$reverseGeocode) ||
//         runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$point = point;
//     final lOther$point = other.point;
//     if (l$point != lOther$point) {
//       return false;
//     }
//     final l$title = title;
//     final lOther$title = other.title;
//     if (l$title != lOther$title) {
//       return false;
//     }
//     final l$address = address;
//     final lOther$address = other.address;
//     if (l$address != lOther$address) {
//       return false;
//     }
//     return true;
//   }
// }
//
// extension UtilityExtension$Query$reverseGeocode$reverseGeocode
//     on Query$reverseGeocode$reverseGeocode {
//   CopyWith$Query$reverseGeocode$reverseGeocode<
//           Query$reverseGeocode$reverseGeocode>
//       get copyWith => CopyWith$Query$reverseGeocode$reverseGeocode(
//             this,
//             (i) => i,
//           );
// }
//
// abstract class CopyWith$Query$reverseGeocode$reverseGeocode<TRes> {
//   factory CopyWith$Query$reverseGeocode$reverseGeocode(
//     Query$reverseGeocode$reverseGeocode instance,
//     TRes Function(Query$reverseGeocode$reverseGeocode) then,
//   ) = _CopyWithImpl$Query$reverseGeocode$reverseGeocode;
//
//   factory CopyWith$Query$reverseGeocode$reverseGeocode.stub(TRes res) =
//       _CopyWithStubImpl$Query$reverseGeocode$reverseGeocode;
//
//   TRes call({
//     Query$reverseGeocode$reverseGeocode$point? point,
//     String? title,
//     String? address,
//   });
//
//   CopyWith$Query$reverseGeocode$reverseGeocode$point<TRes> get point;
// }
//
// class _CopyWithImpl$Query$reverseGeocode$reverseGeocode<TRes>
//     implements CopyWith$Query$reverseGeocode$reverseGeocode<TRes> {
//   _CopyWithImpl$Query$reverseGeocode$reverseGeocode(
//     this._instance,
//     this._then,
//   );
//
//   final Query$reverseGeocode$reverseGeocode _instance;
//
//   final TRes Function(Query$reverseGeocode$reverseGeocode) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({
//     Object? point = _undefined,
//     Object? title = _undefined,
//     Object? address = _undefined,
//   }) =>
//       _then(Query$reverseGeocode$reverseGeocode(
//         point: point == _undefined || point == null
//             ? _instance.point
//             : (point as Query$reverseGeocode$reverseGeocode$point),
//         title: title == _undefined ? _instance.title : (title as String?),
//         address: address == _undefined || address == null
//             ? _instance.address
//             : (address as String),
//       ));
//
//   CopyWith$Query$reverseGeocode$reverseGeocode$point<TRes> get point {
//     final local$point = _instance.point;
//     return CopyWith$Query$reverseGeocode$reverseGeocode$point(
//         local$point, (e) => call(point: e));
//   }
// }
//
// class _CopyWithStubImpl$Query$reverseGeocode$reverseGeocode<TRes>
//     implements CopyWith$Query$reverseGeocode$reverseGeocode<TRes> {
//   _CopyWithStubImpl$Query$reverseGeocode$reverseGeocode(this._res);
//
//   TRes _res;
//
//   call({
//     Query$reverseGeocode$reverseGeocode$point? point,
//     String? title,
//     String? address,
//   }) =>
//       _res;
//
//   CopyWith$Query$reverseGeocode$reverseGeocode$point<TRes> get point =>
//       CopyWith$Query$reverseGeocode$reverseGeocode$point.stub(_res);
// }
//
// class Query$reverseGeocode$reverseGeocode$point implements Fragment$Point {
//   Query$reverseGeocode$reverseGeocode$point({
//     required this.lat,
//     required this.lng,
//   });
//
//   factory Query$reverseGeocode$reverseGeocode$point.fromJson(
//       Map<String, dynamic> json) {
//     final l$lat = json['lat'];
//     final l$lng = json['lng'];
//     return Query$reverseGeocode$reverseGeocode$point(
//       lat: (l$lat as num).toDouble(),
//       lng: (l$lng as num).toDouble(),
//     );
//   }
//
//   final double lat;
//
//   final double lng;
//
//   Map<String, dynamic> toJson() {
//     final _resultData = <String, dynamic>{};
//     final l$lat = lat;
//     _resultData['lat'] = l$lat;
//     final l$lng = lng;
//     _resultData['lng'] = l$lng;
//     return _resultData;
//   }
//
//   @override
//   int get hashCode {
//     final l$lat = lat;
//     final l$lng = lng;
//     return Object.hashAll([
//       l$lat,
//       l$lng,
//     ]);
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) {
//       return true;
//     }
//     if (!(other is Query$reverseGeocode$reverseGeocode$point) ||
//         runtimeType != other.runtimeType) {
//       return false;
//     }
//     final l$lat = lat;
//     final lOther$lat = other.lat;
//     if (l$lat != lOther$lat) {
//       return false;
//     }
//     final l$lng = lng;
//     final lOther$lng = other.lng;
//     if (l$lng != lOther$lng) {
//       return false;
//     }
//     return true;
//   }
// }
//
// extension UtilityExtension$Query$reverseGeocode$reverseGeocode$point
//     on Query$reverseGeocode$reverseGeocode$point {
//   CopyWith$Query$reverseGeocode$reverseGeocode$point<
//           Query$reverseGeocode$reverseGeocode$point>
//       get copyWith => CopyWith$Query$reverseGeocode$reverseGeocode$point(
//             this,
//             (i) => i,
//           );
// }
//
// abstract class CopyWith$Query$reverseGeocode$reverseGeocode$point<TRes> {
//   factory CopyWith$Query$reverseGeocode$reverseGeocode$point(
//     Query$reverseGeocode$reverseGeocode$point instance,
//     TRes Function(Query$reverseGeocode$reverseGeocode$point) then,
//   ) = _CopyWithImpl$Query$reverseGeocode$reverseGeocode$point;
//
//   factory CopyWith$Query$reverseGeocode$reverseGeocode$point.stub(TRes res) =
//       _CopyWithStubImpl$Query$reverseGeocode$reverseGeocode$point;
//
//   TRes call({
//     double? lat,
//     double? lng,
//   });
// }
//
// class _CopyWithImpl$Query$reverseGeocode$reverseGeocode$point<TRes>
//     implements CopyWith$Query$reverseGeocode$reverseGeocode$point<TRes> {
//   _CopyWithImpl$Query$reverseGeocode$reverseGeocode$point(
//     this._instance,
//     this._then,
//   );
//
//   final Query$reverseGeocode$reverseGeocode$point _instance;
//
//   final TRes Function(Query$reverseGeocode$reverseGeocode$point) _then;
//
//   static const _undefined = <dynamic, dynamic>{};
//
//   TRes call({
//     Object? lat = _undefined,
//     Object? lng = _undefined,
//   }) =>
//       _then(Query$reverseGeocode$reverseGeocode$point(
//         lat: lat == _undefined || lat == null ? _instance.lat : (lat as double),
//         lng: lng == _undefined || lng == null ? _instance.lng : (lng as double),
//       ));
// }
//
// class _CopyWithStubImpl$Query$reverseGeocode$reverseGeocode$point<TRes>
//     implements CopyWith$Query$reverseGeocode$reverseGeocode$point<TRes> {
//   _CopyWithStubImpl$Query$reverseGeocode$reverseGeocode$point(this._res);
//
//   TRes _res;
//
//   call({
//     double? lat,
//     double? lng,
//   }) =>
//       _res;
// }
