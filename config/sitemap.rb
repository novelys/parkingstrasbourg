# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.parkings-strasbourg.eu"

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: :always, lastmod: Availability.last.updated_at
  add parkings_path, changefreq: :always, lastmod: Availability.last.updated_at
  add info_path, changefreq: :weekly

  Parking.all.each do |parking|
    add parking_path(parking), changefreq: :always, lastmod: parking.availabilities.last.updated_at
  end
end
