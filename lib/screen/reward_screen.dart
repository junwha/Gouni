import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makerthon/notifier/status_notifier.dart';
import 'package:provider/provider.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  File? image1;
  File? image2;
  File? image3;

  late TextEditingController _rewardNameFieldController1 =
      TextEditingController();
  late TextEditingController _rewardNameFieldController2 =
      TextEditingController();
  late TextEditingController _rewardNameFieldController3 =
      TextEditingController();

  Future pickImage1() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (image != null) {
      final imageTemp = File(image.path);
      setState(() => image1 = imageTemp);
    }
  }

  Future pickImage2() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (image != null) {
      final imageTemp = File(image.path);
      setState(() => image2 = imageTemp);
    }
  }

  Future pickImage3() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (image != null) {
      final imageTemp = File(image.path);
      setState(() => image3 = imageTemp);
    }
  }

  @override
  void initState() {
    StatusNotifier unsubscribableNotifier =
        Provider.of<StatusNotifier>(context, listen: false);
    unsubscribableNotifier.calculateLevelAndPercentage();
    _rewardNameFieldController1 =
        TextEditingController(text: unsubscribableNotifier.rewardNames[0]);
    _rewardNameFieldController2 =
        TextEditingController(text: unsubscribableNotifier.rewardNames[1]);
    _rewardNameFieldController3 =
        TextEditingController(text: unsubscribableNotifier.rewardNames[2]);
    image1 = unsubscribableNotifier.rewardImage1;
    image2 = unsubscribableNotifier.rewardImage2;
    image3 = unsubscribableNotifier.rewardImage3;
    super.initState();
  }

  @override
  void dispose() {
    _rewardNameFieldController1.dispose();
    _rewardNameFieldController2.dispose();
    _rewardNameFieldController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "보상 설정",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "레벨 1",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "보상 이름",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                TextField(
                  controller: _rewardNameFieldController1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: '이름을 입력하세요',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "이미지",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                image1 == null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: pickImage1,
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 60,
                                )),
                            const Text(
                              '이미지를 추가해주세요.',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 1,
                            ),
                            Image.file(image1!),
                            GestureDetector(
                              onTap: () => pickImage1(),
                              child: const Icon(Icons.image),
                            )
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "레벨 2",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "보상 이름",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                TextField(
                  controller: _rewardNameFieldController2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: '이름을 입력하세요',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "이미지",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                image2 == null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: pickImage2,
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 60,
                                )),
                            const Text(
                              '이미지를 추가해주세요.',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 1,
                            ),
                            Image.file(image2!),
                            GestureDetector(
                              onTap: () => pickImage2(),
                              child: const Icon(Icons.image),
                            )
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "레벨 3",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "보상 이름",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                TextField(
                  controller: _rewardNameFieldController3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: '이름을 입력하세요',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "이미지",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                image3 == null
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: pickImage3,
                                child: const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 60,
                                )),
                            const Text(
                              '이미지를 추가해주세요.',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 1,
                            ),
                            Image.file(image3!),
                            GestureDetector(
                              onTap: () => pickImage3(),
                              child: const Icon(Icons.image),
                            )
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          StatusNotifier notifier = Provider.of<StatusNotifier>(
                              context,
                              listen: false);
                          notifier.updateRewardName(
                            _rewardNameFieldController1.text,
                            _rewardNameFieldController2.text,
                            _rewardNameFieldController3.text,
                          );
                          notifier.updateRewardImage(
                            image1,
                            image2,
                            image3,
                          );
                          notifier.calculateLevelAndPercentage();
                          Navigator.of(context).pop();
                        },
                        child: const Text('수정')),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
