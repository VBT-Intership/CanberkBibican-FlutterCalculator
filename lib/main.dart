import 'package:flutter/material.dart';
import 'models/math.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String outPut = "";
  List<double> numbers = [];
  List<String> operations = [];

  buttonPressed(String buttonText) {
    //operations '+,-,*,/' --> add array lists and clear view
    if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "X" ||
        buttonText == "/") {
      numbers.add(double.parse(outPut));
      operations.add(buttonText);
      print(numbers);
      print(operations);
      setState(() {
        outPut = "";
      });
    }
    //operations 'C' --> calculator reset func
    else if (buttonText == "C") {
      setState(() {
        resetCalculator();
      });
    }
    //operations '=' --> arrays send to calculate function
    else if (buttonText == "=") {
      if (outPut != "") {
        numbers.add(double.parse(outPut));
      } else {
        numbers.add(0); // if view empty last enry number default 0
      }
      calculate(numbers, operations);
    }
    //operations '<-' --> delete the last number in view
    else if (buttonText == "<-") {
      removeOutPutLast();
    }
    //operations '<-' --> add dot to end of the number in view
    else if (buttonText == ".") {
      setState(() {
        outPut = outPut + ".";
      });
    }
    //non operations update to view
    else {
      setState(() {
        outPut = outPut + buttonText;
      });
    }
  }

  Widget buildButton(String buttonText) {
    return new Expanded(
      child: new OutlineButton(
        padding: new EdgeInsets.all(18.0),
        child: new Text(
          buttonText,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () => {buttonPressed(buttonText)},
      ),
    );
  }

//numbers array and operations array one by one process
  void calculate(List<double> numbers, List<String> operations) {
    double firstNum, secondNum;
    for (int i = 0; i < operations.length; i++) {
      firstNum = numbers[i];
      secondNum = numbers[i + 1];
      print("firstNum : " + firstNum.toString());
      print("secondNum : " + secondNum.toString());
      Math math = new Math(firstNum, secondNum);
      switch (operations[i]) {
        case "+":
          numbers[i + 1] = math.addition();
          break;
        case "-":
          numbers[i + 1] = math.subtraction();
          break;
        case "X":
          numbers[i + 1] = math.multiplication();
          break;
        case "/":
          numbers[i + 1] = math.division();
          break;
        default:
      }
    }
    setState(() {
      outPut = numbers.last.toString();
    });
    numbers.clear();
    operations.clear();
  }

  void resetCalculator() {
    outPut = "";
    numbers.clear();
    operations.clear();
  }

  void removeOutPutLast() {
    if (outPut != "") {
      setState(() {
        if (outPut.length > 1) {
          outPut = outPut.substring(0, outPut.length - 1);
        } else {
          outPut = "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerRight,
                  padding: new EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 12.0,
                  ),
                  child: new Text(
                    outPut,
                    style: new TextStyle(
                      fontSize: 48.0,
                    ),
                  )),
              new Expanded(
                child: new Divider(),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      buildButton("7"),
                      buildButton("8"),
                      buildButton("9"),
                      buildButton("/"),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("4"),
                      buildButton("5"),
                      buildButton("6"),
                      buildButton("X"),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("1"),
                      buildButton("2"),
                      buildButton("3"),
                      buildButton("-"),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("<-"),
                      buildButton("0"),
                      buildButton("."),
                      buildButton("+"),
                    ],
                  ),
                  Row(
                    children: [
                      buildButton("C"),
                      buildButton("="),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
