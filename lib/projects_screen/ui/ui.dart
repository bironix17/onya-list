import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/common/app_fonts.dart';
import 'package:flutter_onya_list/common/enams.dart';
import 'package:flutter_onya_list/common/global_values.dart';
import 'package:flutter_onya_list/models/project_card.dart';
import 'package:flutter_onya_list/projects_screen/bloc/bloc.dart';
import 'package:flutter_onya_list/projects_screen/bloc/event.dart';
import 'package:flutter_onya_list/projects_screen/bloc/state.dart';
import 'package:flutter_onya_list/projects_screen/ui/card_list.dart';
import 'package:flutter_onya_list/projects_screen/ui/drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;


class ProjectsScreen extends StatefulWidget {

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin{

  bool _isBottomSheetOpened = false;

  final _imageHeight = 169.0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _scrollController;
  TabController _tabController;
  


  List<String> tabsNames = ["MY PROJECTS", "ALL PROJECTS"];
  List<String> navigationItemLabels = ["feed" ,  "projects" , "buy & sell", "profile", "discussion"];
  List<String> navigationItemIconPaths = [
    "assets/icon/icon_menubar_feed.svg",
    "assets/icon/icon_projects.svg",
    "assets/icon/icon_menubar_buy.svg",
    "assets/icon/icon_menubar_profile.svg",
    "assets/icon/icon_menubar_discussions.svg"
  ];

  int _selectedIndex = 1;


  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }


  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController =  TabController(length: tabsNames.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)=> ProjectsBloc() .. add(LoadCardsEvent()),
      child: Builder(
        builder: (context)=> BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              endDrawer: MyDrawer(context, state, ()=>BlocProvider.of<ProjectsBloc>(context).add(CloseEndDrawer())),

              appBar: buildAppBar(context, tabsNames),

              body: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: _buildHeader(_imageHeight, context),
                    )
                  ];
                },


                body: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Common.colorOrange,
                      labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      indicatorColor: Common.colorOrange,
                      unselectedLabelColor: Common.colorGrey,
                      labelStyle: AppFonts.sfUiDisplayBold.copyWith(
                        fontSize: 12,
                        letterSpacing: 0.55,
                      ),
                      tabs: tabsNames.map((name) =>
                          Container(height: 45, child: Tab(text: name,)))
                          .toList(),
                    ),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                      children: _buildBodyTabBarView(state, context),
                    ),
                    ),
                  ],
                ),
              ),

              bottomNavigationBar: _buildBottomNavigationBar(),

              floatingActionButton: Builder(
                builder : (context) => FloatingActionButton(
                  child: _isBottomSheetOpened
                      ? SvgPicture.asset( "assets/icon/icon_times_solid.svg", color: Colors.white, height: 15)
                      : SvgPicture.asset( "assets/icon/icon_add.svg", color: Colors.white),

                  backgroundColor: Common.colorOrange,

                  onPressed: (){
                    if(_isBottomSheetOpened)
                      Navigator.pop(context);

                    else
                    Scaffold.of(context)
                        .showBottomSheet(
                            (context) => _buildBottomSheet(context))
                        .closed
                        .then((value) {
                      setState(() {
                        _isBottomSheetOpened = false;
                      });
                    });

                  setState(() {
                      _isBottomSheetOpened = !_isBottomSheetOpened;
                    });

                  },
                ),
              ),
            );
          }
        ),
      ),
    );
  }



