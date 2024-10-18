import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/club_account_validation_state.dart';

final clubAccountValidationProvider =
    StateProvider<ClubAccountValidationState>((ref) => ClubAccountValidationState.notChecked);
