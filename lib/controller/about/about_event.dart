part of 'about_bloc.dart';

@freezed
class AboutEvent with _$AboutEvent {
  const factory AboutEvent.started() = _Started;
  const factory AboutEvent.aboutUs() = _AboutUs;
}
