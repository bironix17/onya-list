import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/common/debouncer.dart';
import 'package:flutter_onya_list/list/bloc/bloc.dart';
import 'package:flutter_onya_list/list/bloc/event.dart';
import 'package:flutter_onya_list/list/bloc/state.dart';
import 'package:flutter_onya_list/models/filter_trade.dart';
import 'package:flutter_onya_list/models/filter_trade_wit_selection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';


class FilterList extends StatelessWidget {

  static const Color colorOrange = Color(0xfff87330);
  static const Color colorGrey = Color(0xffb0b0b0);

  final _debouncer = Debouncer(500);

  List<FilterTrade> filterTrades;

  FilterList(filterTrades){
    this.filterTrades = filterTrades ?? [];
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ListBloc()..add(InitEvent(filterTrades)),

        child: Builder(
          builder: (context) => WillPopScope(

            onWillPop: () async => onWillPopScope(context.read<ListBloc>().state, context),

            child: Scaffold(
                appBar: AppBar(
                  title: Text("onya",
                      style: TextStyle(
                        color: colorOrange,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                  elevation: 0.0,
                  centerTitle: true,
                  backgroundColor: Color(0xfff7f7f7),
                  leading: IconButton(
                      icon: SvgPicture.asset(
                    'assets/icon/backButton.svg',
                    color: colorOrange,
                    height: 22,
                  ),
                  onPressed: ()=> onWillPopScope(context.read<ListBloc>().state, context),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [ _buildSearchBar(context),

                      BlocBuilder<ListBloc, ListState>(
                        builder: (context, state) {
                          if (state is InitLoadingState) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is NormalState) {
                            return _buildListView(state, context);
                          }

                          return Center(child: Text("не предусмотренная ошибка"));
                        },
                      )

                    ],
                  ),
                )),
          ),
        ));
  }


  void popWithSelectionTrades(
      List<FilterTradeWithSelection> trades, BuildContext context) {
    Navigator.pop(
        context,
        trades
            ?.where((element) => element.choice)
            ?.map((e) => FilterTrade(id: e.id, trade: e.trade))
            ?.toList());
  }


  bool onWillPopScope(ListState state, BuildContext context){
    if (state is NormalState) {
      popWithSelectionTrades(state.dataOfTradesAndSelection, context);
      return false;
    }
    return true;
  }


  Container _buildSearchBar(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Stack(children: [
          Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 5),
                child: Center(
                    child: Text("Select a trade",
                        style: TextStyle(
                            color: Color(0xff1e2d4c),
                            fontSize: 25,
                            fontWeight: FontWeight.bold))),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    top: 25.0, left: 20, right: 20, bottom: 15),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [ BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          offset: Offset(1, 1))
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 15, right: 10),
                                border: InputBorder.none,
                                hintText: "Search trades"),
                            onChanged: (request)=> _debouncer.run(() => BlocProvider.of<ListBloc>(context).add(FilterEvent(request))),
                          ),
                        ),


                      IconButton(
                          icon: SvgPicture.asset(
                            "assets/icon/loupe.svg",
                            color: colorGrey,
                            width: 20,
                          ),
                          onPressed: null),
                    ],
                  ),
                ),
              )
            ],
          )
        ]));
  }



  Widget _buildListView(NormalState state, BuildContext context) {

    return Container(
      child: GroupedListView(
        elements: state.dataOfTradesAndSelection,
        groupBy: (FilterTradeWithSelection element) => element.trade[0],
        itemBuilder: _buildItem,
        order: GroupedListOrder.ASC,
        groupSeparatorBuilder: _buildItemGroupHeaders,
        sort: false,
        separator: Divider(
          thickness: 1,
          height: 0,
          color: Color(0xffefefef),
        ),
        shrinkWrap: true,
      ),
    );
  }


  Container _buildItem(BuildContext context, FilterTradeWithSelection element) {

    return Container(
      child: InkWell(
        child: ListTile(
          title: Text(
            element.trade,
            overflow: TextOverflow.ellipsis,
            style: element.choice
                ? TextStyle(
                    fontSize: 16,
                    color: colorOrange,
                    fontWeight: FontWeight.bold)
                : TextStyle(fontSize: 16, color: Colors.black),
          ),

          trailing: element.choice
              ? Icon(
                  Icons.check,
                  color: colorOrange,
                  size: 20,
                )
              : null,
          onTap: () => BlocProvider.of<ListBloc>(context)
              .add(SelectionEvent(element.id)),
        ),
      ),
    );
  }


  Container _buildItemGroupHeaders(dynamic element) {

    return Container(
      color: Color(0xffe5e5ea),
      padding: EdgeInsets.only(left: 25, top: 5, bottom: 5),
      child: Text(
        element,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
