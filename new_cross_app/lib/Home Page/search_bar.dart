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

  Widget _buildSearchButton(BuildContext context, GlobalKey<FormState> formKey) {
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
        final params = {'userId': userId, 'postcode': _postcode!, 'workType': _worktype!};
        GoRouter.of(context).pushNamed(RouterName.SearchOutcome, params: params);
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
    'HairAndMakeUp': Icons.face,
    'HomeRenovation': Icons.home_repair_service,
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
        hint: Container(
          width: double.infinity, // Ensures the hint content takes full width to center align the text properly
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.topicIconData, color: Colors.grey),  // 使用来自 StatefulWidget 的图标
              SizedBox(width: 10),
              Text(
                'Job Type',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        items: jobTypeIcons.entries.map<DropdownMenuItem<String>>((MapEntry<String, IconData> entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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



Widget buildPostcodeInput(GlobalKey<FormState> formKey, Function(String?) onSave) {
  return Form(
    key: formKey,
    child: Container(
      constraints: const BoxConstraints(maxWidth: 200), // Ensure it matches the width of the Job Type dropdown.
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2), // Changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        textAlign: TextAlign.center, // Centers the text as it is entered.
        decoration: InputDecoration(
          hintText: 'Postcode',
          hintStyle: TextStyle(color: Colors.grey), // Grey color for the hint.
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 10), // Padding to align the icon better within the input box.
            child: Icon(Icons.location_pin, color: Colors.black), // Icon for postcode input.
          ),
          border: InputBorder.none, // Removes the underline.
          counterText: "", // Removes the counter text.
        ),
        keyboardType: TextInputType.number,
        maxLength: 4, // Maintains the limit of 4 characters but hides the counter.
        validator: (value) => _validatePostcode(value),
        onSaved: onSave,
      ),
    ),
  );
}

String? _validatePostcode(String? value) {
  if (value == null || value.isEmpty) return 'Please enter a postcode';
  if (int.tryParse(value) == null) return 'Please enter only numeric characters';
  if (value.length != 4) return 'Postcode must be exactly 4 digits';
  return null;
}


