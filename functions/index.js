const functions = require("firebase-functions");
const {Configuration, OpenAIApi} = require("openai");

const {defineSecret} = require("firebase-functions/params");
const openaiKey = defineSecret("OPEN_AI");
let openAi = null;

/**
 * Creates the OpenAI configuration
 */
function createConfig() {
  const configuration = new Configuration({
    apiKey: openaiKey.value(),
  });

  openAi = new OpenAIApi(configuration);
}

/**
 * @param {string} prompt text propmt for the gpt3 api
 * @return {Promise} GPT api response
 */
async function getGPT3Response(prompt) {
  const response = await openAi.createCompletion({
    model: "text-davinci-003",
    prompt: prompt,
    temperature: 0.7,
    max_tokens: 100,
    top_p: 1,
    frequency_penalty: 0,
    presence_penalty: 0,
  });
  return response;
}

/**
 * Create workout method. Checks authentication,
 * creates Open AI config and sends request.
 */
exports.createWorkout = functions
    .runWith({secrets: [openaiKey.name]})
    .https.onCall(async (data, context) => {
      if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError("failed-precondition",
            "The function must be called while authenticated.");
      }
      createConfig();

      const res = await getGPT3Response(data.text);
      return res.data;
    });
