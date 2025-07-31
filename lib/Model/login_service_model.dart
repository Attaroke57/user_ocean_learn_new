class LoginResponseModel {
  final bool status;
  final String message;
  final AccountInfo? accountInfo;
  

  LoginResponseModel({
    required this.status,
    required this.message,
    this.accountInfo,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      accountInfo: json['data'] != null
          ? AccountInfo.fromJson(json['data']['account_info'])
          : null,
    );
  }
}

class AccountInfo {
  final String name;
  final String email;
  final String role;
  final List<Token> tokens;
  final Map<String, dynamic>? subscription;

  AccountInfo({
    required this.name,
    required this.email,
    required this.role,
    required this.tokens,
    this.subscription,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      name: json['name'],
      email: json['email'],
      role: json['role'],
      tokens: List<Token>.from(json['token'].map((t) => Token.fromJson(t))),
      subscription: json['subscription'],
    );
  }
}

class Token {
  final String token;

  Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
}