import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:here/APIs/dados_api.dart';
import 'package:here/model/ocorrenciaAgrupadoDTO.dart';

class GraficosDashPageHomicidios extends StatefulWidget {
  final Widget child;

  GraficosDashPageHomicidios({Key key, this.child}) : super(key: key);

  @override
  _GraficosDashPageState createState() => _GraficosDashPageState();
}

const String data_cel = 'listarOcorrenciaPorMarcaCelular';
const String data_mes = 'listarOcorrenciaPorMes';
const String data_vei = 'listarOcorrenciaPorMarcaCelular';

class _GraficosDashPageState extends State<GraficosDashPageHomicidios> {
  List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Pollution, String>> _seriesData02;
  List<charts.Series<Pollution, String>> _seriesDataAno;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<Task, String>> _seriesPieGenero;
  List<charts.Series<Task, String>> _seriesPieTurno;
  List<charts.Series<Pollution, String>> seriesList;
  List<charts.Series<Task, String>> _seriesPieData02;
  List<charts.Series<Sales, int>> _seriesLineData;

  _generateData() async {
    var dataBairro01 = [
      Pollution('REPUBLICA', 7159),
    ];
    var dataBairro02 = [
      Pollution('BELA VISTA', 6675),
    ];
    var dataBairro03 = [
      Pollution('CONSOLAÇÃO', 5017),
    ];
    var dataBairro04 = [
      Pollution('SE', 4108),
    ];
    var dataBairro05 = [
      Pollution('BOM RETIRO', 3569),
    ];

    var data1 = [
      Pollution('Jan', 24948),
    ];
    var data2 = [
      Pollution('Fev', 27199),
    ];
    var data3 = [
      Pollution('Mar', 31662),
    ];
    var data4 = [
      Pollution('Abr', 27306),
    ];
    var data5 = [
      Pollution('Mai', 28606),
    ];
    var data6 = [
      Pollution('Jun', 28463),
    ];
    var data7 = [
      Pollution('Jul', 26354),
    ];
    var data8 = [
      Pollution('Agos', 26629),
    ];
    var data9 = [
      Pollution('Set', 25800),
    ];
    var data10 = [
      Pollution('Out', 27833),
    ];
    var data11 = [
      Pollution('Nov', 26223),
    ];
    var data12 = [
      Pollution('Dez', 25556),
    ];

//    final List<OcorrenciaAgrupadoDTO> ocorrenciaList = await Dados_api.getOcorrenciaAgrupada(data_cel);

    var piedataGenero = [
      Task('Mulher', 3007, Color(0xff3366cc)),
      Task('Homem', 242, Color(0xff302010))
    ];

    var piedataTruno = [
      Task('Manhã', 801, Color(0xff3366cc)),
      Task('Madrugada', 998, Color(0xff302010)),
      Task('Tarde', 854, Color(0xfffdbe19)),
      Task('Noite', 1723, Color(0xff212ad0))
    ];

    var piedata = [
//      Olha, se não for inserido um objeto Task antes de começar a adicionar
//      na lista com os objetos da requisição, dá um erro muito estranho, que eu imagino o que seja, mas não quis me aprofundar nisso.
//      Só cooloquei esses valores staticos, pois não via outra forma, mas de qualquer modo seus dados estão corretos.
      Task('Apple', 49250, Color(0xff3366cc)),
      Task('Outros', 21745, Color(0xff302010)),
      Task('Samsung', 100533, Color(0xff990099)),
      Task('Motorola', 61090, Color(0xff109618)),
      Task('LG', 11738, Color(0xfffdbe19)),
    ];

//    for (final ocorrencia in ocorrenciaList) {
//      if(ocorrencia.descricao == 'Samsung')
//        piedata.add(Task(ocorrencia.descricao, ocorrencia.valor_agrupado, Color(0xff990099)));
//      if(ocorrencia.descricao == 'Motorola')
//        piedata.add(Task(ocorrencia.descricao, ocorrencia.valor_agrupado, Color(0xff109618)));
//      if(ocorrencia.descricao == 'LG')
//        piedata.add(Task(ocorrencia.descricao, ocorrencia.valor_agrupado, Color(0xfffdbe19)));
//    }

    var piedata02 = [
      Task('Ford', 12966, Color(0xff3366cc)),
      Task('Fiat', 29835, Color(0xff302010)),
      Task('Chevrolet', 27149, Color(0xff990099)),
      Task('volkswagen', 30597, Color(0xff109618)),
      Task('Honda', 37900, Color(0xfffdbe19)),
    ];

    var linesalesdata = [
      Sales(0, 45),
    ];
    var linesalesdata1 = [
      Sales(0, 35),
      Sales(1, 46),
      Sales(2, 45),
      Sales(3, 50),
      Sales(4, 51),
      Sales(5, 60),
    ];

    var linesalesdata2 = [
      Sales(0, 20),
      Sales(1, 24),
      Sales(2, 25),
      Sales(3, 40),
      Sales(4, 45),
      Sales(5, 60),
    ];

////////////////////////Gráficos de barra///////////////////////////////////////

    seriesList.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '>60',
        data: [Pollution('>A60', 84)],
        labelAccessorFn: (Pollution pollution, _) =>
        '${pollution.quantity.toString()}',
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    seriesList.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '50 - 60',
        data: [Pollution('50 - 60', 93)],
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        labelAccessorFn: (Pollution pollution, _) =>
        '${pollution.quantity.toString()}',
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    seriesList.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '40 - 50',
        data: [Pollution('40 - 50', 299)],
        labelAccessorFn: (Pollution pollution, _) =>
        '${pollution.quantity.toString()}',
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff76ff03)),
      ),
    );

    seriesList.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '30 - 40',
        data: [Pollution('30 - 40', 495)],
        labelAccessorFn: (Pollution pollution, _) =>
        '${pollution.quantity.toString()}',
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfffdbe19)),
      ),
    );

    seriesList.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '18 - 30',
        data: [Pollution('18- 30', 838)],
        labelAccessorFn: (Pollution pollution, _) =>
        '${pollution.quantity.toString()}',
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff00e5ff)),
      ),
    );

    seriesList.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: 'Menores',
        data: [Pollution('Menores', 250)],
        labelAccessorFn: (Pollution pollution, _) =>
        '${pollution.quantity.toString()}',
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfffff900)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: 'Jan',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: 'Fev',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: 'Mar',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff76ff03)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: 'Abr',
        data: data4,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfffdbe19)),
      ),
    );

    _seriesData.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'Mai',
      data: data5,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff00e5ff)),
    ));

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: 'Jun',
        data: data6,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfffff900)),
      ),
    );

    _seriesData.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'Jul',
      data: data7,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfff55999)),
    ));

    _seriesData.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'Ago',
      data: data8,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff651fff)),
    ));

    _seriesData.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'Set',
      data: data9,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
    ));

    _seriesData.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'Out',
      data: data10,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
    ));

    _seriesData.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'Nov',
      data: data11,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff212121)),
    ));

    _seriesData.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'Dez',
      data: data12,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
    ));
