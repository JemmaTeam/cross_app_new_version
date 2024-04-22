part of home;

// Import necessary Flutter packages

String? _worktype;
String? _postcode;

class SearchBar extends StatelessWidget {
  final String userId;

  SearchBar({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _postCodeFormKey = GlobalKey<FormState>();

    return Container(
      width: 40.pw(size),
      constraints: const BoxConstraints(minWidth: 250),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(35),
      ),
      child: OverflowBar(
        overflowAlignment: OverflowBarAlignment.center,
        spacing: 2.5.pw(size),
        overflowSpacing: 1.75.ph(size),
        children: [
          DropDownContainer(
            topic: "Job type",
            topicIconData: Icons.handyman,
            dropDownContent: {},
          ),
          buildPostcodeInput(_postCodeFormKey, (value) => _postcode = value),
          _buildSearchButton(context, _postCodeFormKey),
        ],
      ),
    );
  }

  Widget _buildSearchButton(
      BuildContext context, GlobalKey<FormState> formKey) {
    return ElevatedButton.icon(
      onPressed: () => _handleSearch(context, formKey),
      icon: const Icon(Icons.search, color: Colors.black, size: 18),
      label: const Text(
        'Search',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(primary: kLogoColor, elevation: 2),
    );
  }

  void _handleSearch(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (_postcode != null && _worktype != null) {
        final params = {
          'userId': userId,
          'postcode': _postcode!,
          'workType': _worktype!
        };
        GoRouter.of(context)
            .pushNamed(RouterName.SearchOutcome, params: params);
      }
    }
  }
}

class DropDownContainer extends StatefulWidget {
  final String topic;
  final IconData topicIconData;
  final Map<String, Image> dropDownContent;

  DropDownContainer({
    Key? key,
    required this.topic,
    required this.topicIconData,
    required this.dropDownContent,
  }) : super(key: key);

  @override
  State<DropDownContainer> createState() => _DropDownContainerState();
}

class _DropDownContainerState extends State<DropDownContainer> {
  final Map<String, IconData> jobTypeIcons = {
    'AirconMechanic': Icons.ac_unit,
    'BrickLayer': Icons.landscape,
    'Carpenter': Icons.build,
    'CarpetLayer': Icons.layers,
    'Decking': Icons.deck,
    'Electrcian': Icons.electric_bolt,
    'Fencing': Icons.fence,
    'GasPlumber': Icons.fireplace,
    'Glazier': Icons.window,
    'Hairdressing': Icons.face,
    'Home renovations': Icons.home_repair_service,
    'Insulation': Icons.thermostat,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: Colors.grey.shade300), // Border color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: _worktype,
        onChanged: (String? newValue) {
          setState(() {
            _worktype = newValue;
          });
        },
        alignment: Alignment.centerLeft,
        hint: Container(
          alignment: Alignment.center,
          // Center alignment for the hint
          width: double.infinity,
          // Ensures the hint content takes full width to center align the text properly
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.topicIconData, color: Colors.grey),
              // 使用来自 StatefulWidget 的图标
              SizedBox(width: 10),
              Text(
                'Job Type',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        selectedItemBuilder: (BuildContext context) {
          return jobTypeIcons.entries
              .map<Widget>((MapEntry<String, IconData> entry) {
            return Container(
              alignment: Alignment.center,
              // Center alignment for the selected item display
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(entry.value, color: Colors.black54),
                  SizedBox(width: 10),
                  Text(entry.key),
                ],
              ),
            );
          }).toList();
        },
        items: jobTypeIcons.entries
            .map<DropdownMenuItem<String>>((MapEntry<String, IconData> entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // Start alignment for the dropdown menu items
              children: [
                Icon(entry.value, color: Colors.black54),
                SizedBox(width: 10),
                Text(entry.key),
              ],
            ),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(), // Removes the default underline
      ),
    );
  }
}

// 定义一个构建邮编输入表单的函数，接收一个表单键和一个保存数据的回调函数
Widget buildPostcodeInput(
    GlobalKey<FormState> formKey, // 表单键，用于关联表单状态
    Function(String?) onSave) {
  // 保存函数，用于处理表单提交的数据
  return Form(
    key: formKey, // 设置表单键
    child: Container(
      constraints: const BoxConstraints(maxWidth: 200), // 设置容器的最大宽度
      padding:
          const EdgeInsets.symmetric(vertical: 5, horizontal: 5), // 设置容器内边距
      decoration: BoxDecoration(
        color: Colors.white, // 背景颜色设置为白色
        borderRadius: BorderRadius.circular(10), // 边角为圆角，半径为10
        border: Border.all(color: Colors.grey.shade300), // 设置边框颜色和样式
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 阴影颜色
            spreadRadius: 1, // 阴影扩散半径
            blurRadius: 3, // 阴影模糊半径
            offset: Offset(0, 2), // 阴影偏移量
          ),
        ],
      ),
      // 使用 TextFormField 创建一个文本输入框
      child: TextFormField(
        textAlign: TextAlign.center, // 文本居中对齐
        decoration: InputDecoration(
          hintText: 'Postcode', // 输入框内提示文本
          hintStyle: TextStyle(color: Colors.grey), // 提示文本样式
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 10), // 图标内边距
            child: Icon(Icons.location_pin, color: Colors.black), // 设置图标和颜色
          ),
          border: InputBorder.none, // 不显示输入框边框
          counterText: "", // 不显示输入长度计数器
        ),
        keyboardType: TextInputType.number, // 键盘类型设置为数字
        maxLength: 4, // 最大长度设置为4
        autovalidateMode: AutovalidateMode.onUserInteraction, // 输入后即时验证
        validator: (value) => _validatePostcode(value), // 验证函数，检查邮编有效性
        onSaved: onSave, // 保存函数，处理表单提交
      ),
    ),
  );
}

String? _validatePostcode(String? value) {
  if (value == null || value.isEmpty) return 'Please enter a postcode';
  if (int.tryParse(value) == null)
    return 'Please enter only numeric characters';
  if (value.length != 4) return 'Postcode must be exactly 4 digits';
  if (!_isValidAustralianPostcode(value))
    return 'Invalid postal code'; // Check if it's a valid Australian postcode
  return null;
}

bool _isValidAustralianPostcode(String postcode) {
  int code = int.tryParse(postcode) ?? 0; // 使用 tryParse 并处理可能的 null 值
  return (code >= 1000 && code <= 1999) || // NSW
      (code >= 2000 && code <= 2599) || // NSW
      (code >= 2619 && code <= 2898) || // NSW
      (code >= 2921 && code <= 2999) || // NSW
      (code >= 200 && code <= 299) || // ACT
      (code >= 2600 && code <= 2618) || // ACT
      (code >= 2900 && code <= 2920) || // ACT
      (code >= 3000 && code <= 3999) || // VIC
      (code >= 8000 && code <= 8999) || // VIC (邮件用)
      (code >= 4000 && code <= 4999) || // QLD
      (code >= 9000 && code <= 9999) || // QLD (邮件用)
      (code >= 5000 && code <= 5799) || // SA
      (code >= 5800 && code <= 5999) || // SA (邮件用)
      (code >= 6000 && code <= 6797) || // WA
      (code >= 6800 && code <= 6999) || // WA (邮件用)
      (code >= 7000 && code <= 7799) || // TAS
      (code >= 7800 && code <= 7999) || // TAS (邮件用)
      (code >= 800 && code <= 899) || // NT
      (code >= 900 && code <= 999); // NT (邮件用)
}
