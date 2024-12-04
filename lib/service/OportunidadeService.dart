import 'package:crm_flutter/model/Oportunidade.dart';
import 'package:crm_flutter/route/config.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'OportunidadeService.g.dart';

@RestApi(baseUrl: config.urlBase)
abstract class OportunidadeService {
  factory OportunidadeService(Dio dio, {String baseUrl}) = _OportunidadeService;

  @GET("/oportunidade/listar")
  Future<List<Oportunidade>> listarOportunidades();

  @GET("/oportunidade/carregar")
  Future<Oportunidade> findById(@Query("id") int id);

  @DELETE("/oportunidade/delete")
  Future<bool> delete(@Query("id") int id);

  @POST("/oportunidade/salvar")
  Future<Oportunidade> save(@Body() Oportunidade oportunidade);
}
