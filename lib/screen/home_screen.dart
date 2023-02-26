import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:makerthon/constants.dart';
import 'package:makerthon/notifier/status_notifier.dart';
import 'package:makerthon/screen/keyword_screen.dart';
import 'package:makerthon/screen/reward_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final double _toolBarHeight = 60;

  final TextEditingController _characterNameFieldController =
      TextEditingController();

  late StatusNotifier unsubscribableNotifier;
  @override
  void initState() {
    unsubscribableNotifier =
        Provider.of<StatusNotifier>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _characterNameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // toolbarHeight: _toolBarHeight,
        centerTitle: true,
        title: const Text(
          "고우니",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue.shade100,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
            ),
            ListTile(
              title: const Text(
                '키워드 정보',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const KeywordScreen()));
              },
            ),
            ListTile(
              title: const Text(
                '보상 설정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const RewardScreen()));
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshEvent,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - _toolBarHeight - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lv.${Provider.of<StatusNotifier>(context).currentLevel} ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        Provider.of<StatusNotifier>(context).characterName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () => _nameChangeDialog(
                            context, _characterNameFieldController),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(flex: 5, child: mapObjectByLevel()),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 40,
                        animation: true,
                        animateFromLastPercent: true,
                        lineHeight: 20.0,
                        animationDuration: 1500,
                        percent: Provider.of<StatusNotifier>(context)
                            .currentPercentage,
                        center: Text(
                            "${Provider.of<StatusNotifier>(context).currentPercentage * 100} %"),
                        barRadius: const Radius.circular(20),
                        progressColor: Colors.green.shade400,
                        backgroundColor: Colors.grey.shade300,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        '다음 보상은 ${Provider.of<StatusNotifier>(context).rewardNames[Provider.of<StatusNotifier>(context).currentLevel%3]}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          borderRadius: BorderRadius.circular(20)),
                      width: MediaQuery.of(context).size.width - 40,
                      margin: const EdgeInsets.only(bottom: 10),
                      // padding: const EdgeInsets.all(10.0),
                      child: mapImageByLevel(
                          Provider.of<StatusNotifier>(context))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshEvent() async {
    unsubscribableNotifier.fetchCounts();
    return;
  }

  Widget mapObjectByLevel() {
    return Consumer<StatusNotifier>(builder: (_, notifier, __) {
      print("build again");
      final List<List<Object>> objectForEachLevelAndMode = [
        [buildObj(ASSET_EGG), buildObj(ASSET_EGG)],
        [buildObj(ASSET_HAPPY_PUPPY), buildObj(ASSET_ANGRY_PUPPY)],
        [buildObj(ASSET_HAPPY_WOLF), buildObj(ASSET_ANGRY_WOLF)]
      ];
      return  Cube(
              key: UniqueKey(),
              onSceneCreated: (Scene scene) {
                int mode = 0;
                if (notifier.characterMode == MODE_HEART) {
                  scene.world.add(buildObj(ASSET_MARK_HEART));
                } else if (notifier.characterMode == MODE_BAD) {
                  mode = 1;
                  scene.world.add(buildObj(ASSET_MARK_BAD));
                }
                scene.world.add(
                    objectForEachLevelAndMode[notifier.currentLevel%3][mode]);
                scene.light.setColor(Colors.white, 0.3, 0.8, 0.3);
                scene.light.position.setFrom(Vector3(0, 10, -10));
                scene.camera.zoom = 8;
              },
            ) ;
    });
  }

  Widget mapImageByLevel(StatusNotifier notifier) {
    int level = notifier.currentLevel;
    File? file;

    if (level < notifier.rewardImages.length) {
      file = notifier.rewardImages[level];
    }

    return file == null
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 20,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 60,
                ),
                Text(
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
            height: double.maxFinite,
            // width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.hardEdge,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.file(filterQuality:FilterQuality.high, file),
              ),
            ),
          );
  }
}

Future<void> _nameChangeDialog(
    BuildContext context, TextEditingController controller) {
  final StatusNotifier notifier =
      Provider.of<StatusNotifier>(context, listen: false);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => ChangeNotifierProvider.value(
      value: notifier,
      child: AlertDialog(
        title: const Text('캐릭터 이름 설정'),
        content: TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.grey.shade300,
              hintText: '이름을 입력하세요',
            )),
        actions: <Widget>[
          TextButton(
            child: const Text(
              '취소',
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              '수정',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              notifier.updateCharacterName(controller.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );
}

Object buildObj(String filename) {
  return Object(fileName: filename, scale: Vector3(1, 1, 1), lighting: true);
}
