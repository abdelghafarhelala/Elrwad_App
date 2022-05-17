import 'package:alrwad/appCubit/app_cubit.dart';
import 'package:alrwad/appCubit/app_states.dart';
import 'package:alrwad/components/components.dart';
import 'package:alrwad/models/categoryModel/categoryModel.dart';
import 'package:alrwad/models/doctorsModel/doctorsModel.dart';
import 'package:alrwad/modules/bookingScreen%20copy/bookingScreen.dart';
import 'package:alrwad/modules/bookingScreen/bookingScreen.dart';
import 'package:alrwad/modules/myDrawer/myDrawer.dart';
import 'package:alrwad/network/endpoints.dart';
import 'package:alrwad/shared/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DoctorsScreen extends StatelessWidget {
  // const DoctorsScreen({Key? key, this.catId}) : super(key: key);
  final int? catId;
  final Data? catdata;
  // String userName;
  DoctorsScreen({
    Key? key,
    this.catId,
    this.catdata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var data = AppCubit.get(context).doctors;
        // List doctors = [];
        // data!.results!.forEach((element) {
        //   if (element.categoryId == catId) {
        //     doctors.addAll(element.);
        //   }
        // });
        print(AppCubit.get(context).doctorsData.length);

        return Scaffold(
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const MyDrawer(),
                  const MyDrawer().myDrawerList(context),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: const Text('الاطباء'),
            actions: [
              const Center(
                child: Text(
                  'الوضع',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              FlutterSwitch(
                inactiveColor: Colors.white,
                inactiveToggleColor: Colors.grey,
                activeColor: primaryColor,
                activeText: 'Dark',
                height: 25,
                width: 50,
                activeTextColor: Colors.white,
                value: AppCubit.get(context).isDark,
                onToggle: (value) {
                  AppCubit.get(context).changeAppTheme();
                },
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetDoctorsLoadingState,
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
            builder: (context) => ListView.separated(
              itemBuilder: (context, index) {
                return buildDoctorItem(
                  context,
                  AppCubit.get(context).doctorsData[index],
                  catdata,
                );
              },
              itemCount: AppCubit.get(context).doctorsData.length,
              separatorBuilder: (context, index) => const SizedBox(),
            ),
          ),
        );
      },
    );
  }
}

Widget buildDoctorItem(context, Results data, Data? cDate) => InkWell(
      onTap: () {
        navigateTo(
            context,
            BookingScreenDrawer(
              categoryData: cDate,
              doctorData: data,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 7,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.img != null)
                  Image(
                    image: NetworkImage((imagesLink + data.img!)),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 160,
                  ),
                if (data.img == null)
                  const Image(
                    image: AssetImage('assets/images/doctor2.jpg'),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 120,
                  ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name!,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: primaryColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data.jobTitle!,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.watch_later_outlined,
                            color: primaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            data.appointments!,
                            style: Theme.of(context).textTheme.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
