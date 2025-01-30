// import 'dart:io';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cec/db/his.dart';


import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrintForm(),
      
    );
  }
}
class PrintForm extends StatefulWidget {
  @override
  _PrintFormState createState() => _PrintFormState();
}

class _PrintFormState extends State<PrintForm> {


  final HistoryService _historyService = HistoryService();
  List<String> _history = [];

    @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Загрузка истории при запуске
  void _loadHistory() async {
    List<String> history = await _historyService.loadHistory();
    setState(() {
      _history = history;
    });
  }

  //АЙ полей

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _farm = TextEditingController();
  final TextEditingController _red = TextEditingController();
  final TextEditingController _cod = TextEditingController();
  static TextEditingController _date = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController usedAmountController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController AmountPriceController = TextEditingController();

  String result = "";
  String Ml = "";
  String fil = "";
  String _inputname = "";
 
  
  
  



  void calculatePrice() {
    //Количество израсходаванного
    double totalAmount = double.tryParse(totalAmountController.text) ?? 0;
    //Количество введено
    double usedAmount = double.tryParse(usedAmountController.text) ?? 0;
    //Стоимость Флакона
    double totalPrice = double.tryParse(totalPriceController.text) ?? 0;
    //Колическтов мл во флаконе
    double priceAmount = double.tryParse(AmountPriceController.text) ?? 0;

    if (totalAmount > 0 && usedAmount > 0 && totalPrice > 0 && priceAmount > 0 ) {

      
      double pricePerUnit = totalPrice / priceAmount;
      
      double usedPrice = pricePerUnit * usedAmount;

      double filPrise = totalAmount * pricePerUnit;

      setState(() {
        result = "Стоимость введенного препарата ${usedPrice.toStringAsFixed(3)}";
        Ml = "Фактическая Стоимость ${pricePerUnit.toStringAsFixed(3)}";
        fil = "Стоимость израсходованного препарата ${filPrise.toStringAsFixed(3)}";
      });

      // Сохранение данных в историю
      String historyData = """
        Пациент: ${_name.text}, Номер истории: ${_number.text}, 
        Введено: ${usedAmountController.text} мг, Израсходовано: ${totalAmountController.text} мг, 
        Стоимость: ${result}, Стоимость израсходованного: ${fil}
      """;
      _historyService.saveToHistory(historyData);
      _loadHistory(); // Обновляем список истории
    } else {
      setState(() {
        result = "Пожалуйста, введите правильные значения.";
      });
    }
  }

  // Функция для создания PDF документа и его печати
  
void _printData() async {
  final pdf = pw.Document();

  final font = await PdfGoogleFonts.openSansRegular();

  // Собираем данные в таблицу
  List<List<String>> tableData = [
    ['Название полей в МЭС', 'Значение'],
    ['Фамилия, имя, отчество пациента', _inputname],
    ['Номер истории болезни', _number.text],
    ['Противоопухольный лекарственный препарат', _farm.text],
    ['Дата введения', _date.text],
    ['Количество введено (мг)', usedAmountController.text],
    ['Количество израсходованного (мг)', totalAmountController.text],
    ['Количество мг во флаконе', AmountPriceController.text],
    ['Стоимость флакона', totalPriceController.text],
    ['Стоимость введенного препарата', result],
    ['Стоимость израсходованного препарата', fil],
    ['Фактическая стоимость', Ml],
    ['Редукция', _red.text],
    ['Код схемы лекарственной терапии', _cod.text],
    ['Расширенный идентификатор МНН(международное непатентованное наименование)', 'Заполняется автоматически программой после выбора схемы лекарственной терапии'],
  ];

  // Добавляем страницу с таблицей в PDF документ
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Table.fromTextArray(
          context: context,
          data: tableData,
          headerStyle: pw.TextStyle(fontSize: 12, font: font, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(fontSize: 10, font: font),
          border: pw.TableBorder.all(width: 0.5),
        );
      },
    ),
  );

  // Отправляем созданный PDF на печать
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

  // Отправляем созданный PDF на печать

@override 
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
  title: Text('Тверской областной клинический онкологический диспансер'),
  actions: <Widget>[
    Image.asset("assets/001.png",),
  ],
),
    body: SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.all(16.0),
      
    
      child: Column(
      children: <Widget>[
        
        
      

            SizedBox(height: 10),
            
            
            Table(
              border: TableBorder.all(width: 0.5, color: Colors.black),
              children: [
                TableRow(
                  children:[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Фамилия, имя, отчество пациента:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _name,
                        decoration: InputDecoration(hintText: 'Введите данные'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children:[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Номер истории болезни:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _number,
                        decoration: InputDecoration(hintText: 'Введите номер'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Противоопухольный препарат:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _farm,
                        decoration: InputDecoration(hintText: 'Введите название'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Дата введения:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(

                        controller: _date,
                        decoration: InputDecoration(hintText: 'ДД.ММ.ГГГГ'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Количество введено (мг):', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: usedAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Введите значение'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Количество израсходовано (мг):', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: totalAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Введите значение'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Количество мг во флаконе:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller: AmountPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Введите значение'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Стоимость флакона:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: totalPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Введите сумму '),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Редукция:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _red,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Введите значение'),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Код лекарственной терапии:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _cod,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Введите значение'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 20),

            // Кнопки
            ElevatedButton(
              onPressed: calculatePrice,
              child: Text('Рассчитать'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _inputname = _name.text;
                });
                _printData();
              },
              child: Text('Распечатать'),
            ),
            SizedBox(height: 20), 

            // Результаты расчетов
            Text(result, style: TextStyle(fontSize: 16)),
            Text(Ml, style: TextStyle(fontSize: 16)),
            Text(fil, style: TextStyle(fontSize: 16)),


            // SizedBox(height: 5),
            // Text('History:'),
            // Expanded(
            //   child: ListView.builder
            //   (
            //   itemCount: _history.length ,
            //   itemBuilder: (context, index){
            //     return ListTile(
            //       title:  Text(_history[index]),);
                
            //   }
            // ))


          ],
        ),
      ),
    )  
   );
  }
}

    
   
