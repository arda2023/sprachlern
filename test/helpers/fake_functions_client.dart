import 'package:supabase_flutter/supabase_flutter.dart';

/// Stands in for the `generate-sentence` Edge Function — no network.
///
/// Answers from [translations] (German sentence → English sentence and gap
/// word) and records every German sentence it was sent, in order.
class FakeFunctionsClient implements FunctionsClient {
  FakeFunctionsClient(this.translations);

  final Map<String, ({String englishSentence, String gapWord})> translations;

  final requestedSentences = <String>[];

  /// When set, every call fails with it, like a non-2xx response.
  FunctionException? failWith;

  /// When set, returned as the response body instead of a translation.
  Object? rawResponse;

  @override
  Future<FunctionResponse> invoke(
    String functionName, {
    Map<String, String>? headers,
    Object? body,
    Iterable<MultipartFile>? files,
    Map<String, dynamic>? queryParameters,
    HttpMethod method = HttpMethod.post,
    String? region,
    Future<void>? abortSignal,
  }) async {
    if (functionName != 'generate-sentence') {
      throw ArgumentError.value(functionName, 'functionName');
    }
    final sentence =
        (body! as Map<String, dynamic>)['germanSentence'] as String;
    requestedSentences.add(sentence);

    if (failWith case final error?) throw error;
    if (rawResponse case final raw?) {
      return FunctionResponse(data: raw, status: 200);
    }

    final translation = translations[sentence];
    if (translation == null) {
      throw StateError('No fake translation for "$sentence"');
    }
    return FunctionResponse(
      data: {
        'englishSentence': translation.englishSentence,
        'gapWord': translation.gapWord,
      },
      status: 200,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
