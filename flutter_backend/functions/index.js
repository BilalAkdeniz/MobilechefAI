const functions = require('firebase-functions');
const { GoogleGenerativeAI } = require('@google/generative-ai');

// Çevre değişkenini oku
const geminiApiKey = functions.config().gemini.key;
const genAI = new GoogleGenerativeAI(geminiApiKey);

exports.generateRecipe = functions.https.onCall(async (data, context) => {
    // Giriş verilerini al
    const { imageBase64, userText } = data;

    try {
        const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash-lite" });

        // API'a gönderilecek veriyi hazırla (fotoğraf ve metin)
        const prompt = "Aşağıdaki malzemelerle yapılabilecek yemek tarifleri öner.";
        const image = {
            inlineData: {
                data: imageBase64,
                mimeType: "image/jpeg" // veya diğer formatlar
            }
        };
        const parts = [prompt, image, userText];

        // API çağrısını yap
        const result = await model.generateContent({ contents: [{ parts }] });
        const response = await result.response;
        const text = response.text();

        return { success: true, recipe: text };
    } catch (error) {
        console.error("Gemini API hatası:", error);
        return { success: false, error: "Bir hata oluştu. Lütfen tekrar deneyin." };
    }
});