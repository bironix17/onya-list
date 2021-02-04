import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/common/enams.dart';
import 'package:flutter_onya_list/list/ui.dart';
import 'package:flutter_onya_list/models/filter_trade.dart';
import 'package:flutter_onya_list/projects_screen/bloc/bloc.dart';
import 'package:flutter_onya_list/projects_screen/bloc/event.dart';
import 'package:flutter_onya_list/projects_screen/bloc/state.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/global_values.dart';

class MyDrawer extends StatefulWidget {

  BuildContext _context;
  ProjectsState _state;
  Function _onClose;

  @override
  _MyDrawerState createState() => _MyDrawerState(_context, _state, _onClose);

  MyDrawer(this._context, this._state, this._onClose);
}

class _MyDrawerState extends State<MyDrawer> {

  BuildContext context;
  ProjectsState state;
  Function onClose;

  List<FilterTrade> filterTrades = [];

  _MyDrawerState(this.context, this.state ,this.onClose);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 65),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              "Filter projects",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: SvgPicture.asset(
                            "assets/icon/icon_close_circle.svg",
                            color: Common.colorOrange,
                          ),
                        ),
                      ],
                    ),
                  ),


                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 100 ),
                    crossFadeState: _checkButtonDisplay(state) ? CrossFadeState.showFirst : CrossFadeState.showSecond,

                    firstChild: Column(
                      children: [
                        FlatButton(
                          onPressed: (){BlocProvider.of<ProjectsBloc>(context).add(EndDrawerClearItemsEvent());},
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
                              child: Text("clear filters".toUpperCase(), style: TextStyle(color:  Common.colorOrange))),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Common.colorOrange, width: 2)),
                        ),
                      ],
                    ),

                    secondChild: Center(child: Container()),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text("SORT BY", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),

                  buildPaddingClickableText("Most recent",FiltersTypes.MostRecent,  state.filtersClicked[FiltersTypes.MostRecent], context),
                  buildPaddingClickableText("Most popular",FiltersTypes.MostPopular,  state.filtersClicked[FiltersTypes.MostPopular], context),
                  buildPaddingClickableText("Most comments",FiltersTypes.MostComments,  state.filtersClicked[FiltersTypes.MostComments], context),

                ],
              ),
            ),

            Container(height: 1, width: double.infinity, color: Colors.black12,),

            Container(
              padding: EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text("filter bY".toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  buildClickableTextWithSwitch("In your network",FiltersTypes.InYourNetwork,  state.filtersClicked[FiltersTypes.InYourNetwork], context),
                  buildClickableTextWithSwitch("In your trade", FiltersTypes.InYourTrade,  state.filtersClicked[FiltersTypes.InYourTrade], context),

                ],
              ),
            ),
            Container(height: 1, width: double.infinity, color: Colors.black12,),

            Container(
              padding: EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text("filter by trade".toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  Container(
                    height: 52,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4)
                    ),
                    child: InkWell(

                      onTap: ()async{
                        filterTrades = await Navigator.push(context, MaterialPageRoute(builder : (context)=> FilterList(filterTrades)));
                        print(filterTrades);
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select trade", style: TextStyle(color: Colors.black38),),

                          RotatedBox(child: SvgPicture.asset("assets/icon/icon_chevron_back.svg",height: 20,color: Colors.black38, ), quarterTurns : 3)

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    onClose();
    super.dispose();

  }

  Padding buildPaddingClickableText(String text, FiltersTypes filtersType, bool clicked, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 7),
      child: _buildClickableTextWithCheckIcon(text,filtersType,  clicked, context),
    );
  }



  Widget buildClickableTextWithSwitch(String text, FiltersTypes filterType, bool clicked, BuildContext context) => Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildClickableText(text, filterType, clicked, context),

          Material(
            child: Switch.adaptive(value: clicked, onChanged: (value) {
              BlocProvider.of<ProjectsBloc>(context).add(
                  EndDrawerClickItemEvent(filterType));
            }, activeColor: Common.colorOrange),
          )
        ],

      ));

  bool _checkButtonDisplay(ProjectsState state){ // проверка на необходимость показа кнопки
    bool res = false;
    state.filtersClicked.forEach((key, bool value) { res = res || value;});
    return res;
  }


  Widget _buildClickableTextWithCheckIcon(String text, FiltersTypes filterType, bool clicked, BuildContext context) =>
      InkWell(child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
            style: clicked
                ? TextStyle(fontSize: 14, color: Common.colorOrange, fontWeight: FontWeight.bold)
                : TextStyle(fontSize: 14, color: Common.colorOrange),
          ),
          Container(child: clicked ? Icon(Icons.check, color: Common.colorOrange) : null)
        ],
      ),
        onTap: () =>
            BlocProvider.of<ProjectsBloc>(context).add(
                EndDrawerClickItemEvent(filterType))
        ,);

  Widget _buildClickableText(String text, FiltersTypes filterType, bool clicked, BuildContext context) =>
      InkWell(child:
          Text(text,
            style: clicked
                ? TextStyle(fontSize: 14, color: Common.colorOrange, fontWeight: FontWeight.bold)
                : TextStyle(fontSize: 14, color: Common.colorOrange),
          ),
        onTap: () =>
            BlocProvider.of<ProjectsBloc>(context).add(
                EndDrawerClickItemEvent(filterType))
        );


}