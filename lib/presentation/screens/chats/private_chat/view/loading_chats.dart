import 'package:flutter/material.dart';
import 'package:game_on_flutter/presentation/app_widgets/app_shimmer.dart';

class LoadingChatsShimmerWidget extends StatelessWidget {
  const LoadingChatsShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                receiverRow1(),
                senderRow1(),
                receiverRow1(),
                senderRow1(),
                receiverRow1(),
                receiverRow1(),
                senderRow1(),
                receiverRow1(),
                senderRow1(),
                receiverRow1(),
                senderRow1(),
              ],
            )));
  }

  Widget receiverRow1() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 28.0,
            height: 28.0,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(100)),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
          ),
          Container(
            width: 262.0,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 16.0,
                  margin: const EdgeInsets.only(right: 16.0, left: 8.0),
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: double.infinity,
                  height: 16.0,
                  margin: const EdgeInsets.only(right: 20.0, left: 8.0),
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: 120,
                  height: 16.0,
                  margin: const EdgeInsets.only(right: 20.0, left: 8.0),
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget senderRow1({double width = 300.0}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 16.0,
                  margin: const EdgeInsets.only(right: 16.0, left: 8.0),
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: double.infinity,
                  height: 16.0,
                  margin: const EdgeInsets.only(right: 20.0, left: 8.0),
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: 120,
                  height: 16.0,
                  margin: const EdgeInsets.only(right: 20.0, left: 8.0),
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget chatRowShimmer() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48.0,
            height: 48.0,
            color: Colors.white,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                Container(
                  width: 40.0,
                  height: 8.0,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
