import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MedicineCalculator(),
    );
  }
}

class MedicineCalculator extends StatefulWidget {
  @override
  _MedicineCalculatorState createState() => _MedicineCalculatorState();
}

class _MedicineCalculatorState extends State<MedicineCalculator> {
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController usedAmountController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();

  String result = "";
  String Ml = "";

  void calculatePrice() {
    double totalAmount = double.tryParse(totalAmountController.text) ?? 0;
    double usedAmount = double.tryParse(usedAmountController.text) ?? 0;
    double totalPrice = double.tryParse(totalPriceController.text) ?? 0;

    if (totalAmount > 0 && usedAmount > 0 && totalPrice > 0) {
      
      double pricePerUnit = totalPrice / totalAmount;
      
      double usedPrice = pricePerUnit * usedAmount;

      setState(() {
        result = "Стоимость израсходованного лекарственного препарата ${usedPrice.toStringAsFixed(2)}";
        Ml = "Фактическая Стоимость ${pricePerUnit.toString()}";
        
      });
    } else {
      setState(() {
        result = "Пожалуйста, введите правильные значения.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Калькулятор лекарства")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Фамилия имя отчество пациента',
                  ),
                
                ),
                 TextFormField(
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
              controller: totalAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                      labelText: 'Количество введено', suffixText: 'мг'),
            ),
            TextFormField(
              controller: usedAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Количество потрачено', suffixText: 'мг'),
            ),
            TextFormField(
              controller: totalPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Стоимость введенного препарата"),
            ),
            SizedBox(height: 20),
            Text(
              result, 
              style: TextStyle(fontSize: 18)
              
              ),
            Text(
              Ml
              
              
              ),
            
            
           


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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculatePrice,
              child: Text("Рассчитать"),
            ),
            // SizedBox(height: 20),
            // Text(result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
