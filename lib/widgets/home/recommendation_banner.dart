import 'package:flutter/material.dart';
import 'package:jemma/utils/constants.dart';
import 'package:sizer/sizer.dart';

class RecommendationBanner extends StatelessWidget {
  const RecommendationBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final testTexts = ['Test1', 'Test2', 'Test3', 'Test4', 'Test5'];

    return Container(
        // color: Colors.red,
        height: 20.h,
        margin: EdgeInsets.symmetric(
          horizontal: 5.w,
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // TODO: replace with request map
          itemCount: testTexts.length,
          itemBuilder: (BuildContext context, int index) {
            String text = testTexts[index];
            return _RecommendationItem(text: text);
          }
        ),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  const _RecommendationItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      margin: EdgeInsets.symmetric(
        horizontal: 2.h,
      ),
      width: 20.h,
      child: Column(
        children: [
          // TODO: replace with picture 4:3
          Container(
            color: kLogoColor,
            height: 15.h,
          ),
          const Spacer(),
          Text(
            text,
            style: TextStyle(fontSize: 10.sp),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
