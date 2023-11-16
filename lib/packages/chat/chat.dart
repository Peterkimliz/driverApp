import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_shared/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:safiri/packages/bloc/package_bloc.dart';
import 'package:safiri/packages/bloc/package_events.dart';
import 'package:safiri/packages/chat/chat_model.dart';
import 'package:safiri/packages/package.dart';
import 'package:safiri/repositories/package_repository.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatefulWidget {
  final Package? package;
  final String chatId;

  const ChatPage({super.key, required this.package, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();
  bool showSendMessage = false;

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
            Text(
                "${toBeginningOfSentenceCase(widget.package?.owner?.firstName)}"),
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
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chats")
                        .doc(widget.chatId)
                        .collection("chats")
                        .orderBy("date")
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // final reversedIndex =
                              //     snapshot.data!.docs.length - 1 - index;
                              ChatModel chat = ChatModel.fromJson(
                                  snapshot.data!.docs[index]);
                              return chat.senderId ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxWidth: 250),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 15),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(chat.message!),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "${DateFormat("dd-MM-yyyy hh:mm a").format(chat.date!)}"),
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
                                          constraints: const BoxConstraints(
                                              maxWidth: 250),
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 15),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                Text(DateFormat(
                                                        "dd-MM-yyyy hh:mm a")
                                                    .format(DateTime.now())),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            });
                      } else {
                        return const Center(child: Text("no chats"));
                      }
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
                    controller: textEditingController,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            if (textEditingController.text.trim().isNotEmpty) {
                              BlocProvider.of<PackageBloc>(context).add(
                                  SendMessage(
                                      id: widget.chatId,
                                      message:
                                          textEditingController.text.trim(),
                                      package: widget.package!));
                              textEditingController.clear();
                            }
                          },
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
