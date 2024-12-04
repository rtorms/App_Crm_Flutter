import 'package:crm_flutter/model/Cliente.dart';
import 'package:crm_flutter/route/config.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'ClienteService.g.dart';

@RestApi(baseUrl: config.urlBase)
abstract class ClienteService {
  factory ClienteService(Dio dio, {String baseUrl}) = _ClienteService;

  @GET("/cliente/listar")
  Future<List<Cliente>> listarClientes();

  @GET("/cliente/carregar")
  Future<Cliente> findById(@Query("id") int id);

  @DELETE("/cliente/delete")
  Future<bool> delete(@Query("id") int id);

  @POST("/cliente/salvar")
  Future<Cliente> save(@Body() Cliente cliente);
}
