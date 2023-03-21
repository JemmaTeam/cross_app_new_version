

import 'package:flutter/material.dart';
import 'package:jemma/enums/sort_order.dart';
import 'package:jemma/models/util.dart';
import 'package:jemma/providers/quotes.dart';

import '../../main.dart';

/// Dialog box which allows users to filter.
class FilterSelection extends StatefulWidget {

  FilterSelection({Key? key, required  this.sortField}) : super(key: key);
  final SortField? sortField;
  @override
  _FilterSelectionState createState() => _FilterSelectionState(sortField);
}

class _FilterSelectionState extends State<FilterSelection> {
 SortField? initialSortField;

  _FilterSelectionState(this.initialSortField);
  late String _selectedSortField = initialSortField?.field ?? QuotesNotifier.sortingFields.first;

  late SortOrder? _selectedSortOrderField = initialSortField?.order;

 @override
  Widget build(BuildContext context) {

    return AlertDialog(
      scrollable: true,
      title: const Text('Filters',style:TextStyle(fontWeight: FontWeight.bold)),
      content: Center(
        child: Column(
          children: [
            const Text("Fields",style: TextStyle(fontWeight: FontWeight.w600),),
            const SizedBox(height: 10,),
            Wrap(
                runSpacing: 5,
                spacing: 10,
                children:[
                  for(var sortingField in QuotesNotifier.sortingFields)
                    ChoiceChip(
                        elevation: 2,
                        label:Text(sortingField.toSortFieldStyledString()),
                        onSelected: (_){ setState(() {
                          _selectedSortField = sortingField;
                          if(sortingField == QuotesNotifier.sortingFields.first){
                            _selectedSortOrderField = null;
                          }
                        });},
                        selected: _selectedSortField==sortingField)]
            ),
            const SizedBox(height: 20,),
            const Text("Order by",style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10,),
            Wrap(
                runSpacing: 5,
                spacing: 10,
                children:[
                  for (var sortOrderIconEntry in SortField.defaultSortOrderIcon.entries)
                  ChoiceChip(
                      avatar: Icon(sortOrderIconEntry.value),
                      elevation: 2,
                      label:Text(sortOrderIconEntry.key.toStyledString())
                      , selected: _selectedSortOrderField == sortOrderIconEntry.key
                  ,onSelected: (_){
                    if(_selectedSortField.isNotEmpty && _selectedSortField!=QuotesNotifier.sortingFields.first) {
                        setState(() {
                            _selectedSortOrderField = sortOrderIconEntry.key;
                        });
                    }
                  },
                  ),
              ]
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {Navigator.pop(context);},
          child: const Text('Cancel',style:TextStyle(fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () {

            logger.d("$_selectedSortOrderField $_selectedSortField");

            Navigator.pop(context,[_selectedSortOrderField,_selectedSortField]);},
          child: const Text('Apply',style:TextStyle(fontWeight: FontWeight.w600),),
        ),
      ],
    );
  }
}




