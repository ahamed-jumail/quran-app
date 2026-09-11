import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart';
import 'package:mime/mime.dart';
import 'package:xml2json/xml2json.dart';

import '../../helpers/typedefs.dart';
import '../helpers/presigned_model/presigned_model.dart';
import './custom_exception.dart';
import './dio_service.dart';
import 'api_endpoint.dart';
import 'response_model.dart';

class ApiService {
  ApiService(DioService dioService, DioService dioServiceWB) {
    _dioService = dioService;
    _dioServiceWB = dioServiceWB;
  }
  late final DioService _dioService;
  late final DioService _dioServiceWB;

  Future<T> get<T>({
    required String endpoint,
    JSON? queryParams,
    CancelToken? cancelToken,
    CachePolicy? cachePolicy,
    bool isMockurl = false,
    int? cacheAgeDays,
    Map<String, Object?>? headers,
    bool requiresAuthToken = false,
    required T Function(JSON response) converter,
  }) async {
    JSON body;
    try {
      final ResponseModel<JSON> data = await _dioService.get<JSON>(
        endpoint: endpoint,
        queryParams: queryParams,
        headers: headers,
        isMockurl: isMockurl,
        cacheOptions: _dioService.globalCacheOptions?.copyWith(
          policy: cachePolicy,
          maxStale: cacheAgeDays != null
              ? Nullable(Duration(days: cacheAgeDays))
              : null,
        ),
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
        cancelToken: cancelToken,
      );

      body = data.body;
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return converter(body);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  Future<T> post<T>({
    required String endpoint,
    required JSON data,
    JSON? queryParams,
    CancelToken? cancelToken,
    bool isMockurl = false,
    Map<String, Object?>? headers,
    bool requiresAuthToken = false,
    required T Function(ResponseModel<JSON> response) converter,
  }) async {
    ResponseModel<JSON> response;

    try {
      response = await _dioService.post<JSON>(
        endpoint: endpoint,
        data: data,
        isMockurl: isMockurl,
        headers: headers,
        queryParams: queryParams,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
        cancelToken: cancelToken,
      );
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return converter(response);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  Future<T> postMultipart<T>({
    required String endpoint,
    required FormData data,
    JSON? queryParams,
    CancelToken? cancelToken,
    bool isMockurl = false,
    Map<String, Object?>? headers,
    bool requiresAuthToken = false,
    required T Function(ResponseModel<JSON> response) converter,
  }) async {
    Response response;

    try {
      response = await _dioService.postMultipart<JSON>(
        endpoint: endpoint,
        data: data,
        isMockurl: isMockurl,
        headers: headers,
        queryParams: queryParams,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
        cancelToken: cancelToken,
      );
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return converter(ResponseModel.fromJson(response));
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  Future<T> put<T>({
    required String endpoint,
    required JSON data,
    CancelToken? cancelToken,
    Map<String, Object?>? headers,
    bool requiresAuthToken = false,
    bool isMockurl = false,
    JSON? queryParams,
    required T Function(ResponseModel<JSON> response) converter,
  }) async {
    ResponseModel<JSON> response;

    try {
      response = await _dioService.put<JSON>(
        endpoint: endpoint,
        data: data,
        headers: headers,
        isMockurl: isMockurl,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
        queryParams: queryParams,
        cancelToken: cancelToken,
      );
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return converter(response);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  Future<dynamic> uploadFiletoS3<T>({
    required File file,
    required int orgId,
    CancelToken? cancelToken,
    Map<String, Object?>? headers,
    bool requiresAuthToken = false,
    bool thumbnail = false,
    JSON? queryParams,
    T Function(ResponseModel<JSON> response)? converter,
  }) async {
    ResponseModel<JSON> response;
    ResponseModel<JSON> attachmentResponse;

    JSON? thumbnailResponse;
    final String fileNameWithoutExtension =
        file.path.split('/').last.split('.').first;

    // Get the file extension
    final String fileExtension = file.path.split('.').last;
    final ContentType type =
        getContentType('$fileNameWithoutExtension.$fileExtension');
    final String mimeType = lookupMimeType(file.path) ??
        'application/octet-stream'; // Fallback if type not found
    final int fileSize = file.lengthSync();

    try {
      {
        if (thumbnail) {
          final Uint8List imageBytes = await file.readAsBytes();

          // Decode image
          final Image? originalImage = decodeImage(imageBytes);
          // Generate thumbnail
          if (originalImage != null) {
            final Image thumbnail = copyResize(originalImage, width: 100);
            final imageInPng = encodePng(thumbnail);

            // Construct the thumbnail file name
            final String thumbnailFileName =
                '${fileNameWithoutExtension}_thumbnail.$fileExtension';
            response = await _dioService.post<JSON>(
              endpoint: ApiEndpoint.presignedEndpoint,
              headers: headers,
              data: {
                'filename': thumbnailFileName,
                'content_type': mimeType,
                'file_size': fileSize,
              },
              options: Options(
                extra: <String, Object?>{
                  'requiresAuthToken': requiresAuthToken,
                },
              ),
            );
            final PresignedModel presignedModel =
                PresignedModel.fromJson(response.body ?? {});
            final s3BucketResponse = await _dioServiceWB.postMultipart<JSON>(
                endpoint: presignedModel.data?.url ?? '',
                data: FormData.fromMap({
                  ...presignedModel.data?.urlFields?.toJson() ?? {},
                  'file': MultipartFile.fromBytes(imageInPng),
                }));
            if (s3BucketResponse.statusCode == 201) {
              final xml2json = Xml2Json();
              xml2json.parse(s3BucketResponse.data.toString());
              final jsonData = xml2json.toParker();
              final data = jsonDecode(jsonData);
              thumbnailResponse = data as JSON;
              thumbnailResponse?['fileName'] = thumbnailFileName;
              thumbnailResponse?['type'] = type.name;
              // ignore: avoid_dynamic_calls
              thumbnailResponse?['s3key'] =
                  // ignore: avoid_dynamic_calls
                  thumbnailResponse['PostResponse']['Key'];
            }
          }
        }
      }
      final String fileNameS3 =
          '$fileNameWithoutExtension${DateTime.now()}.$fileExtension';

      response = await _dioService.post<JSON>(
        endpoint: ApiEndpoint.presignedEndpoint,
        headers: {
          ...headers ?? {},
          'content_type': mimeType,
        },
        data: {
          'filename': fileNameS3,
          'content_type': mimeType,
          'file_size': fileSize,
        },
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
      );
      final PresignedModel presignedModel =
          PresignedModel.fromJson(response.body ?? {});

      final List<int> fileBytes = await file.readAsBytes();

      await _dioServiceWB.putFile<JSON>(
        endpoint: presignedModel.data?.url ?? '',
        headers: {'Content-Type': mimeType},
        data: fileBytes,
      );

      try {
        attachmentResponse = await _dioService.post<JSON>(
          endpoint: '/organisations/$orgId/attachments',
          data: <String, dynamic>{
            'attachment': <String, String?>{
              'filename': '$fileNameWithoutExtension.$fileExtension',
              'content_type': mimeType,
              'file_size': file.lengthSync().toString(),
              's3_key': fileNameS3
            }
          },
          headers: headers,
          queryParams: queryParams,
          options: Options(
            extra: <String, Object?>{
              'requiresAuthToken': requiresAuthToken,
            },
          ),
          cancelToken: cancelToken,
        );
      } on Exception catch (ex) {
        throw CustomException.fromDioException(ex);
      }
      // }
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return {
        // ignore: avoid_dynamic_calls
        'fileResponse': attachmentResponse.body?['data']['attachment'],
        'thumbnailResponse': thumbnailResponse,
      };
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  Future<T> patch<T>({
    required String endpoint,
    required JSON data,
    CancelToken? cancelToken,
    Map<String, Object?>? headers,
    bool requiresAuthToken = false,
    bool isMockurl = false,
    JSON? queryParams,
    required T Function(ResponseModel<JSON> response) converter,
  }) async {
    ResponseModel<JSON> response;

    try {
      response = await _dioService.patch<JSON>(
        endpoint: endpoint,
        data: data,
        headers: headers,
        isMockurl: isMockurl,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
        queryParams: queryParams,
        cancelToken: cancelToken,
      );
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return converter(response);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  Future<T> delete<T>({
    required String endpoint,
    JSON? data,
    CancelToken? cancelToken,
    bool requiresAuthToken = false,
    JSON? queryParams,
    bool isMockurl = false,
    Map<String, Object?>? headers,
    required T Function(ResponseModel<JSON> response) converter,
  }) async {
    ResponseModel<JSON> response;

    try {
      response = await _dioService.delete<JSON>(
        endpoint: endpoint,
        data: data,
        isMockurl: isMockurl,
        headers: headers,
        options: Options(
          extra: <String, Object?>{
            'requiresAuthToken': requiresAuthToken,
          },
        ),
        queryParams: queryParams,
        cancelToken: cancelToken,
      );
    } on Exception catch (ex) {
      throw CustomException.fromDioException(ex);
    }

    try {
      return converter(response);
    } on Exception catch (ex) {
      throw CustomException.fromParsingException(ex);
    }
  }

  void cancelRequests({CancelToken? cancelToken}) {
    _dioService.cancelRequests(cancelToken: cancelToken);
  }
}

enum ContentType { image, video, unknown, document }

ContentType getContentType(String fileName) {
  // Define mapping of file extensions to content types
  final Map<String, ContentType> extensionToType = {
    'jpg': ContentType.image,
    'jpeg': ContentType.image,
    'png': ContentType.image,
    'gif': ContentType.image,
    'webp': ContentType.image,
    'bmp': ContentType.image,
    'tiff': ContentType.image,
    'tif': ContentType.image,
    'mp4': ContentType.video,
    'mov': ContentType.video,
    'avi': ContentType.video,
    'wmv': ContentType.video,
    'flv': ContentType.video,
    'mkv': ContentType.video,
    'doc': ContentType.document,
    'docx': ContentType.document,
    'pdf': ContentType.document,
    // Add more file extensions and corresponding content types as needed
  };

  // Extract the file extension from the file name
  final String extension = fileName.split('.').last.toLowerCase();

  // Lookup the content type based on the file extension
  final ContentType? contentType = extensionToType[extension];

  // Return the content type or 'unknown' if not found
  return contentType ?? ContentType.unknown;
}
