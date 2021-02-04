import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/list/bloc/event.dart';
import 'package:flutter_onya_list/list/bloc/state.dart';
import 'package:flutter_onya_list/list/data.dart';
import 'package:flutter_onya_list/models/filter_trade.dart';
import 'package:flutter_onya_list/models/filter_trade_wit_selection.dart';

class ListBloc extends Bloc<OnyListEvent, ListState> {

  List<FilterTradeWithSelection> dataOfTradesAndSelection = List<FilterTradeWithSelection>();



  ListBloc() : super(InitLoadingState());

  @override
  Stream<ListState> mapEventToState(OnyListEvent event) async* {


    if (event is InitEvent) {
      dataOfTradesAndSelection = List<FilterTradeWithSelection>();

      var dataOfTrades = DataTemp.data;

      for (int i = 0; i < dataOfTrades.length; i++)
        dataOfTradesAndSelection
            .add(  FilterTradeWithSelection(trade: dataOfTrades[i],id: i,
          choice: event.selectionFilterTrades.where((FilterTrade element) => element.id == i).isNotEmpty
        ));


      yield NormalState(dataOfTradesAndSelection);
    }


    if (event is SelectionEvent) {
      dataOfTradesAndSelection[event.numberOfTrade].choice =
      !dataOfTradesAndSelection[event.numberOfTrade].choice;
      yield NormalState(dataOfTradesAndSelection);
    }


    if(event is FilterEvent){
      List<FilterTradeWithSelection> filteredDataTradeAndSelection = List<FilterTradeWithSelection>();

      dataOfTradesAndSelection.forEach((element) {
        if (element.trade.contains(event.request))
          filteredDataTradeAndSelection.add(element);
      });

      yield NormalState(filteredDataTradeAndSelection);
    }
  }

}





