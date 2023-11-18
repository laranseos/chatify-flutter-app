import 'package:chatify_web/config.dart';
import 'package:smooth_corner/smooth_corner.dart';

class CommonImage extends StatelessWidget {
  final String? image, name;
  final double height, width;

  const CommonImage(
      {Key? key,
      this.image,
      this.name,
      this.width = Sizes.s54,
      this.height = Sizes.s54})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return image != "" && image != null
        ? CachedNetworkImage(
            imageUrl: image!,
            imageBuilder: (context, imageProvider) => SmoothContainer(
                  height: height,
                  width: width,
                  smoothness: 1,
                  color: appCtrl.appTheme.contactBgGray,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  alignment: Alignment.center,
                  child: SmoothClipRRect(
                    smoothness: 1,
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                    child: Image.network(
                      image!,
                      fit: BoxFit.fill,
                      height: height,
                      width: width,
                    ),
                  ),
                ),
            placeholder: (context, url) => SmoothContainer(
                  height: height,
                  width: width,
                  smoothness: 1,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  alignment: Alignment.center,
                  color: const Color(0xff3282B8),
                  child: Text(
                      name!.length > 2
                          ? name!
                              .replaceAll(" ", "")
                              .substring(0, 2)
                              .toUpperCase()
                          : name![0],
                      style: AppCss.poppinsblack16
                          .textColor(appCtrl.appTheme.white)),
                ),
            errorWidget: (context, url, error) => SmoothContainer(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  smoothness: 1,
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  color: const Color(0xff3282B8),
                  child: Text(
                    name!.length > 2
                        ? name!
                            .replaceAll(" ", "")
                            .substring(0, 2)
                            .toUpperCase()
                        : name![0],
                    style:
                        AppCss.poppinsblack16.textColor(appCtrl.appTheme.white),
                  ),
                ))
        : SmoothContainer(
            height: height,
            width: width,
            color: const Color(0xff3282B8),
            smoothness: 1,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            alignment: Alignment.center,
            child: Text(
              name != null && name != ""
                  ? name!.length > 2
                      ? name!.replaceAll(" ", "").substring(0, 2).toUpperCase()
                      : name![0]
                  : "C",
              style: AppCss.poppinsblack16.textColor(appCtrl.appTheme.white),
            ),
          );
  }
}
