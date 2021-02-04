import 'package:flutter/cupertino.dart';
import 'package:flutter_onya_list/models/filter_trade.dart';

class FilterTradeWithSelection {
  int id;
  String trade;
  bool choice = false;

  FilterTradeWithSelection({ @required this.trade,@required this.choice,@required this.id});

  FilterTradeWithSelection.fromFilterTrade(FilterTrade filterTrade){
    this.id = filterTrade.id;
    this.trade = filterTrade.trade;
  }

  get filterTrade => FilterTrade(trade: this.trade, id: this.id);

}

