require 'json'

class ChatGpt
  def self.qa_request(question)
    question = question.gsub("\n", "。").gsub('\'','&apos;')
    response = `curl https://openai.api2d.net/v1/chat/completions \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer fk206049-7B8UcRBd270yQnpukHFZlSf1mkXXmxw9' \
    -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "#{question}"}]
  }'`
    response=='' ? (raise "URL request error!") : JSON::parse(response)
  end

  def self.generate_image(question)
    response = `curl --location --request POST 'https://oa.api2d.net/v1/images/generations' \
    --header 'Authorization: Bearer fk206049-7B8UcRBd270yQnpukHFZlSf1mkXXmxw9' \
    --header 'User-Agent: Apifox/1.0.0 (https://apifox.com)' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "prompt": "#{question}",
        "response_format": "url",
        "size": "256x256"
    }'`
    response=='' ? (raise "URL request error!") : JSON::parse(response)
  end
end