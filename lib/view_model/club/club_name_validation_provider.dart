import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woohakdong/view_model/club/components/club_name_validation_state.dart';

final clubNameValidationProvider = StateProvider<ClubNameValidationState>((ref) => ClubNameValidationState.notChecked);
