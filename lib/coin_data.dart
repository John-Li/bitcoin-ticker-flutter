import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

const kCoinAPIKey = 'EAB7A130-716B-4A7C-93A5-EDC7C112B5CC';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(String cryptoCurrency, String currency) async {
    http.Response response = await http.get(
      'https://rest.coinapi.io/v1/exchangerate/$cryptoCurrency/$currency',
      headers: {'X-CoinAPI-Key': kCoinAPIKey},
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      double rate = jsonResponse['rate'];
      return rate.toStringAsFixed(0);
    } else {
      throw ('Request failed with status: ${response.statusCode}.');
    }
  }
}
