import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t_store/core/common/view_models/app_bar_view_model.dart';
import 'package:t_store/core/common/widgets/app_bar.dart';
import 'package:t_store/core/utils/constants/colors.dart';
import 'package:t_store/core/utils/constants/sizes.dart';
import 'package:t_store/core/utils/localizations/app_localizations.dart';
import 'package:t_store/core/utils/helpers/helper_functions.dart';
import 'package:t_store/features/personalization/presentation/cubit/profile_cubit.dart';
import 'package:t_store/features/personalization/presentation/cubit/profile_state.dart';
import 'package:t_store/features/personalization/presentation/view_models/profile_entity_tile_model.dart';
import 'package:t_store/features/personalization/presentation/widgets/personal_information_section.dart';
import 'package:t_store/features/personalization/presentation/widgets/profile_information_section.dart';
import 'package:t_store/core/dependency_injection/service_locator.dart';
import 'package:t_store/features/auth/presentation/views/login/login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..getProfile(),
      child: const ProfileViewBody(),
    );
  }
}

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  // متغير لحفظ الصورة المختارة من الموبايل
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // هنا لاحقاً تقدر تربطها بـ Cubit لرفع الصورة لـ Supabase Storage وتحديثها
      if (mounted) {
        THelperFunctions.showSnackBar(
          context: context,
          message: 'تم اختيار الصورة بنجاح!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseUser = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: CustomAppBar(
        appBarModel: AppBarModel(
          title: Text("profile".tr(context)),
          hasArrowBack: true,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: const TextStyle(color: TColors.error)),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginView()),
                          );
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final user = (state is ProfileLoaded)
                ? state.user
                : (state is ProfileUpdated)
                    ? state.user
                    : null;

            final String realName = user?.fullName ?? supabaseUser?.userMetadata?['full_name'] ?? supabaseUser?.email?.split('@').first ?? "User";
            final String realEmail = user?.email ?? supabaseUser?.email ?? "Not available";
            final String realId = user?.id ?? supabaseUser?.id ?? "No ID";
            final String realPhone = user?.phone ?? supabaseUser?.phone ?? "No Phone";

            final List<ProfileEntityTileModel> profileInformation = [
              ProfileEntityTileModel(
                title: "name".tr(context),
                value: realName,
                onTap: () {
                  THelperFunctions.showSnackBar(
                    context: context,
                    message: 'جارِ فتح شاشة تعديل الاسم...',
                  );
                },
              ),
              ProfileEntityTileModel(
                title: "Username",
                value: realEmail.split('@').first,
                onTap: () {
                  THelperFunctions.showSnackBar(
                    context: context,
                    message: 'جارِ فتح شاشة تعديل اسم المستخدم...',
                  );
                },
              ),
            ];
            
            final List<ProfileEntityTileModel> personalInformation = [
              ProfileEntityTileModel(
                trailing: Iconsax.copy,
                title: "User ID",
                value: realId,
                onTap: () {},
              ),
              ProfileEntityTileModel(
                title: "Email",
                value: realEmail,
                onTap: () {},
              ),
              ProfileEntityTileModel(
                title: "Phone Number",
                value: realPhone.isNotEmpty ? realPhone : "غير مسجل",
                onTap: () {},
              ),
              ProfileEntityTileModel(
                title: "Gender",
                value: "Male",
                onTap: () {},
              ),
              ProfileEntityTileModel(
                title: "Date Of Birth",
                value: "13/01/2003",
                onTap: () {},
              ),
            ];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  children: [
                    // صورة البروفايل مع إمكانية التعديل واختيار صورة من الموبايل
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : const NetworkImage(
                                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
                                  ),
                          ),
                          TextButton(
                            onPressed: _pickImage, // استدعاء دالة فتح المعرض واختيار الصورة
                            child: const Text(
                              'Change Profile Picture',
                              style: TextStyle(
                                color: TColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    ProfileInformationSection(profileInformation: profileInformation),
                    const SpaceBetweenSectionsWithDivider(),
                    PersonalInformationSection(personalInformation: personalInformation),
                    const SpaceBetweenSectionsWithDivider(),
                    
                    const SizedBox(height: TSizes.spaceBtwItems),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: TSizes.md, horizontal: TSizes.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                          ),
                        ),
                        onPressed: () async {
                          await Supabase.instance.client.auth.signOut();
                          
                          if (context.mounted) {
                            THelperFunctions.navigateReplacementToScreen(
                              context,
                              const LoginView(),
                            );
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Iconsax.logout, color: Colors.white, size: 20),
                            SizedBox(width: TSizes.spaceBtwItems),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SpaceBetweenSectionsWithDivider extends StatelessWidget {
  const SpaceBetweenSectionsWithDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),
        Divider(),
        SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),
      ],
    );
  }
}