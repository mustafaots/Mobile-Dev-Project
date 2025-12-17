import 'package:bloc/bloc.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/Confirm%20Listing/PostCreationService.dart';
import 'package:flutter/material.dart';

// States
abstract class ConfirmListingState {
  final bool agreedCheck;
  final bool isCreating;

  const ConfirmListingState({
    required this.agreedCheck,
    required this.isCreating,
  });
}

class ConfirmListingInitial extends ConfirmListingState {
  const ConfirmListingInitial() : super(agreedCheck: false, isCreating: false);
}

class ConfirmListingUpdated extends ConfirmListingState {
  const ConfirmListingUpdated({
    required super.agreedCheck,
    required super.isCreating,
  });
}

class ConfirmListingSuccess extends ConfirmListingState {
  const ConfirmListingSuccess({
    required super.agreedCheck,
    required super.isCreating,
  });
}

class ConfirmListingError extends ConfirmListingState {
  final String message;

  const ConfirmListingError({
    required super.agreedCheck,
    required super.isCreating,
    required this.message,
  });
}

// Cubit
class ConfirmListingCubit extends Cubit<ConfirmListingState> {
  final PostCreationService _postCreationService = PostCreationService();

  ConfirmListingCubit() : super(const ConfirmListingInitial());

  void toggleAgreement(bool value) {
    emit(ConfirmListingUpdated(
      agreedCheck: value,
      isCreating: state.isCreating,
    ));
  }

  Future<void> createPost({
    required int userId,
    required CreatePostData postData,
    required BuildContext context,
  }) async {
    if (!state.agreedCheck || state.isCreating) return;

    // Set creating state
    emit(ConfirmListingUpdated(
      agreedCheck: state.agreedCheck,
      isCreating: true,
    ));

    try {
      final success = await _postCreationService.createPost(
        userId: userId,
        postData: postData,
        context: context,
      );

      if (success) {
        emit(ConfirmListingSuccess(
          agreedCheck: state.agreedCheck,
          isCreating: false,
        ));
      } else {
        emit(ConfirmListingError(
          agreedCheck: state.agreedCheck,
          isCreating: false,
          message: 'Failed to create post',
        ));
      }
    } catch (e) {
      emit(ConfirmListingError(
        agreedCheck: state.agreedCheck,
        isCreating: false,
        message: e.toString(),
      ));
    }
  }
}