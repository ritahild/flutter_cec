import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  //АЙ полей

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _farm = TextEditingController();
  static TextEditingController _date = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController usedAmountController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController AmountPriceController = TextEditingController();

  String result = "";
  String Ml = "";
  String fil = "";
  String _inputname = "";
  String _inputdate = "";
  
  
  



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
        result = "Стоимость введенного лекарственного препарата ${usedPrice.toStringAsFixed(2)}";
        Ml = "Фактическая Стоимость ${pricePerUnit.toStringAsFixed(2)}";
        fil = "Стоимость израсходованного препарата ${filPrise.toStringAsFixed(2)}";
        
      });
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
    ['Параметр', 'Значение'],
    ['Фамилия, имя, отчество пациента', _inputname],
    ['Номер истории болезни', _number.text],
    ['Противоопухольный лекарственный препарат', _farm.text],
    ['Дата введения', _date.text],
    ['Количество введено (мг)', usedAmountController.text],
    ['Количество израсходованного (мг)', totalAmountController.text],
    ['Количество мл во флаконе', AmountPriceController.text],
    ['Стоимость флакона', totalPriceController.text],
    ['Стоимость введенного препарата', result],
    ['Стоимость израсходованного препарата', fil],
    ['Фактическая стоимость', Ml],
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Фамилия имя отчество пациента',
                  ),
                
                ),
                 TextFormField(
                  controller: _number,
                  decoration: const InputDecoration(
                    labelText: 'Номер истории болезней',
                  ),
                 
                ),
                TextFormField(
                  controller: _farm,
                  decoration: const InputDecoration(
                    labelText: 'Противоопухольный лекарственный препарат',
                  ),
                  onSaved: (newValue) {
                  
                  },
                ),
                TextFormField(
                  controller: _date,
                  decoration: const InputDecoration(
                    labelText: 'Дата введения',
                    hintText: 'ДД.ММ.ГГГГ',


                  ),
                ),
            TextFormField(
              controller:  usedAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                      labelText: 'Количество введено', suffixText: 'мг'),
            ),
            TextFormField(
              controller: totalAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Количество израсходаванного', suffixText: 'мг'),
            ),
            TextFormField(
              controller: AmountPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Колическтов мл во флаконе', suffixText: 'мг'),
            ),

            TextFormField(
              controller: totalPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Стоимость Флакона"),
            ),
            SizedBox(height: 10),
            Text(
              result, 
              style: TextStyle(fontSize: 9)),
            Text(
              Ml,
              style: TextStyle(fontSize: 9)),

            Text(
              
              fil,
              style: TextStyle(fontSize: 9)),
              
            TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Редукция',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Код схемы лекарственной терапии',
                  ),
                ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: calculatePrice,
              child: Text("Рассчитать"),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _inputname = _name.text;
                  
                });
                _printData();  // Вызываем функцию печати
              },
              child: Text('Распечатать'),
            ),
            
            
       
          ],
        ),
      ),
    );
  }
}

