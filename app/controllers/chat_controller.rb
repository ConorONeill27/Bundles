require "rest_client"
require "json"

class ChatController < ApplicationController
  GEMINI_API_KEY = "AIzaSyDaaAvKB8P-k3f7f_Qi29kx58PNCAxmGSI"
  GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

  def index
    # Renders chat/index.html.erb
  end

  def message
    prompt = params[:message] || "Hello!"
    begin
      response = RestClient.post GEMINI_API_URL, { contents: [{ role: "user", parts: [{ text: prompt }] }] }.to_json, { content_type: :json, accept: :json, "x-goog-api-key": GEMINI_API_KEY }
      reply = JSON.parse(response.body).dig("candidates", 0, "content", "parts", 0, "text") || "No response generated"
      render json: { reply: reply }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_content
    end
  end

  def summarize_documents
    notes =
      @current_user
        &.organizations
        &.includes(:notes)
        &.flat_map(&:notes)
        &.uniq
        &.map(&:body)
        &.join(" ")

    begin
      user_question = params[:prompt] || "What information would you like to know?"
      
      response = RestClient.post GEMINI_API_URL, { 
        contents: [
          {
            role: "user",
            parts: [{
              text: "You are an AI assistant that answers questions based on the following notes. " \
                    "You are allowed to engage in basic conversation. Here are the notes:\n\n" \
                    "#{notes}\n\n" \
                    "Question: #{user_question}\n" \
                    "Answer:"
            }]
          }
        ]
      }.to_json, { 
        content_type: :json, 
        accept: :json, 
        "x-goog-api-key": GEMINI_API_KEY 
      }
      
      summary = JSON.parse(response.body).dig("candidates", 0, "content", "parts", 0, "text") || "No summary generated"
      render json: { summary: summary }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_content
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:prompt)
  end
end
