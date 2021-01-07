import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:todos/data/constants/flickr_response_status.dart';
import 'package:todos/data/dtos/flickr_error_response_dto.dart';
import 'package:todos/data/dtos/flickr_page_dto.dart';
import 'package:todos/data/dtos/flickr_page_response_dto.dart';
import 'package:todos/data/dtos/flickr_response_dto.dart';

/// Класс для работы с API Flickr.
class FlickrClient {
  static const _authority = 'www.flickr.com';

  static const _restPath = '/services/rest/';

  static const _apiKey = 'afff4c2149acf39fd13e92b823925520';

  static const _baseParameters = {
    'api_key': _apiKey,
    'format': 'json',
    'nojsoncallback': '1',
  };

  /// Клиент для работы с http.
  final http.Client _httpClient;

  const FlickrClient(this._httpClient);

  /// Загружает страницу [page] недавних изображений размера [pageSize].
  ///
  /// Может выбрасывать исключения.
  Future<FlickrPageDto> getRecentPhotos(int page, int pageSize) async {
    final responseBody = await _getResponseBody({
      'method': 'flickr.photos.getRecent',
      'per_page': pageSize.toString(),
      'page': page.toString(),
    });

    return compute(_parsePhotos, responseBody);
  }

  /// Загружает страницу [page] размера [pageSize] по запросу [query].
  ///
  /// Может выбрасывать исключения.
  Future<FlickrPageDto> getSearchPhotos(
    int page,
    int pageSize,
    String query,
  ) async {
    final responseBody = await _getResponseBody({
      'method': 'flickr.photos.search',
      'text': query,
      'per_page': pageSize.toString(),
      'page': page.toString(),
    });

    return compute(_parsePhotos, responseBody);
  }

  Future<String> _getResponseBody(Map<String, String> parameters) async {
    final uri = Uri.https(
      _authority,
      _restPath,
      Map.from(_baseParameters)..addAll(parameters),
    );

    final response = await _httpClient.get(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Не удалось совершить запрос.');
    }

    return response.body;
  }
}

/// Парсит ответ от Flickr.
///
/// Может выбрасывать исключения.
FlickrPageDto _parsePhotos(String responseBody) {
  final responseJson = jsonDecode(
    responseBody,
    reviver: (key, value) => value is int ? value.toString() : value,
  );

  final response = FlickrResponseDto.fromJson(responseJson);

  if (response.stat == FlickrResponseStatus.fail) {
    final failedResponse = FlickrErrorResponseDto.fromJson(responseJson);
    throw Exception(
      'Некорректный запрос к Flickr (код ${failedResponse.code}): '
      '${failedResponse.message}.',
    );
  }

  return FlickrPageResponseDto.fromJson(responseJson).photos;
}
