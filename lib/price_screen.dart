import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem> dropdownMenuItems = currenciesList.map((currency) {
      return DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
    }).toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownMenuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = currenciesList.map((currency) {
      return Text(currency);
    }).toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (value) {},
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...cryptoList.map((cryptoCurrency) {
            return CryptoExchangeRateCard(
              cryptoCurrency: cryptoCurrency,
              currency: selectedCurrency,
            );
          }).toList(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoExchangeRateCard extends StatefulWidget {
  String cryptoCurrency;
  String currency;

  CryptoExchangeRateCard({this.cryptoCurrency, this.currency});

  @override
  _CryptoExchangeRateCardState createState() => _CryptoExchangeRateCardState();
}

class _CryptoExchangeRateCardState extends State<CryptoExchangeRateCard> {
  String exchangeRate = '?';
  CoinData coinData = CoinData();

  void getCoinData() async {
    try {
      String rate =
          await coinData.getCoinData(widget.cryptoCurrency, widget.currency);
      setState(() {
        exchangeRate = rate;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCoinData();
  }

  @override
  void didUpdateWidget(CryptoExchangeRateCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getCoinData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 ${widget.cryptoCurrency} = $exchangeRate ${widget.currency}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
