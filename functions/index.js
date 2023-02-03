const functions = require("firebase-functions");
const {Configuration, OpenAIApi} = require("openai");


const configuration = new Configuration({
  apiKey: process.env.OPENAIKEY,
});
const openAi = new OpenAIApi(configuration);

/**
 * @return {Promise} gpt response
 */
async function getGPT3Response() {
  const response = await openAi.createCompletion({
    model: "text-davinci-003",
    prompt: "say this is a test",
    temperature: 0.7,
    max_tokens: 100,
    top_p: 1,
    frequency_penalty: 0,
    presence_penalty: 0,
  });
  return response;
}

/**
 * @return {Promise} gpt response
 */
exports.createWorkout = functions.https.onCall(async (_data, _) => {
  return await getGPT3Response();
});
