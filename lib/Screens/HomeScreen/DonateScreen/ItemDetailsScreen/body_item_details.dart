import 'package:flutter/material.dart';

class BodyItemDetails extends StatefulWidget {
  const BodyItemDetails({super.key, required this.itemCategory});
  final String itemCategory;
  @override
  State<BodyItemDetails> createState() => _BodyItemDetailsState();
}

class _BodyItemDetailsState extends State<BodyItemDetails> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                InkWell(
                  splashColor: Colors.green,
                  onTap: (){

                  },
                  child: Ink(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo),
                        Text('Upload'),
                        Text('Image'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextFormField(
                  initialValue: widget.itemCategory,
                  decoration: const InputDecoration(
                    labelText: 'Item Category',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  enabled: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Item description *',
                    border: OutlineInputBorder(),
                    hintText:
                        'Description of the item such as its working condition, etc',
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Item description cannot be empty';
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.23,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('* fields are mandatory'),
                    InkWell(
                      splashColor: Colors.green,
                      onTap: () {
                        // TODO: Navigate to optional details page
                      },
                      child: const Text(
                        'Optional Details',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(80),
              backgroundColor: Colors.green),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const SignUpScreen();
            // }));
          },
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
