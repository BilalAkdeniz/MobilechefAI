import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import '../../models/api_response_model.dart';

class GeminiService {
  final String apiKey;

  GeminiService({required this.apiKey});

  /// metin tabanlı tarif önerisi
  Future<ApiResponseModel> getRecipeSuggestions(String prompt) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        return ApiResponseModel(
          success: true,
          message: "Başarılı",
          data: jsonDecode(response.body),
        );
      } else {
        return ApiResponseModel(
          success: false,
          message: "API hatası: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(success: false, message: e.toString());
    }
  }

  /// Fotoğraf gönderip malzeme tespiti
  Future<ApiResponseModel> analyzeImage(File imageFile) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey",
    );

    try {
      final bytes = await imageFile.readAsBytes();
      final mimeType =
          lookupMimeType(p.basename(imageFile.path)) ?? "image/jpeg";

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "inline_data": {
                    "mime_type": mimeType,
                    "data": base64Encode(bytes),
                  }
                },
                {
                  "text":
                      "Bu fotoğraftaki yiyecek veya yemek malzemelerini listele. Sadece malzeme isimlerini ver, açıklama yapma."
                }
              ],
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        return ApiResponseModel(
          success: true,
          message: "Başarılı",
          data: jsonDecode(response.body),
        );
      } else {
        return ApiResponseModel(
          success: false,
          message: "API hatası: ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResponseModel(success: false, message: e.toString());
    }
  }
}
