import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  File? _selectedImage;
  String? _currentAvatarUrl;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isLoading = true;
      });

      try {
        final userId = Supabase.instance.client.auth.currentUser!.id;
        final fileName = 'avatar_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await Supabase.instance.client.storage
            .from('avatars')
            .upload(fileName, _selectedImage!, fileOptions: const FileOptions(upsert: true));

        final imageUrl = Supabase.instance.client.storage.from('avatars').getPublicUrl(fileName);

        await Supabase.instance.client
            .from('profiles')
            .update({'avatar_url': imageUrl})
            .eq('id', userId);

        if (mounted) {
          setState(() {
            _currentAvatarUrl = imageUrl;
          });
          context.read<ProfileCubit>().getProfile();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الصورة بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ أثناء رفع الصورة: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showEditNameDialog(String currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعديل الاسم'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'أدخل الاسم الجديد',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final newName = nameController.text.trim();
              if (newName.isNotEmpty && newName != currentName) {
                setState(() => _isLoading = true);
                try {
                  final userId = Supabase.instance.client.auth.currentUser!.id;
                  await context.read<ProfileCubit>().updateProfile(fullName: newName);

                  await Supabase.instance.client
                      .from('profiles')
                      .update({'full_name': newName})
                      .eq('id', userId);

                  if (mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تحديث الاسم بنجاح!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('حدث خطأ أثناء التحديث: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: CustomAppBar(
        appBarModel: AppBarModel(
          title: Text("profile".tr(context)),
          hasArrowBack: true,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileError) {
                  // شكل بسيط لعرض رسالة الخطأ وزر إعادة المحاولة
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          Text(
                            state.message,
                            style: const TextStyle(color: TColors.error, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          ElevatedButton(
                            onPressed: () => context.read<ProfileCubit>().getProfile(),
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

                final String realName = user?.fullName ?? "User";
                final String realEmail = user?.email ?? "Not available";
                final String realId = user?.id ?? "No ID";
                final String realPhone = user?.phone ?? "No Phone";

                final String userAvatar = user?.avatarUrl ?? '';
                final String avatarUrl = _currentAvatarUrl ?? (userAvatar.isNotEmpty ? userAvatar : '');

                final List<ProfileEntityTileModel> profileInformation = [
                  ProfileEntityTileModel(
                    title: "name".tr(context),
                    value: realName,
                    onTap: () => _showEditNameDialog(realName),
                  ),
                  ProfileEntityTileModel(
                    title: "Username",
                    value: realEmail.split('@').first,
                    trailing: null,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('لا يمكن تعديل اسم المستخدم')),
                      );
                    },
                  ),
                ];

                final List<ProfileEntityTileModel> personalInformation = [
                  ProfileEntityTileModel(
                    trailing: Iconsax.copy,
                    title: "User ID",
                    value: realId,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: realId)).then((_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم نسخ الـ ID بنجاح!')),
                          );
                        }
                      });
                    },
                  ),
                  ProfileEntityTileModel(title: "Email", value: realEmail, trailing: null, onTap: () {}),
                  ProfileEntityTileModel(title: "Phone Number", value: realPhone.isNotEmpty ? realPhone : "غير مسجل", trailing: null, onTap: () {}),
                  ProfileEntityTileModel(title: "Gender", value: "Male", trailing: null, onTap: () {}),
                  ProfileEntityTileModel(title: "Date Of Birth", value: "13/01/2003", trailing: null, onTap: () {}),
                ];

                return RefreshIndicator(
                  color: TColors.primary,
                  backgroundColor: isDark ? TColors.darkContainer : Colors.white,
                  onRefresh: () async {
                    context.read<ProfileCubit>().getProfile();
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: _selectedImage != null
                                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                        : (avatarUrl.isNotEmpty
                                            ? Image.network(
                                                avatarUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.person, size: 40, color: Colors.grey),
                                                  );
                                                },
                                              )
                                            : Container(
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.person, size: 40, color: Colors.grey),
                                              )),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _pickImage,
                                  child: const Text(
                                    'Change Profile Picture',
                                    style: TextStyle(color: TColors.primary, fontWeight: FontWeight.w600),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.cardRadiusLg)),
                              ),
                              onPressed: () async {
                                await Supabase.instance.client.auth.signOut();
                                if (context.mounted) {
                                  THelperFunctions.navigateReplacementToScreen(context, const LoginView());
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Iconsax.logout, color: Colors.white, size: 20),
                                  SizedBox(width: TSizes.spaceBtwItems),
                                  Text('تسجيل الخروج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class SpaceBetweenSectionsWithDivider extends StatelessWidget {
  const SpaceBetweenSectionsWithDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: TSizes.spaceBtwItems / 1.5),
        Divider(),
        SizedBox(height: TSizes.spaceBtwItems / 1.5),
      ],
    );
  }
}
