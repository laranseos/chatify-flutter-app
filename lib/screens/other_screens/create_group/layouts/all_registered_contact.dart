

import '../../../../config.dart';

class AllRegisteredContact extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool? isExist;
  final RegisterContactDetail? data;

  const AllRegisteredContact({Key? key, this.onTap, this.data, this.isExist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      onTap: onTap,
      trailing: Container(
          decoration: BoxDecoration(
            border: Border.all(color: appCtrl.appTheme.borderGray, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            isExist! ? Icons.check : null,color: appCtrl.appTheme.primary,
            size: 19.0,
          )),
      leading: CommonImage(image: data!.image, name: data!.name),
      title: Text(data!.name ?? ""),
      subtitle: Text(data!.statusDesc ?? ""),
    );
  }
}