////////////////////////Gráfico de Bairros//////////////////////////////////////

    _seriesDataAno.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'GRAJ',
      data: [Pollution('GRAJAU', 183)],
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff212121)),
    ));

    _seriesDataAno.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'JAR',
      data: [Pollution('JARDIM ANGELA', 158)],
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfff55999)),
    ));

    _seriesDataAno.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'IGU',
      data: [Pollution('IGUATEMI', 144)],
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfffff900)),
    ));

    _seriesDataAno.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'CAP',
      data: [Pollution('CAPÃO REDONDO', 140)],
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
    ));

    _seriesDataAno.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'SAC',
      data: [Pollution('SACOMÃ', 138)],
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff00e5ff)),
    ));

    _seriesData02.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'REP',
      data: dataBairro01,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff212121)),
    ));

    _seriesData02.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'BEL',
      data: dataBairro02,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfff55999)),
    ));

    _seriesData02.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'CON',
      data: dataBairro03,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfffff900)),
    ));

    _seriesData02.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'SE',
      data: dataBairro04,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
    ));

    _seriesData02.add(charts.Series(
      domainFn: (Pollution pollution, _) => pollution.place,
      measureFn: (Pollution pollution, _) => pollution.quantity,
      id: 'BOM',
      data: dataBairro05,
      fillPatternFn: (_, __) => charts.FillPatternType.solid,
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff00e5ff)),
    ));

