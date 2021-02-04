
import 'package:flutter_onya_list/models/filter_trade_wit_selection.dart';

abstract class ListState {}

class InitLoadingState extends ListState {}

class NormalState extends ListState {
  NormalState(this.dataOfTradesAndSelection);
  List<FilterTradeWithSelection> dataOfTradesAndSelection;
}

class ErrorState extends ListState {}