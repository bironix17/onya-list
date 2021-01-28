import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/debouncer.dart';
import 'package:flutter_onya_list/list/data.dart';

class OnyaListBloc extends Bloc<OnyListEvent, OnyaListState> {
  List<TradeWithSelection> dataOfTradesAndSelection = List<TradeWithSelection>();



  OnyaListBloc() : super(InitLoadingState());

  @override
  Stream<OnyaListState> mapEventToState(OnyListEvent event) async* {
    print(event);
    if (event is InitEvent) {
      dataOfTradesAndSelection = List<TradeWithSelection>();

      var dataOfTrades = DataTemp.data;
      for (int i = 0; i < dataOfTrades.length; i++)
        dataOfTradesAndSelection
            .add(TradeWithSelection(dataOfTrades[i], false, i));

      yield LoadedState(dataOfTradesAndSelection);
    }

    if (event is SelectionEvent) {
      dataOfTradesAndSelection[event.numberOfTrade].choice =
      !dataOfTradesAndSelection[event.numberOfTrade].choice;
      yield LoadedState(dataOfTradesAndSelection);
    }

    if(event is FilterEvent){
      List<TradeWithSelection> filteredDataTradeAndSelection = List<TradeWithSelection>();

      dataOfTradesAndSelection.forEach((element) {
        if (element.trade.contains(event.request))
          filteredDataTradeAndSelection.add(element);
      });

      yield LoadedState(filteredDataTradeAndSelection);
    }
  }

}

class TradeWithSelection {
  TradeWithSelection(this.trade, this.choice, this.id);
  int id;
  String trade;
  bool choice;
}

//TODO

abstract class OnyListEvent {}

class InitEvent extends OnyListEvent {}

class FilterEvent extends OnyListEvent {
  FilterEvent(this.request);
  String request;
}

class SelectionEvent extends OnyListEvent {
  SelectionEvent(this.numberOfTrade);

  int numberOfTrade;
}

abstract class OnyaListState {}

class InitLoadingState extends OnyaListState {}

class LoadedState extends OnyaListState {
  LoadedState(this.dataOfTradesAndSelection);
  List<TradeWithSelection> dataOfTradesAndSelection;
}

class ErrorState extends OnyaListState {}
