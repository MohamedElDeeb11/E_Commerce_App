import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_store/core/usecases/usecase.dart';
import 'package:t_store/features/personalization/domain/usecases/get_profile_usecase.dart';
import 'package:t_store/features/personalization/domain/usecases/update_profile_usecase.dart';
import 'package:t_store/features/personalization/domain/usecases/upload_avatar_usecase.dart';
import 'package:t_store/features/personalization/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  final UploadAvatarUsecase uploadAvatarUsecase;

  ProfileCubit({
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
    required this.uploadAvatarUsecase,
  }) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    var result = await getProfileUsecase(const NoParams());

    if (result.isLeft()) {
      await Future.delayed(const Duration(milliseconds: 800));
      result = await getProfileUsecase(const NoParams());
    }
    // ignore_for_file: avoid_print
    result.fold(
      (error) {
        print('PROFILE ERROR: $error');
        emit(ProfileError(error));
      },
      (user) {
        print('===== PROFILE LOADED =====');
        print('User ID: ${user.id}');
        print('Full Name: ${user.fullName}');
        print('Avatar URL: ${user.avatarUrl}');
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
  }) async {
    emit(ProfileUpdating());

    final result = await updateProfileUsecase(UpdateProfileParams(
      fullName: fullName,
      phone: phone,
    ));

    result.fold(
      (error) => emit(ProfileError(error)),
      (user) {
        emit(ProfileUpdated(user));
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> uploadAvatar(File imageFile) async {
    emit(AvatarUploading());

    print('===== START UPLOADING AVATAR =====');
    print('File path: ${imageFile.path}');

    final result = await uploadAvatarUsecase(imageFile);

    result.fold(
      (error) {
        print('===== AVATAR UPLOAD ERROR =====');
        print(error);
        emit(ProfileError(error));
      },
      (avatarUrl) async {
        print('===== AVATAR UPLOADED SUCCESSFULLY =====');
        print('New Avatar URL: $avatarUrl');
        await getProfile();
      },
    );
  }
}