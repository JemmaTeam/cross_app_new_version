import 'package:flutter/material.dart';
import 'package:new_cross_app/Home Page/constants.dart';

class RecommendationBanner extends StatelessWidget {
  const RecommendationBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final testTexts = ['Test1', 'Test2', 'Test3', 'Test4', 'Test5'];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // color: Colors.red,
      height: screenHeight * 0.20,  // 使用 screenHeight 的百分比
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,  // 使用 screenWidth 的百分比
      ),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      // color: Colors.blue,
      margin: EdgeInsets.symmetric(
        horizontal: screenHeight * 0.02,  // 使用 screenHeight 的百分比
      ),
      width: screenHeight * 0.20,  // 使用 screenHeight 的百分比保持宽高一致
      child: Column(
        children: [
          // TODO: replace with picture 4:3
          Container(
            color: kLogoColor,
            height: screenHeight * 0.15,  // 使用 screenHeight 的百分比
          ),
          const Spacer(),
          Text(
            text,
            style: TextStyle(fontSize: screenHeight * 0.02), // 使用 screenHeight 的百分比调整字体大小
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
