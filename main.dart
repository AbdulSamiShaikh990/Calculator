import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "<=") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation.length > 1) {
          equation = equation.substring(0, equation.length - 1);
          if (equation == "") {
            equation = "0";
          }
        } else {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          result = formatResult(result);
        } catch (e) {
          result = "Error";
        }
      } else {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  String formatResult(String input) {
    double value;
    try {
      value = double.parse(input);
    } catch (e) {
      return input;
    }

    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2);
    }
  }

  Widget buildButton(String buttonText, Color buttonColor, {int rowSpan = 1}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * rowSpan,
      color: buttonColor,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: buttonText == "=" ? 40.0 : 30.0, // Adjust size for "="
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('         Simple Calculator By ASS ')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("C", Colors.redAccent),
                      buildButton("<=", Colors.blueAccent),
                      buildButton("÷", Colors.blueAccent),
                    ]),
                    TableRow(children: [
                      buildButton("7", Colors.black54),
                      buildButton("8", Colors.black54),
                      buildButton("9", Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("4", Colors.black54),
                      buildButton("5", Colors.black54),
                      buildButton("6", Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton("1", Colors.black54),
                      buildButton("2", Colors.black54),
                      buildButton("3", Colors.black54),
                    ]),
                    TableRow(children: [
                      buildButton(".", Colors.black54),
                      buildButton("0", Colors.black54),
                      buildButton("0.0", Colors.black54),
                    ]),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [
                      buildButton("×", Colors.blueAccent),
                    ]),
                    TableRow(children: [
                      buildButton("-", Colors.blueAccent),
                    ]),
                    TableRow(children: [
                      buildButton("+", Colors.blueAccent),
                    ]),
                    TableRow(children: [
                      buildButton("=", Colors.redAccent, rowSpan: 2),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
