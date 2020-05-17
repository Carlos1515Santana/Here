class OcorrenciaAgrupadoDTO
{
  String descricao;
  int valor_agrupado;
  List<OcorrenciaAgrupadoDTO> OcorrenciasAgrupadas = new List();

  OcorrenciaAgrupadoDTO(this.OcorrenciasAgrupadas);

  OcorrenciaAgrupadoDTO.fromjson(Map<String, dynamic> json){
    descricao      =  json['descricao'    ];
    valor_agrupado =  json['valorAgrupado'];
  }
}