Widget _buildBottomSheet(BuildContext context)=>
  Container(
    color : Colors.white,
    width: double.infinity,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBottomSheetItem( title :"Add a post", subTitle : "Tell the masses what's on your mind", svgPath : "assets/icon/icon_menubar_feed.svg" ),
        _buildBottomSheetItem( title : "Sell something",  subTitle : "List an item in the Buy \$ Sell section", svgPath :  "assets/icon/icon_menubar_buy.svg" ),
        _buildBottomSheetItem( title : "Add a project",  subTitle : "Show off yor latest and greatest work", svgPath :  "assets/icon/icon_projects.svg" ),
      ],
    ),
  );


  Widget _buildBottomSheetItem({String title, String subTitle, String svgPath, double pictureHeight = 24}) => Container(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Common.colorOrange,
          radius: 25,
          child: SvgPicture.asset( svgPath, color: Colors.white, height: pictureHeight),
        ),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subTitle, style: TextStyle(fontSize: 14)),
      ));


  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
            items: _buildNavigationItem( navigationItemLabels, navigationItemIconPaths),
            currentIndex: _selectedIndex,
            selectedItemColor: Common.colorOrange,

            selectedFontSize: 8,
            unselectedFontSize: 8,

            selectedLabelStyle:
            AppFonts.gilroy.copyWith(letterSpacing: 0.4),
            unselectedLabelStyle:
            AppFonts.gilroy.copyWith(letterSpacing: 0.4),

            type: BottomNavigationBarType.fixed,

            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          );
  }



  Widget buildAppBar(BuildContext context, List<String> tabsNames) {

    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/icon/icon_chevron_back.svg",
            color: Common.colorOrange,
            height: 40,
          ),
        ),
        title: Center(child: SvgPicture.asset("assets/icon/logo_onya.svg")),
        backgroundColor: Common.colorDarkBlue,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "assets/icon/icon_notifications.svg",
              color: Colors.white,
              height: 24,
            ),
          )
        ],
      ),
    );
  }


  Stack _buildHeader(double imageHeight, BuildContext context) {
    return Stack(
      children: [
        Container(
            height: imageHeight + 20,
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 20),
            child: Image.asset("assets/image/header-feed.jpg",   fit: BoxFit.fitWidth)),
        Positioned(
            right: 5,
            top: 5,
            child: Padding(
              padding: const EdgeInsets.all(5),

              child: IconButton(icon : SvgPicture.asset("assets/icon/icon_filter.svg",height: 16, color: Colors.white), onPressed : _openEndDrawer,),
            )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text("Projects", style:TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 21, vertical: 2),
                margin: EdgeInsets.symmetric(horizontal: Common.horizontalPadding),
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          spreadRadius: 4,
                          offset: Offset(4, 3),
                          color: Color(0xff0000000D)
                      )
                    ]
                ),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      onChanged: (String text){BlocProvider.of<ProjectsBloc>(context).add(SearchCardsEvent(text));},
                      decoration: InputDecoration(
                          hintText: "Search projects",
                          hintStyle: TextStyle(
                            color: Common.colorGrey
                          ),
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                      ),
                    )),
                    SvgPicture.asset("assets/icon/loupe.svg", color: Common.colorGrey, height: 18,)
                  ],
                ),
              )
            ],
          ),
        )

      ],
    );
  }


  List<BottomNavigationBarItem> _buildNavigationItem(List<String> labels, List<String> iconsPaths) {
    List<BottomNavigationBarItem> items = [];

    for (int i = 0; i < labels.length; i++) {
      items.add(BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset(iconsPaths[i], height: 22, color: Common.colorGrey,),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SvgPicture.asset(iconsPaths[i], height: 22, color: Common.colorOrange,),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Text(labels[i].toUpperCase()),
          )));
    }
    return items;
  }


  List<Widget> _buildBodyTabBarView(ProjectsState state, BuildContext context) {
    return TabNames.values.map((e){

      if (state is LoadState)
        return  Center(child: CircularProgressIndicator());

      if (state is NormalState)
       return CardList(e, state.projectsCardsData[e], context, _scrollController);

      if (state is ErrorState)
        return RefreshIndicator(
          child :_buildErrorWidget(context),
            onRefresh: () async {
              BlocProvider.of<ProjectsBloc>(context).add(LoadCardsEvent());
            }
        );
    }).toList();

  }


  Widget _buildErrorWidget(BuildContext context){
    return Center(

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("No Internet connection"),
            SizedBox(height: 10,),
            TextButton(
              onPressed: () => BlocProvider.of<ProjectsBloc>(context).add(LoadCardsEvent()),
              child: Container(
                margin: EdgeInsets.all(8),
                child: Text("try again".toUpperCase(),
                    style: TextStyle(color: Colors.white)),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Common.colorOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40))),
            )
          ],
        ),
      ),
    );
  }
}

