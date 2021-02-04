import 'package:flutter_onya_list/models/filter_trade.dart';

abstract class OnyListEvent {}

class InitEvent extends OnyListEvent {
  List<FilterTrade> selectionFilterTrades;

  InitEvent(this.selectionFilterTrades);
}

class FilterEvent extends OnyListEvent {
  FilterEvent(this.request);
  String request;
}

class SelectionEvent extends OnyListEvent {
  SelectionEvent(this.numberOfTrade);

  int numberOfTrade;
}
