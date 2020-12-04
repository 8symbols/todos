import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:todos/data/dtos/flickr_error_response_dto.dart';
import 'package:todos/data/dtos/flickr_page_dto.dart';
import 'package:todos/data/dtos/flickr_page_response_dto.dart';
import 'package:todos/data/dtos/flickr_photo_dto.dart';
import 'package:todos/data/models/flickr_response_status.dart';
import 'package:todos/data/network/flickr_client.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('FlickrClient', () {
    group('получает', () {
      const flickrPhoto = FlickrPhotoDto(
        title: '',
        id: '',
        farm: 0,
        owner: '',
        secret: '',
        server: '',
        isFriend: false,
        isFamily: false,
        isPublic: false,
      );

      const flickrPage = FlickrPageDto(
        page: 1,
        pages: 1,
        total: 0,
        perPage: 1,
        photos: [flickrPhoto],
      );

      const flickrResponse = FlickrPageResponseDto(
        stat: FlickrResponseStatus.ok,
        photos: flickrPage,
      );

      final httpClient = MockHttpClient();
      final httpResponse = http.Response(
        jsonEncode(flickrResponse.toJson()),
        HttpStatus.ok,
      );
      when(httpClient.get(any)).thenAnswer((_) async => httpResponse);

      final flickrClient = FlickrClient(httpClient);

      test('недавние посты', () async {
        final page = await flickrClient.getRecentPhotos(1, 1);
        expect(page.photos.length, flickrPage.photos.length);
      });

      test('посты по запросу', () async {
        final page = await flickrClient.getSearchPhotos(1, 1, '');
        expect(page.photos.length, flickrPage.photos.length);
      });
    });

    group('выкидывает ошибку', () {
      test('при неполадках с сетью', () async {
        final httpClient = MockHttpClient();
        when(httpClient.get(any)).thenThrow(SocketException(''));

        final flickrClient = FlickrClient(httpClient);
        expect(
          () async => await flickrClient.getRecentPhotos(1, 1),
          throwsA(isA<SocketException>()),
        );
        expect(
          () async => await flickrClient.getSearchPhotos(1, 1, ''),
          throwsA(isA<SocketException>()),
        );
      });

      test('при получении ошибки от Flickr', () async {
        const flickrResponse = FlickrErrorResponseDto(
          stat: FlickrResponseStatus.fail,
          code: 1,
          message: '',
        );
        final httpClient = MockHttpClient();
        final httpResponse = http.Response(
          jsonEncode(flickrResponse.toJson()),
          HttpStatus.ok,
        );
        when(httpClient.get(any)).thenAnswer((_) async => httpResponse);

        final flickrClient = FlickrClient(httpClient);
        expect(
          () async => await flickrClient.getRecentPhotos(1, 1),
          throwsA(isA<Exception>()),
        );
        expect(
          () async => await flickrClient.getSearchPhotos(1, 1, ''),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
