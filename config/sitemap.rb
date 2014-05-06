SitemapGenerator::Sitemap.default_host = ENV['SITEMAP_DEFAULT_HOST']
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: :always, lastmod: Availability.last.updated_at
  add parkings_path, changefreq: :always, lastmod: Availability.last.updated_at
  add info_path, changefreq: :weekly

  Parking.all.each do |parking|
    add parking_path(parking), changefreq: :always, lastmod: parking.availabilities.last.updated_at
  end
end
