

import 'package:smooth_corner/smooth_corner.dart';

import '../../../../config.dart';
import '../group_firebase_api.dart';

class CreateGroup extends StatelessWidget {

  const CreateGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Builder(
        builder: (context) {
          return GetBuilder<CreateGroupController>(builder: (groupCtrl) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  color: appCtrl.appTheme.transparentColor,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height /4,
                  width: MediaQuery.of(context).size.width /2,
                  child: Form(
                    key: groupCtrl.formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const VSpace(Sizes.s15),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              fonts.setGroup.tr,
                              textAlign: TextAlign.left,
                              style: AppCss.poppinsBold16
                                  .textColor(appCtrl.appTheme.blackColor),
                            ),
                          ),
                          const VSpace(Sizes.s20),
                          Row(
                            children: [
                              groupCtrl.pickerCtrl.image != null
                                  ? Container(
                                      height: Sizes.s60,
                                      width: Sizes.s60,
                                      decoration: BoxDecoration(
                                          color: appCtrl.appTheme.gray
                                              .withOpacity(.2),
                                          shape: BoxShape.circle),
                                      child: groupCtrl.isLoading ? const CircularProgressIndicator() : groupCtrl.imageUrl != "" ? Image.network(
                                          groupCtrl.imageUrl,
                                          fit: BoxFit.fill) : Image.memory(
                                              groupCtrl.webImage,
                                              fit: BoxFit.fill)
                                          .clipRRect(all: AppRadius.r50),
                                    ).inkWell(onTap: () {
                                      groupCtrl.pickerCtrl
                                          .imagePickerOption(context,isCreateGroup: true);
                                    })
                                  : Image.asset(
                                      imageAssets.user,
                                      height: Sizes.s30,
                                      width: Sizes.s30,
                                      color: appCtrl.appTheme.whiteColor,
                                    )
                                      .paddingAll(Insets.i15)
                                      .decorated(
                                          color: appCtrl.appTheme.grey
                                              .withOpacity(.4),
                                          shape: BoxShape.circle)
                                      .inkWell(
                                          onTap: () => groupCtrl.pickerCtrl
                                              .imagePickerOption(context,isCreateGroup: true)),
                              const HSpace(Sizes.s15),
                              Expanded(
                                child: CommonTextBox(
                                  controller: groupCtrl.txtGroupName,
                                  labelText: fonts.groupName.tr,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Group Name Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  maxLength: 25,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: appCtrl.appTheme.blackColor)),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const VSpace(Sizes.s20),
                          /*CommonButton(
                              title: fonts.create.tr,
                              height: 100,
                              width: 100,
                              padding: Insets.i20,
                              style: AppCss.poppinsMedium14
                                  .textColor(appCtrl.appTheme.whiteColor),
                              margin: 0,
                              onTap: () =>
                                  GroupFirebaseApi().createGroup(groupCtrl))*/
                          SmoothContainer(
                           padding: const EdgeInsets.symmetric(vertical: 15),
                              width:250,
                              smoothness: 1,
                              color:  appCtrl.appTheme.primary,
                              margin: const EdgeInsets.symmetric(horizontal: 200,),
                              borderRadius: BorderRadius.circular(12),
                              alignment: Alignment.center,
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                                Text(groupCtrl.isLoading ? "Loading..." :  fonts.create.tr, textAlign: TextAlign.center, style: AppCss.poppinsMedium14
                                    .textColor(appCtrl.appTheme.whiteColor))
                              ])).inkWell(onTap: () =>
                              GroupFirebaseApi().createGroup(groupCtrl))
                        ]),
                  )),
            );
          });
        }
      );
    });
  }
}
