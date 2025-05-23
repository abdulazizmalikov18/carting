import 'dart:ui';

import 'package:carting/infrastructure/core/exceptions/failures.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/assets/constants/app_constants.dart';
import 'package:carting/assets/constants/storage_keys.dart';
import 'package:carting/data/models/send_code_body.dart';
import 'package:carting/data/models/send_code_model.dart';
import 'package:carting/data/models/user_model.dart';
import 'package:carting/data/models/user_update_model.dart';
import 'package:carting/data/models/verify_body.dart';
import 'package:carting/infrastructure/repo/auth_repo.dart';
import 'package:carting/infrastructure/repo/storage_repository.dart';
import 'package:carting/utils/log_service.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sms_autofill/sms_autofill.dart';

part 'auth_event.dart';
part 'auth_state.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  loading,
  cancelLoading,
}

Future<bool> isInternetConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi) ||
      connectivityResult.contains(ConnectivityResult.ethernet) ||
      connectivityResult.contains(ConnectivityResult.vpn) ||
      connectivityResult.contains(ConnectivityResult.bluetooth) &&
          await InternetConnectionChecker.instance.hasConnection) {
    return true; // Connected to mobile data or Wi-Fi
  } else {
    return false; // Not connected to the internet
  }
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _repository;
  AuthBloc(this._repository) : super(const AuthState()) {
    on<RefreshToken>((event, emit) async {
      final result = await _repository.refreshToken();
      if (result.isRight) {
        add(GetMeEvent());
      } else {
        add(LogOutEvent());
      }
    });

    on<RegisterUserEvent>((event, emit) async {
      emit(state.copyWith(statusSms: FormzSubmissionStatus.inProgress));
      final result = await _repository.registerPost(UserUpdateModel(
        firstName: event.name,
        lastName: event.lastName,
        userType: event.isUser ? 'LEGAL' : 'PHYSICAL',
        phoneNumber: event.phone,
        tgLink: AppConstants.tgLink,
        base64: AppConstants.image,
        mail: event.phone,
      ));
      if (result.isRight) {
        add(GetMeEvent());
      } else {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(state.copyWith(
        statusSms: FormzSubmissionStatus.inProgress,
        status: AuthenticationStatus.loading,
      ));
      final response = await _repository.userUpdate(
        UserUpdateModel(
          firstName: event.name ?? state.userModel.firstName,
          lastName: event.lastName ?? state.userModel.lastName,
          userType: event.userType ??
              (state.userModel.type.isEmpty
                  ? "PHYSICAL"
                  : state.userModel.type),
          phoneNumber: event.phone ?? state.userModel.phoneNumber,
          tgLink: event.tgName,
          base64: event.images,
          mail: event.email,
          securityCode: event.securityCode,
          sessionToken: event.sessionToken,
          smsType: event.securityCode != null
              ? event.isEmail
                  ? 'mail'
                  : 'phone'
              : null,
          tin: event.tin != null ? int.tryParse(event.tin ?? '') : null,
          callPhone: event.callPhone,
          orgName: event.orgName ?? '',
          referredBy: event.referredBy ?? state.userModel.referredBy,
        ),
      );
      if (response.isRight) {
        emit(state.copyWith(
          statusSms: FormzSubmissionStatus.inProgress,
          status: AuthenticationStatus.loading,
        ));
        event.onSucces();
        add(GetMeEvent(isNotAuth: event.sessionToken?.isEmpty ?? true));
      } else {
        if (response.isLeft) {
          if (response.left is ServerFailure) {
            final stim = (response.left as ServerFailure).errorMessage.isEmpty
                ? (response.left as ServerFailure).statusCode.toString()
                : (response.left as ServerFailure).errorMessage;
            event.onError(stim);
          } else {
            event.onError("Ma'lumot topilmadi");
          }
        }
        emit(state.copyWith(statusSms: FormzSubmissionStatus.failure));
      }
    });
    on<CheckUserEvent>((event, emit) {
      final token = StorageRepository.getString(StorageKeys.TOKEN);
      if (token.isEmpty) {
        emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      } else {
        add(GetMeEvent());
      }
    });

    on<SendCodeEvent>((event, emit) async {
      emit(state.copyWith(
        statusSms: FormzSubmissionStatus.inProgress,
        status: AuthenticationStatus.loading,
      ));
      final appSignature = await SmsAutoFill().getAppSignature;
      final response = await _repository.sendCode(
        SendCodeBody(
          mail: event.isPhone ? null : event.phone,
          phoneNumber: event.isPhone ? event.phone : null,
          smsType: event.isPhone ? "phone" : "mail",
          type: event.isLogin ? 1 : 2,
          hash: appSignature,
        ),
      );
      if (response.isRight) {
        emit(state.copyWith(
          statusSms: FormzSubmissionStatus.success,
          status: AuthenticationStatus.loading,
        ));
        event.onSucces(response.right.data);
      } else {
        emit(state.copyWith(
          statusSms: FormzSubmissionStatus.failure,
          status: AuthenticationStatus.loading,
        ));
        if (response.isLeft) {
          if (response.left is ServerFailure) {
            final stim = (response.left as ServerFailure).errorMessage;
            event.onError(stim);
          } else {
            event.onError("Ma'lumot topilmadi");
          }
        }
      }
    });

    on<VerifyEvent>((event, emit) async {
      emit(state.copyWith(statusSms: FormzSubmissionStatus.inProgress));
      final response = await _repository.verifyPost(
        VerifyBody(
          mail: event.isPhone ? null : event.phone,
          phoneNumber: event.isPhone ? event.phone : null,
          smsType: event.isPhone ? "phone" : "mail",
          sessionToken: event.sessionToken,
          securityCode: event.securityCode,
        ),
      );
      if (response.isRight) {
        emit(state.copyWith(statusSms: FormzSubmissionStatus.success));
        if (event.isLogin) {
          add(GetMeEvent());
        } else {
          event.onSucces();
        }
      } else {
        emit(state.copyWith(statusSms: FormzSubmissionStatus.failure));
        if (response.isLeft) {
          if (response.left is ServerFailure) {
            final stim = (response.left as ServerFailure).errorMessage;
            event.onError(stim);
          } else {
            event.onError("Ma'lumot topilmadi");
          }
        }
      }
    });

    on<UpdateCode>((event, emit) async {
      List<ReferralCode> data =
          List<ReferralCode>.from(state.userModel.referralCodes);
      final index = data.indexWhere((element) => element.code == event.code);
      if (event.note != null) {
        data[index] = ReferralCode(
          code: event.code,
          note: event.note ?? "",
        );
      } else {
        data.removeAt(index);
      }
      final userModel = state.userModel.copyWith(referralCodes: data);
      emit(state.copyWith(
        userModel: userModel,
        statusSms: FormzSubmissionStatus.initial,
      ));
    });

    on<GetMeEvent>((event, emit) async {
      emit(state.copyWith(statusSms: FormzSubmissionStatus.inProgress));
      final response = await _repository.getMe();
      if (response.isRight) {
        emit(state.copyWith(
          userModel: response.right.data,
          statusSms: FormzSubmissionStatus.success,
          status: event.isNotAuth
              ? state.status
              : AuthenticationStatus.authenticated,
          isState: event.isNotAuth ? state.isState : !state.isState,
        ));
        Log.i("Salom Loginga kirdik holat ${state.status}");
      } else {
        emit(state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          statusSms: FormzSubmissionStatus.failure,
        ));
      }
    });

    on<LogOutEvent>((event, emit) async {
      emit(state.copyWith(statusSms: FormzSubmissionStatus.inProgress));
      await StorageRepository.putString(StorageKeys.TOKEN, "");
      await StorageRepository.putString(StorageKeys.REFRESH, "");
      await StorageRepository.putBool(StorageKeys.LENDING, true);
      emit(state.copyWith(
        statusSms: FormzSubmissionStatus.success,
        status: AuthenticationStatus.unauthenticated,
        userModel: const UserModel(),
      ));
    });
  }
}
