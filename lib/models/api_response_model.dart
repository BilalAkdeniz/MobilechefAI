class ApiResponseModel {
  final bool success;
  final String message;
  final dynamic data;

  const ApiResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponseModel.success({
    String message = 'İşlem başarılı',
    dynamic data,
  }) {
    return ApiResponseModel(
      success: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponseModel.error({
    String message = 'Bir hata oluştu',
    dynamic data,
  }) {
    return ApiResponseModel(
      success: false,
      message: message,
      data: data,
    );
  }

  factory ApiResponseModel.fromMap(Map<String, dynamic> map) {
    return ApiResponseModel(
      success: map['success'] as bool? ?? false,
      message: map['message'] as String? ?? '',
      data: map['data'],
    );
  }

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }

  /// JSON'a dönüştürme
  Map<String, dynamic> toJson() => toMap();

  ApiResponseModel copyWith({
    bool? success,
    String? message,
    dynamic data,
  }) {
    return ApiResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiResponseModel &&
        other.success == success &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;

  @override
  String toString() =>
      'ApiResponseModel(success: $success, message: $message, data: $data)';
}
