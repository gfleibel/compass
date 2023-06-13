require 'net/http'
require 'uri'

class NsfwDetectionService
  def initialize(image_url)
    @image_url = image_url
    # "https://res.cloudinary.com/duomnddyc/image/upload/v1686681863/development/9fvb7uu1qlsfpkjo60a2gw7b5xib.jpg"
    # "http://res.cloudinary.com/duomnddyc/image/upload/v1/development/gseputawx0nqs9veyeku3swp1obx.jpeg"
  end

  Rails.application.config.api_key = 'c421317a4dmsh0290e6f7fab8b1ep189a92jsna807f15435cb'

  def detect_nsfw_content
    url = URI("https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/json'
    request["X-RapidAPI-Key"] = Rails.application.config.api_key
    request["X-RapidAPI-Host"] = 'nsfw-images-detection-and-classification.p.rapidapi.com'
    request.body = {
      url: @image_url
    }.to_json

    response = http.request(request)
    response.body

    # response.body contém o JSON retornado
    response_json = JSON.parse(response.body)

    # Acessa o valor da chave "unsafe"
    unsafe_value = response_json["unsafe"]
    return unsafe_value
  end
end
