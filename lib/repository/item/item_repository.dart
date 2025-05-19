import 'package:dio/dio.dart';
import 'package:woohakdong/model/item/item.dart';
import 'package:woohakdong/service/logger/logger.dart';

import '../../service/dio/dio_service.dart';

class ItemRepository {
  final Dio _dio = DioService().dio;

  Future<List<Item>> getItemList(
    int clubId,
    String? keyword,
    String? category,
    bool? using,
    bool? available,
    bool? overdue,
  ) async {
    try {
      logger.i('물품 목록 조회 시도');

      final Map<String, dynamic> queryParams = {};

      if (keyword != null && keyword.isNotEmpty) {
        queryParams['keyword'] = keyword;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (using != null) {
        queryParams['using'] = using;
      }
      if (available != null) {
        queryParams['available'] = available;
      }
      if (overdue != null) {
        queryParams['overdue'] = overdue;
      }

      final response = await _dio.get(
        '/clubs/$clubId/items',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.data;

        List<dynamic> itemListData = jsonData['result'] as List<dynamic>;

        return itemListData.map((json) => Item.fromJson(json as Map<String, dynamic>, true)).toList();
      }

      throw Exception();
    } catch (e) {
      logger.e('물품 목록 조회 실패', error: e);
      throw Exception();
    }
  }

  Future<Item> getItemInfo(int clubId, int itemId) async {
    try {
      logger.i('물품 상세 정보 조회 시도');

      final response = await _dio.get(
        '/clubs/$clubId/items/$itemId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = response.data;

        return Item.fromJson(jsonData, false);
      }

      throw Exception();
    } catch (e) {
      logger.e('물품 상세 정보 조회 실패', error: e);
      throw Exception();
    }
  }

  Future<int> addItem(int clubId, Item item) async {
    try {
      logger.i('물품 추가 시도');

      final response = await _dio.post(
        '/clubs/$clubId/items',
        data: item.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['itemId'];
      }

      throw Exception();
    } catch (e) {
      logger.e('물품 추가 실패', error: e);
      throw Exception();
    }
  }

  Future<int> updateItem(int clubId, int itemId, Item item) async {
    try {
      logger.i('물품 수정 시도');

      final response = await _dio.put(
        '/clubs/$clubId/items/$itemId',
        data: item.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['itemId'];
      }

      throw Exception();
    } catch (e) {
      logger.e('물품 수정 실패', error: e);
      throw Exception();
    }
  }

  Future<void> deleteItem(int clubId, int itemId) async {
    try {
      logger.i('물품 삭제 시도');

      final response = await _dio.delete(
        '/clubs/$clubId/items/$itemId',
      );

      if (response.statusCode == 200) {
        return;
      }

      throw Exception();
    } catch (e) {
      logger.e('물품 삭제 실패', error: e);
      throw Exception();
    }
  }

  Future<void> toggleItemRentAvailable(int clubId, int itemId, bool itemAvailable) async {
    try {
      logger.i('물품 대여 가능 여부 변경 시도');

      final response = await _dio.post(
        '/clubs/$clubId/items/$itemId/availability',
        data: {
          'itemAvailable': itemAvailable,
        },
      );

      if (response.statusCode == 200) {
        return;
      }

      throw Exception();
    } catch (e) {
      logger.e('물품 대여 가능 여부 변경 실패', error: e);
      throw Exception();
    }
  }
}
