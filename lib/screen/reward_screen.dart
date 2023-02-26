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
  List<File?> images = [null, null, null];

  late List<TextEditingController> _rewardNameFieldControllers;

  Future pickImage(int i) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (image != null) {
      final imageTemp = File(image.path);
      setState(() => images[i] = imageTemp);
    }
  }

  @override
  void initState() {
    StatusNotifier unsubscribableNotifier =
        Provider.of<StatusNotifier>(context, listen: false);
    unsubscribableNotifier.calculateLevelAndPercentage();
    _rewardNameFieldControllers = unsubscribableNotifier.rewardNames
        .map((t) => TextEditingController(text: t))
        .toList();

    super.initState();
  }

  @override
  void dispose() {
    _rewardNameFieldControllers.map((c) => c.dispose());
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
                buildLevelArea(0),
                buildLevelArea(1),
                buildLevelArea(2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          StatusNotifier notifier = Provider.of<StatusNotifier>(
                              context,
                              listen: false);
                          notifier.updateRewardName(_rewardNameFieldControllers
                              .map((c) => c.text)
                              .toList());
                          notifier.updateRewardImage(images);
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

  Widget renderImage(File? file, int i) {
    return file == null
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
                    onTap: () => pickImage(i),
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
        : SizedBox(
            height: MediaQuery.of(context).size.width / 2,
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.hardEdge,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image.file(filterQuality:FilterQuality.high, file),
              ),
            ),
          );
  }

  Widget buildLevelArea(int i) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "레벨 ${i + 1}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 15,
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
            controller: _rewardNameFieldControllers[i],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey.shade300,
              hintText: '이름을 입력하세요',
            ),
          ),
          const SizedBox(
            height: 15,
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
          renderImage(images[i], i),
          const SizedBox(
            height: 40,
          ),
        ]);
  }
}
