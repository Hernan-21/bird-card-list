require "uri"
require "net/http"

url = URI("https://aves.ninjas.cl/api/birds")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)
puts response.read_body


require "uri"
require "net/http"
require "json"

url = URI("https://aves.ninjas.cl/api/birds")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)

birds = JSON.parse(response.read_body) #el parse es para convertir el JSON en un array de hashes? preguntar si es correcta la analogia

sorted_birds = birds.sort_by { |bird| bird["name"]["spanish"] }

sorted_birds.each do |bird|
  puts "Nombre: #{bird["name"]["spanish"]}"
  puts "Nombre científico: #{bird["name"]["latin"]}"
  puts "Titulo: #{bird["title"]}"
  puts "Sort: #{bird["sort"]}"
  puts "-" * 40
end


html_content = <<~HTML
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aves de Chile</title>
    <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      background-color: #f9f9f9;
      display: flex;
      flex-direction: column;
      align-items: center;
  }
    .card-container{
    display: flex;
    max-width: 1200px;
    width: 100%;
    flex-wrap: wrap;
    justify-content: center;
  }
  .card-container .card {
      background-color: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      margin: 10px;
      width: 300px;
      transition: transform 0.2s ease;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      align-items: center;
  }
  .card:hover {
      transform: translateY(-5px);
  }
  .card img {
      width: 100%;
      object-fit: cover;
      border-bottom: 1px solid #ddd;
  }
  .card-content {
      padding: 20px;
  }
  .card-content h3 {
      margin-top: 0;
      margin-bottom: 10px;
      color: #333;
  }
  .card-content p {
      margin: 5px 0;
      color: #666;
  }
  .card-content p span {
      font-weight: bold;
      color: #333;
  }
  .footer {
      margin-top: 20px;
      text-align: center;
      font-size: 14px;
      color: #888;
  }

  @media (max-width: 768px) {
      .card {
          width: 100%;
          margin: 10px 0;
      }
  }

  @media (max-width: 480px) {
      body {
          margin: 10px;
      }
      .container {
          padding: 0;
      }
  }
    </style>
</head>
<body>
    <h1>Aves de Chile</h1>
    <div class="card-container">
HTML

sorted_birds.each do |bird|
  image_url = bird.dig("images", "thumb") || "https://via.placeholder.com/300x200?text=Imagen+no+disponible"
  html_content += <<~HTML
        <div class="card">
            <img src="#{image_url}" alt="Imagen de">
            <div class="card-content">
                <h3>#{bird["name"]["spanish"]}</h3>
                <p><span>Nombre Científico:</span> #{bird["name"]["latin"]}</p>
            </div>
          </div>
          HTML
        end

        html_content += <<~HTML
        </div>
        </body>
</html>
HTML

File.open("aves_chile.html", "w") do |file|
  file.write(html_content)
end

puts "Archivo HTML generado: aves_chile.html"
