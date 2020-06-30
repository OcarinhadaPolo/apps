import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCard> {
  final TextEditingController _controladorNumberCard = TextEditingController();
  final TextEditingController _controladorValidade = TextEditingController();
  var bandeira = Image.asset('assets/card.png');
  var appBar = AppBar(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    title: Container(
      child: Column(
        children: <Widget>[
          Text('Adicionar Cartão',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );

  _mudarBandeira(String text) {
    String n1 = text.substring(0, 1);
    String n2 = text.substring(0, 4);
    String n3 = text.substring(0, 7);
    var n4;
    if (n3.contains(" ")) {
      n4 = n3.split(" ");
    } else {
      n4 = n3;
    }

    var n5 = n4.toString();
    n5 = n5.substring(0, 6);
    if (n1.contains("4")) {
      setState(() {
        bandeira = Image.asset('assets/visa.png');
      });
    }
    if (n1.contains("5")) {
      setState(() {
        bandeira = Image.asset('assets/mastercard.png');
      });
    }
    if (n2.contains("5067") || n2.contains("4576") || n2.contains("4011")) {
      setState(() {
        bandeira = Image.asset('assets/elo.png');
      });
    }
    if (n5.contains("636368") ||
        n5.contains("636369") ||
        n5.contains("636397") ||
        n5.contains("438935") ||
        n5.contains("504175") ||
        n5.contains("451416") ||
        n5.contains("506699")) {
      setState(() {
        bandeira = Image.asset('assets/elo.png');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
    var maskFormatter2 = new MaskTextInputFormatter(
        mask: '##/##', filter: {"#": RegExp(r'[0-9]')});
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueAccent),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.credit_card,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Adicionar Novo Cartão',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 60,
                        height: 60,
                        child: bandeira,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 10),
                        width: 245,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: TextField(
                          controller: _controladorNumberCard,
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatter],
                          maxLength: 19,
                          onChanged: (text) {
                            _mudarBandeira(text);
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 0, bottom: 0, top: 0, right: 0),
                            hintText: '0000 0000 0000 0000',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(left: 10),
                        width: 245,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: TextField(
                          controller: _controladorValidade,
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskFormatter2],
                          maxLength: 5,
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 0, bottom: 0, top: 0, right: 0),
                            hintText: '00/00',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
