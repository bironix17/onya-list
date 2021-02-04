import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onya_list/common/app_fonts.dart';
import 'package:flutter_onya_list/common/enams.dart';
import 'package:flutter_onya_list/common/global_values.dart';
import 'package:flutter_onya_list/models/project_card.dart';
import 'package:flutter_onya_list/projects_screen/bloc/bloc.dart';
import 'package:flutter_onya_list/projects_screen/bloc/event.dart';
import 'package:flutter_svg/svg.dart';

class CardList extends StatelessWidget {
  TabNames tabName;
  List<ProjectCardData> projectsCardData;
  BuildContext context;
  ScrollController scrollController;

  CardList(this.tabName, this.projectsCardData, this.context, this.scrollController);

  bool _isBottom = false;
  double bottomPaddingForNotificationListener = 50;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        final isBottom =
            notification.metrics.maxScrollExtent <= notification.metrics.pixels + bottomPaddingForNotificationListener; // TODO кастыль

        if (isBottom != _isBottom) {
          _isBottom = isBottom;
          if (isBottom) {
            BlocProvider.of<ProjectsBloc>(context)
                .add(LoadMoreCardsEvent(tabName));
          }
        }
        return true;
      },

      child: RefreshIndicator(

        onRefresh: () async {
          BlocProvider.of<ProjectsBloc>(context).add(LoadCardsEvent());
        },

        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: projectsCardData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Common.horizontalPadding,
                              vertical: 8),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            )
                          ]),
                          child: InkWell(
                            child: Card(
                                elevation: 0,
                                child: Container(
                                  height: 340,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        child: ListTile(
                                          title: Container(
                                              alignment: Alignment(-1.1, 0),
                                              child: Text(
                                                projectsCardData[index]
                                                    .authorLabels
                                                    .name,
                                                style: AppFonts.sfUiDisplay
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                              )),
                                          subtitle: Container(
                                              alignment: Alignment(-1.15, 0),
                                              child: Text(
                                                  projectsCardData[index]
                                                          .authorLabels
                                                          .profession +
                                                      " * " +
                                                      projectsCardData[index]
                                                          .authorLabels
                                                          .location,
                                                  style: AppFonts
                                                      .sfUiDisplaySemiBond
                                                      .copyWith(
                                                    fontSize: 12,
                                                    height: 1.16,
                                                    color: Color(0xffB7B7B7),
                                                    letterSpacing: 0.6,
                                                  ))),
                                          leading: Container(
                                              alignment: Alignment.center,
                                              width: 40,
                                              child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "assets/image/duck.jpg"),
                                                  radius: 16)),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 2),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                  projectsCardData[index]
                                                      .cardName,
                                                  style: AppFonts
                                                      .sfUiDisplayMedium
                                                      .copyWith(
                                                          fontSize: 18,
                                                          height: 1.33,
                                                          color:
                                                              Colors.black87),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: false),
                                              SizedBox(height: 3),
                                              Text(
                                                projectsCardData[index].date,
                                                style:
                                                    AppFonts.faRegular.copyWith(
                                                  fontSize: 13,
                                                  color: Color(0xffB7B7B7),
                                                ),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          )),
                                      _buildImageBar(
                                          projectsCardData[index].imagePaths),
                                      Container(
                                          child: Row(
                                        children: [
                                          Container(
                                            child: projectsCardData[index]
                                                    .loadingVotes
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    height: 10,
                                                    width: 10,
                                                    child:
                                                        CircularProgressIndicator())
                                                : TextButton(
                                                    onPressed: () => BlocProvider
                                                            .of<ProjectsBloc>(
                                                                context)
                                                        .add(UpvoteClickEvent(
                                                            projectsCardData[
                                                                    index]
                                                                .id)),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icon/icon_up_circle.svg",
                                                          height: 12,
                                                          color: Common
                                                              .colorOrange,
                                                        ),
                                                        Container(width: 5),
                                                        Text(
                                                            projectsCardData[index]
                                                                        .votes == 0
                                                                ? "UPVOTE"
                                                                : projectsCardData[
                                                                        index]
                                                                    .votes
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Common
                                                                    .colorOrange))
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                          Container(width: 5),
                                          TextButton(
                                              onPressed: null,
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/icon/icon_comment.svg",
                                                      height: 10,
                                                      color:
                                                          Common.colorOrange),
                                                  Container(width: 5),
                                                  Text("COMMENT",
                                                      style: TextStyle(
                                                          color: Common
                                                              .colorOrange)),
                                                ],
                                              ))
                                        ],
                                      ))
                                    ],
                                  ),
                                )),
                          ),
                        );
                      }),
                  if (true)
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                          child:
                              CircularProgressIndicator()))
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildImageBar(List<String> imagesPaths) {
    if (imagesPaths.length == 1) {
      return Container(
        height: 148,
        margin: EdgeInsets.symmetric(horizontal: 10),
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Image(image: AssetImage(imagesPaths.first), fit: BoxFit.cover),
      );
    }

    if (imagesPaths.length == 2) {
      return Container(
        height: 148,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageRectangle(135, 155, imagesPaths[0]),
            _buildImageRectangle(135, 155, imagesPaths[1]),
          ],
        ),
      );
    }

    if (imagesPaths.length > 2) {
      return Container(
        child: Expanded(
          child: CustomScrollView(scrollDirection: Axis.horizontal, slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child:
                            _buildImageRectangle(135, 148, imagesPaths[index]),
                      ),
                  childCount: imagesPaths.length),
            )
          ]),
        ),
      );
    }
    return Text("Неучтёнка");
  }

  Widget _buildImageRectangle(double height, double width, String imagePath) {
    return Container(
      height: height,
      width: width,
      child: Image(image: AssetImage(imagePath), fit: BoxFit.cover),
    );
  }
}
