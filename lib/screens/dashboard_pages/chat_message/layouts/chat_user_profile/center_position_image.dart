

import 'package:chatify_web/widgets/common_photo_view.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../../config.dart';

class CenterPositionImage extends StatelessWidget {
  final double topAlign;
  final bool isSliverAppBarExpanded, isGroup, isBroadcast;
  final String? image, name;
  final GestureTapCallback? onTap;

  const CenterPositionImage(
      {Key? key,
      this.topAlign = 5,
      this.isSliverAppBarExpanded = false,
      this.isGroup = false,
      this.isBroadcast = false,
      this.onTap,
      this.image,
      this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 8,
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 4),
          opacity: isSliverAppBarExpanded ? 0 : 1,
          child: Stack(
            children: [
              isBroadcast
                  ? SmoothContainer(
                      height: Sizes.s110,
                      width: Sizes.s110,
                  color: appCtrl.appTheme.secondary,
                      smoothness: 1,
                      borderRadius: BorderRadius.circular(AppRadius.r22),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(svgAssets.audio))
                  : CachedNetworkImage(
                      imageUrl: image!,
                      imageBuilder: (context, imageProvider) => SmoothContainer(
                          height: Sizes.s110,
                          width: Sizes.s110,
                          color: appCtrl.appTheme.contactBgGray,
                          smoothness: 1,
                          borderRadius: BorderRadius.circular(AppRadius.r22),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r22)),
                                  child: Image.network(image!,fit: BoxFit.fill))).inkWell(onTap: ()=> Get.to(CommonPhotoView(image: image,))),
                      placeholder: (context, url) => SmoothContainer(
                        height: Sizes.s110,
                        width: Sizes.s110,
                        color: appCtrl.appTheme.secondary,
                        smoothness: 1,
                        borderRadius: BorderRadius.circular(AppRadius.r22),
                            child: Text(
                                name != null
                                    ? name!.length > 2
                                        ? name!
                                            .replaceAll(" ", "")
                                            .substring(0, 2)
                                            .toUpperCase()
                                        : name![0]
                                    : "C",
                                style: AppCss.poppinsblack16
                                    .textColor(appCtrl.appTheme.white)).alignment(Alignment.center),
                          ),
                      errorWidget: (context, url, error) => SmoothContainer(
                        height: Sizes.s110,
                        width: Sizes.s110,
                        color: appCtrl.appTheme.secondary,
                        smoothness: 1,
                        borderRadius: BorderRadius.circular(AppRadius.r22),
                            child: Text(
                              name != null && name != ""
                                  ? name!.length > 2
                                      ? name!
                                          .replaceAll(" ", "")
                                          .substring(0, 2)
                                          .toUpperCase()
                                      : name![0]
                                  : "C",
                              style: AppCss.poppinsblack16
                                  .textColor(appCtrl.appTheme.white),
                            ).alignment(Alignment.center),
                          )),
              if (isGroup)
                Positioned(
                    bottom: 0,
                    right: -2,
                    child: SmoothContainer(
                      padding: const EdgeInsets.all(Insets.i1),
                      color: appCtrl.appTheme.whiteColor,
                      smoothness: 1,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      child: SmoothContainer(
                        padding: const EdgeInsets.all(Insets.i5),
                        color: appCtrl.appTheme.primary,
                        smoothness: 1,
                        borderRadius: BorderRadius.circular(AppRadius.r22),
                        child: SvgPicture.asset(
                          svgAssets.camera,
                          height: Sizes.s22,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ).inkWell(onTap: onTap))
            ],
          ).height(Sizes.s120).width(Sizes.s115)),
    );
  }
}
