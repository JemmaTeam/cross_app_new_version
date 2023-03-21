import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A dialog box which captures the reason for quote decline and sends it to the parent widget from which this widget was instantiated.
class QuoteDeclineDialog extends StatelessWidget {
  const QuoteDeclineDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return AlertDialog(
        title: const Text("Quote decline",style:TextStyle(fontWeight: FontWeight.bold)),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 500,minWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outlined),
                  const SizedBox(width: 5),
                  const Text("Please provide a reason.",style: TextStyle(fontSize:14,fontWeight: FontWeight.w500)),
                ],
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _controller,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 5,
                validator: (input){ if(input!.isNotEmpty && input.length<=200){
                  return null;
                }
                else{
                  return "Please ensure input is not empty and is below the length of 200 characters";
                }
                },
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text("Cancel")),
          TextButton(onPressed: (){

            Navigator.pop(context,[_controller.text]);
          }, child: const Text("Confirm")),]
    );


  }
}
