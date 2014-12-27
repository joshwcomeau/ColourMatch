class Photo::SaveToDb
  def self.call(p)
    Photo.create(
      px_id:              p['id'],
      px_image:           p['image_url'],
      px_name:            p['name'],
      px_description:     p['description'],
      px_category:        p['category'],
      px_user:            p['user'],
      px_rating:          p['rating'],
      px_status:          p['status'],
      px_for_sale:        p['for_sale'],
      px_store_download:  p['store_download'],
      px_license_type:    p['license_type'],
      px_privacy:         p['privacy'],
      px_link:            p['url']
    )
  end
end