import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController usedAmountController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController AmountPriceController = TextEditingController();


  //Настройка кодировки 
  final Uint8List fontData = File('open-sans.ttf').readAsBytesSync();
  static pw.Font ttf = pw.Font.ttf(fontData.buffer.asByteData());

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
    
     
    // Добавляем страницу с текстом в PDF документ
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child:
             pw.Text(
              _inputname,
              style: pw.TextStyle(font: ttf, fontSize: 40),
            ),
            
            
            
          ); // Вставляем введенные данные в PDF
        },
      ),
    );
    
    // Отправляем созданный PDF на печать
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

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
                  decoration: const InputDecoration(
                    labelText: 'Противоопухольный лекарственный препарат',
                  ),
                  onSaved: (newValue) {
                  
                  },
                ),
                TextFormField(
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
                  // result = _name.text;
                  // Ml = _name.text;
                });
                _printData();  // Вызываем функцию печати
              },
              child: Text('Распечатать'),
            ),
            // SizedBox(height: 10),
            // Text(
            //   'Введенные данные: $_inputData',
            //   style: TextStyle(fontSize: 10),
            // ),
            
            
          ],
        ),
      ),
    );
  }
}

