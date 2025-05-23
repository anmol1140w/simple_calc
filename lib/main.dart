import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _input = '';
  String _result = '';

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
      } else if (value == '=') {
        try {
          final expression = _input.replaceAll('×', '*').replaceAll('÷', '/');
          _result = _evaluateExpression(expression);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _input += value;
      }
    });
  }

  String _evaluateExpression(String expr) {
    // Simple expression evaluator using Dart's expression parsing (limited)
    try {
      final result = double.parse(
          (ExpressionEvaluator().evaluate(expr)).toStringAsFixed(4));
      return result.toString();
    } catch (_) {
      return 'Error';
    }
  }

  Widget _buildButton(String value, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(value),
          child: Text(value, style: TextStyle(fontSize: 24)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            padding: EdgeInsets.all(22),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_input, style: TextStyle(color: Colors.white, fontSize: 32)),
                  SizedBox(height: 10),
                  Text(_result, style: TextStyle(color: Colors.greenAccent, fontSize: 40)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('÷', color: Colors.orange)]),
              Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('×', color: Colors.orange)]),
              Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-', color: Colors.orange)]),
              Row(children: [_buildButton('C', color: Colors.red), _buildButton('0'), _buildButton('='), _buildButton('+', color: Colors.orange)]),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpressionEvaluator {
  double evaluate(String expr) {
    // Basic and unsafe evaluation using dart's Expression package could be ideal,
    // but for now use 'dart:math' features with simple parser if needed.
    // Here we assume the expression is safe and math-only.
    return _parseExpression(expr);
  }

  double _parseExpression(String expr) {
    // Very basic support: only binary ops and no parentheses
    final exp = expr.replaceAll(' ', '');
    final operators = ['+', '-', '*', '/'];
    for (var op in operators) {
      var parts = exp.split(op);
      if (parts.length == 2) {
        final a = double.tryParse(parts[0]);
        final b = double.tryParse(parts[1]);
        if (a != null && b != null) {
          switch (op) {
            case '+':
              return a + b;
            case '-':
              return a - b;
            case '*':
              return a * b;
            case '/':
              return b != 0 ? a / b : throw Exception("Divide by zero");
          }
        }
      }
    }
    throw Exception("Invalid expression");
  }
}
