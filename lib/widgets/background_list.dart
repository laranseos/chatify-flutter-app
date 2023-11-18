
import '../../../../config.dart';

class BackgroundList extends StatelessWidget {
  const BackgroundList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appCtrl.appTheme.whiteColor,
      appBar: CommonAppBar(text: fonts.defaultWallpaper),
      body: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Insets.i20),
        itemCount: appArray.backgroundList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 20,
            mainAxisExtent: 216,
            mainAxisSpacing: 20.0,
            crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Image.asset(
            appArray.backgroundList[index]["image"]!,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            opacity: const AlwaysStoppedAnimation(.22),
            height: Sizes.s210,
          )
              .clipRRect(all: AppRadius.r10)
              .inkWell(onTap: ()=> Get.back(result: appArray.backgroundList[index]));
        },
      ),
    );
  }
}
