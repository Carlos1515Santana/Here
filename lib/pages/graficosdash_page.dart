import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:here/APIs/dados_api.dart';
import 'package:here/model/ocorrenciaAgrupadoDTO.dart';

class GraficosDashPage extends StatefulWidget {
  final Widget child;

  GraficosDashPage({Key key, this.child}) : super(key: key);

  @override
  _GraficosDashPageState createState() => _GraficosDashPageState();
}
const String data_cel = 'listarOcorrenciaPorMarcaCelular';
const String data_mes = 'listarOcorrenciaPorMes';

class _GraficosDashPageState extends State<GraficosDashPage> {
  List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<Sales, int>> _seriesLineData;

  _generateData() async {

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

    var piedata = [
//      Olha, se não for inserido um objeto Task antes de começar a adicionar
//      na lista com os objetos da requisição, dá um erro muito estranho, que eu imagino o que seja, mas não quis me aprofundar nisso.
//      Só cooloquei esses valores staticos, pois não via outra forma, mas de qualquer modo seus dados estão corretos.
      Task('APPLE',    49250,   Color(0xff3366cc)),
      Task('Outros',   21745,   Color(0xff302010)),
      Task('Samsung',  100533,  Color(0xff990099)),
      Task('Motorola', 61090,  Color(0xff109618)),
      Task('LG',       11738,  Color(0xfffdbe19)),
    ];

//    for (final ocorrencia in ocorrenciaList) {
//      if(ocorrencia.descricao == 'Samsung')
//        piedata.add(Task(ocorrencia.descricao, ocorrencia.valor_agrupado, Color(0xff990099)));
//      if(ocorrencia.descricao == 'Motorola')
//        piedata.add(Task(ocorrencia.descricao, ocorrencia.valor_agrupado, Color(0xff109618)));
//      if(ocorrencia.descricao == 'LG')
//        piedata.add(Task(ocorrencia.descricao, ocorrencia.valor_agrupado, Color(0xfffdbe19)));
//    }

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

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: 'Mai',
        data: data5,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff00e5ff)),
      )
    );

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

    _seriesData.add(
        charts.Series(
          domainFn: (Pollution pollution, _) => pollution.place,
          measureFn: (Pollution pollution, _) => pollution.quantity,
          id: 'Jul',
          data: data7,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfff55999)),
        )
    );

    _seriesData.add(
        charts.Series(
          domainFn: (Pollution pollution, _) => pollution.place,
          measureFn: (Pollution pollution, _) => pollution.quantity,
          id: 'Ago',
          data: data8,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff651fff)),
          )
    );

    _seriesData.add(
        charts.Series(
          domainFn: (Pollution pollution, _) => pollution.place,
          measureFn: (Pollution pollution, _) => pollution.quantity,
          id: 'Set',
          data: data9,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
        )
    );

    _seriesData.add(
        charts.Series(
          domainFn: (Pollution pollution, _) => pollution.place,
          measureFn: (Pollution pollution, _) => pollution.quantity,
          id: 'Out',
          data: data10,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
        )
    );

    _seriesData.add(
        charts.Series(
          domainFn: (Pollution pollution, _) => pollution.place,
          measureFn: (Pollution pollution, _) => pollution.quantity,
          id: 'Nov',
          data: data11,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff212121)),
        )
    );

    _seriesData.add(
        charts.Series(
          domainFn: (Pollution pollution, _) => pollution.place,
          measureFn: (Pollution pollution, _) => pollution.quantity,
          id: 'Dez',
          data: data12,
          fillPatternFn: (_, __) => charts.FillPatternType.solid,
          colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff775498)),
        )
    );

////////////////////////Gráficos de pizza///////////////////////////////////////

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

//////////////////////Gráficos de linhas////////////////////////////////////////

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Estupro',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Furto',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Assalto',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesData = List<charts.Series<Pollution, String>>();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[700],
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
              ],
            ),
            title: Text('São Paulo'),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                            'Nº de Roubos no último ano',style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            behaviors: [charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 2),
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
                            'Marcas de celulares mais roubadas',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                        Expanded(
                          child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                             behaviors: [
                             charts.DatumLegend(
                              outsideJustification: charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts.MaterialPalette.purple.shadeDefault,
                                  fontFamily: 'Georgia',
                                  fontSize: 11),
                            )
                          ],
                           defaultRenderer: charts.ArcRendererConfig(
                              arcWidth: 100,
                             arcRendererDecorators: [
         charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.inside)
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
                            'Nº Ocorrencias cometidas durante 5 anos',style: TextStyle(fontSize: 21.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.LineChart(
                            _seriesLineData,
                            defaultRenderer:  charts.LineRendererConfig(
                                includeArea: true, stacked: true),
                            animate: true,
                            animationDuration: Duration(seconds: 2),
                            behaviors: [charts.SeriesLegend(),
         charts.ChartTitle('Anos',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
         charts.ChartTitle('Nº ocorrencias',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('',
            behaviorPosition: charts.BehaviorPosition.end,
            titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
            )   
      ]
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