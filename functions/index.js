const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Hardcoded for testing. Best practice is to use Secret Manager in production.
const GEMINI_API_KEY = "AIzaSyCD-iXomIHpe0KfnRms3JKfzSOm3MLLmyw";

const SYSTEM_PROMPT = "You are a calm, supportive mental health assistant. Provide safe, non-medical guidance. Keep your responses concise and supportive.";

exports.chatWithGemini = onCall({
    region: "asia-east1",
    cors: true
}, async (request) => {
    // 1. Ensure user is authenticated
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'The function must be called while authenticated.');
    }

    const { message, previousMessages } = request.data;

    if (!message || typeof message !== 'string') {
        throw new HttpsError('invalid-argument', 'The function must be called with a "message" argument.');
    }

    try {
        const ai = new GoogleGenerativeAI(GEMINI_API_KEY);
        const model = ai.getGenerativeModel({ model: "gemini-2.5-flash" });
        
        let promptText = `${SYSTEM_PROMPT}\n\n`;
        
        if (previousMessages && previousMessages.length > 0) {
            promptText += "Here is the conversation history:\n";
            previousMessages.forEach(msg => {
                promptText += `${msg.sender.toUpperCase()}: ${msg.text}\n`;
            });
            promptText += "\nNow, please respond to the following:\n";
        }
        
        promptText += `USER: ${message}\nAI:`;

        const response = await model.generateContent(promptText);

        return {
            reply: response.response.text(),
        };

    } catch (error) {
        console.error("Error calling Gemini:", error);
        throw new HttpsError('internal', 'An error occurred while generating the response.');
    }
});
