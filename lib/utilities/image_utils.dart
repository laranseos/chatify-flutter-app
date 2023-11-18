


import 'dart:io';

import '../config.dart';

/*


Widget imageNetwork({
  required String url,
  double? height,
  double? width,
  BoxFit? fit,
  Widget? placeholder,
  String? errorImageAsset,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    placeholder: (context, url) =>
        placeholder ??
        const Center(
          child: SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
    errorWidget: (context, url, error) => Image.asset(
      errorImageAsset ?? ImageAssets().onBoarding,
      width: width,
      height: height,
      fit: BoxFit.cover,
    ),
  );
}

Future imagePreView(context, url) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (context) {
      return ImagePreview(url: url);
    },
  );
}
*/

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
  return image;
}