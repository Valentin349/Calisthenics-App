import functions from "firebase-functions";
import { Configuration, OpenAIApi } from "openai";


const configuration = new Configuration({
  apiKey: functions.config().openai.secret,
});
const openAi = new OpenAIApi(configuration);

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
