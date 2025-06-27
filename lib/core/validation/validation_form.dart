class ValidationForm {
  String? validateEmail(String? value) {
    // 이메일 유효성 검사
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return '유효한 이메일 형식이 아닙니다.';
    }
    return null;
  }

  String? validateName(String? value) {
    // 이름이 null이 아니어야함
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    // 비밀번호 유효성 검사
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (value.length < 8) {
      return '비밀번호는 8자 이상이어야 합니다.';
    }
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!%*#?&]').hasMatch(value);

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return '비밀번호는 영문자, 숫자, 특수문자(!%*#?&)를 각각 1개 이상 포함해야 합니다.';
    }
    return null;
  }

  String? validatePasswordConfirmation(String? value, String password) {
    // 비밀번호 확인
    if (value != password) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }
}
