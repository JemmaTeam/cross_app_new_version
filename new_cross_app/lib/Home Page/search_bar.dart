part of home;

String? _workType;
String? _postcode;

class SearchBar extends StatefulWidget {
  final String userId;

  SearchBar({Key? key, required this.userId}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final GlobalKey<FormState> _postCodeFormKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> jobType = [
    {'name': 'AirconMechanic', 'icon': Icons.ac_unit},
    {'name': 'BrickLayer', 'icon': Icons.layers},
    {'name': 'Carpenter', 'icon': Icons.chair},
    {'name': 'CarpetLayer', 'icon': Icons.texture},
    {'name': 'Decking', 'icon': Icons.dashboard},
    {'name': 'Electrcian', 'icon': Icons.electrical_services},
    {'name': 'Fencing', 'icon': Icons.fence},
    {'name': 'GasPlumber', 'icon': Icons.plumbing},
    {'name': 'Glazier', 'icon': Icons.window},
    {'name': 'Hair & Make-up', 'icon': Icons.face},
    {'name': 'Home-Renovation', 'icon': Icons.construction},
    {'name': 'Insulation', 'icon': Icons.home},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.5,
      constraints: BoxConstraints(minWidth: 250),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Form(
        key: _postCodeFormKey,
        child: OverflowBar(
          overflowAlignment: OverflowBarAlignment.center,
          spacing: 20,
          children: [
            DropDownContainer(
              topic: "Job type",
              jobType: jobType,
              onChanged: (String? newValue) {
                setState(() {
                  _workType = newValue;
                });
              },
            ),
            buildPostcodeInput((value) => _postcode = value),
            _buildSearchButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        if (_postCodeFormKey.currentState!.validate()) {
          _postCodeFormKey.currentState!.save();
          // Execute search logic
        }
      },
      icon: Icon(Icons.search, color: Colors.black),
      label: Text('Search', style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(backgroundColor: kLogoColor, elevation: 2), // Updated here for deprecation
    );
  }
}

Widget buildPostcodeInput(Function(String?) onSave) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Postcode',
      prefixIcon: Icon(Icons.location_on),
      border: OutlineInputBorder(),
      errorStyle: TextStyle(color: Colors.red),
    ),
    keyboardType: TextInputType.number,
    onSaved: (value) => _postcode = value,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a postcode';
      }
      final postcodeNum = int.tryParse(value);
      if (postcodeNum == null || postcodeNum < 200 || postcodeNum > 9999) {
        return 'Please enter the correct postcode';
      }
      return null;
    },
  );
}

class DropDownContainer extends StatelessWidget {
  final String topic;
  final List<Map<String, dynamic>> jobType;
  final Function(String?) onChanged;

  DropDownContainer({
    Key? key,
    required this.topic,
    required this.jobType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: topic,
        border: OutlineInputBorder(),
      ),
      value: _workType,
      onChanged: onChanged,
      items: jobType.map<DropdownMenuItem<String>>((Map<String, dynamic> job) {
        return DropdownMenuItem<String>(
          value: job['name'],
          child: Row(
            children: <Widget>[
              Icon(job['icon']), // Assuming each job type has an icon
              SizedBox(width: 10),
              Text(job['name']),
            ],
          ),
        );
      }).toList(),
    );
  }
}