////////////////////////Gráficos de pizza///////////////////////////////////////

    _seriesPieTurno.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Genero',
        data: piedataTruno,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );

    _seriesPieGenero.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Genero',
        data: piedataGenero,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );

    _seriesPieData02.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata02,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<Pollution, String>>();
    seriesList = List<charts.Series<Pollution, String>>();
    _seriesData02 = List<charts.Series<Pollution, String>>();
    _seriesDataAno = List<charts.Series<Pollution, String>>();
    _seriesPieGenero = List<charts.Series<Task, String>>();
    _seriesPieTurno = List<charts.Series<Task, String>>();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesPieData02 = List<charts.Series<Task, String>>();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0XFF3F51b5),
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
               ],
            ),
            title: Text('São Paulo'),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Bairros com mais homicídios',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _seriesDataAno,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            behaviors: [charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 2),
                            domainAxis: charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Analise por Turno',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart(_seriesPieTurno,
                              animate: true,
                              animationDuration: Duration(seconds: 2),
                              behaviors: [
                                charts.DatumLegend(
                                  outsideJustification:
                                  charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: true,
                                  desiredMaxRows: 2,
                                  cellPadding:
                                  EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts
                                          .MaterialPalette.purple.shadeDefault,
                                      fontFamily: 'Georgia',
                                      fontSize: 11),
                                )
                              ],
                              defaultRenderer: charts.ArcRendererConfig(
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    charts.ArcLabelDecorator(
                                        labelPosition:
                                        charts.ArcLabelPosition.inside)
                                  ])),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Número de homicídios por gênero',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart(_seriesPieGenero,
                              animate: true,
                              animationDuration: Duration(seconds: 2),
                              behaviors: [
                                charts.DatumLegend(
                                  outsideJustification:
                                  charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: true,
                                  desiredMaxRows: 2,
                                  cellPadding:
                                  EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts
                                          .MaterialPalette.purple.shadeDefault,
                                      fontFamily: 'Georgia',
                                      fontSize: 11),
                                )
                              ],
                              defaultRenderer: charts.ArcRendererConfig(
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    charts.ArcLabelDecorator(
                                        labelPosition:
                                        charts.ArcLabelPosition.inside)
                                  ])),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Número de homicídios por faixa etária',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.BarChart(
                            seriesList, //_seriesData,
                            animate: true,
                            vertical: false,
                            //barGroupingType: charts.BarGroupingType.grouped,
                            behaviors: [
                              charts.SeriesLegend(
                                position: charts.BehaviorPosition.top,
                                outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 2,
                                cellPadding:
                                EdgeInsets.only(right: 4.0, bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                  //color: charts.Color(r: 127, g: 63, b: 191),
                                    fontFamily: 'Georgia',
                                    fontSize: 14),
                              )
                            ],
                            animationDuration: Duration(seconds: 2),

                            barRendererDecorator: new charts.BarLabelDecorator(
                              labelPosition: charts.BarLabelPosition.outside,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: avoid_types_as_parameter_names

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class Pollution {
  String place;
//  int year;
  int quantity;

  Pollution(this.place, this.quantity);
}

class Task {
  String task;
  int taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}
