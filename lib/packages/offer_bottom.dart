import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

showModalSheet({required context,required TextEditingController textEditingController}){
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30))),
      context: context,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 5),
            height:
            MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text("Offer Price"),
                TextFormField(
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                          BorderRadius.circular(30)),
                      child: const Text("Send",
                          style: TextStyle(
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}