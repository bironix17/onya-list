import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/list/bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';

import '../debouncer.dart';

class OnyaList extends StatelessWidget {

  Color colorOrange = Color(0xfff87330);
  Color colorGrey = Color(0xffb0b0b0);


 final _debouncer = Debouncer(500);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OnyaListBloc()..add(InitEvent()),

        child: Builder(
          builder: (context) => Scaffold(
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
                  'assets/backButton.svg',
                  color: colorOrange,
                  height: 22,
                )),
              ),


              body: SingleChildScrollView(
                child: Column(
                  children: [ _buildSearchBar(context),

                    BlocBuilder<OnyaListBloc, OnyaListState>(
                      builder: (context, state) {
                        if (state is InitLoadingState) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is LoadedState) {
                          return _buildListView(state);
                        }

                        return Center(child: Text("не предусмотренная ошибка"));
                      },
                    )

                  ],
                ),
              )),
        ));
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
                    children: [

                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 15, right: 10),
                              border: InputBorder.none,
                              hintText: "Search trades"),
                          onChanged: (request)=> _debouncer.run(() => BlocProvider.of<OnyaListBloc>(context).add(FilterEvent(request))),
                        ),
                      ),

                      IconButton(
                          icon: SvgPicture.asset(
                            "assets/loupe.svg",
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



  Container _buildListView(LoadedState state) {

    return Container(
      child: GroupedListView(
        elements: state.dataOfTradesAndSelection,
        groupBy: (TradeWithSelection element) => element.trade[0],
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


  Container _buildItem(BuildContext context, TradeWithSelection element) {

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
          onTap: () => BlocProvider.of<OnyaListBloc>(context)
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
