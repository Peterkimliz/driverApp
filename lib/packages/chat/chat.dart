import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safiri/packages/package.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatelessWidget {


  ChatPage({super.key});

  List chats = [
    {
      "message": "hello",
      "sender": "me",
    },
    {
      "message": "hello",
      "sender": "him",
    },
    {
      "message": "What the budget",
      "sender": "me",
    },
    {
      "message": "200 dollars",
      "sender": "him",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        titleSpacing: 0.0,
        title: Row(
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=800",
              height: 40,
              width: 40,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                          Colors.transparent, BlendMode.colorBurn)),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: CustomTheme.neutralColors.shade300,
                highlightColor: CustomTheme.neutralColors.shade100,
                enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                      color: CustomTheme.neutralColors.shade300,
                      shape: BoxShape.circle),
                  height: 40,
                  width: 40,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text("Petro"),
          ],
        ),
        elevation: 0.5,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: chats.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return chats[index]["sender"] == "me"
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 250),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 15),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(chats[index]["message"]),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              "${DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now())}"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 250),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                            "Hello there thanks ty yeah sdgfjgslkdfhiksdzh"),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(DateFormat("dd-MM-yyyy hh:mm a")
                                            .format(DateTime.now())),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Theme(
          data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: BottomAppBar(
            elevation: 2,
            child: Container(
              height: kBottomNavigationBarHeight * 1.5,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.grey,
                          )),
                      hintText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
