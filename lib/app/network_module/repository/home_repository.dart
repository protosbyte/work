import 'package:dio/dio.dart';
import 'package:whiteproject/network_module/exceptions/NetworkException.dart';
import 'package:whiteproject/network_module/http_client.dart';
import 'package:whiteproject/network_module/models/category_data.dart';
import 'package:whiteproject/network_module/models/category_list.dart';
import 'package:whiteproject/network_module/session/login_manager.dart';

class HomeRepository {
  final Dio dio = HttpClient().createDioMain();

  Future<CategoryList> categoriesList() async {
    try {
      final response = await dio.get("/rest/all/V1/categoriesList",
          queryParameters: {'rootCategoryId':2,},
          options: Options(
            headers: <String, String>{
              'Authorization': 'Bearer ' + LoginManager.shared.loginToken ?? ""
            },
            responseType: ResponseType.json,
            // followRedirects: false,
            // validateStatus: (status) {
            //   return status < 500;
            // }
          ));
      return CategoryList.fromJson(response.data);
    } catch (e) {
      throw NetworkException(e);
    }
  }
}