import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:procrew_task_fin/data/models/user.dart';
import 'package:procrew_task_fin/data/repository/auth_repository.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.loginWithEmailAndPassword(email, password);
      User? currentUser = _authRepository.currentUser();
      if (currentUser != null) {
        emit(Authenticated(currentUser));
      } else {
        emit(NotAuthenticated());
      }
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authRepository.registerWithEmailAndPassword(email, password);
      User? currentUser = _authRepository.currentUser();
      emit(Authenticated(currentUser!));
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future signInWithGoogle() async {
    try {
      emit(AuthLoading());
      await _authRepository.signInWithGoogle();
      User? currentUser = _authRepository.currentUser();
      emit(Authenticated(currentUser!));
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future signInWithFacebook() async {
    try {
      emit(AuthLoading());
      await _authRepository.signInWithFacebook();
      User? currentUser = _authRepository.currentUser();
      emit(Authenticated(currentUser!));
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future signInWithTwitter() async {
    try {
      emit(AuthLoading());
      await _authRepository.signInWithTwitter();
      User? currentUser = _authRepository.currentUser();
      emit(Authenticated(currentUser!));
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }



  Future logout() async {
    try {
      emit(AuthLoading());
      await _authRepository.logout();
      emit(NotAuthenticated());
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }
}
