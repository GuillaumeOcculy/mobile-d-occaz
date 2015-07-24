xml.instruct! :xml, :version =>"1.0" 
xml.instruct! 'xml-stylesheet', { :href => '/sitemap.xsl', :type => "text/xsl"}
xml.urlset(:xmlns =>'http://www.sitemaps.org/schemas/sitemap/0.9') {

    xml.url {
      xml.loc(root_url)
      xml.changefreq("daily")
      xml.priority("1.0")
    }
	
    xml.url {
      xml.loc(contact_url)
      xml.changefreq("monthly")
      xml.priority("0.2")
    }	
		
	for page in @pages
		xml.url {
			xml.loc(url_for(controller: :home, action: page.str_key, only_path: false))
			xml.changefreq("monthly")
			xml.priority("0.2")
			xml.lastmod(page.updated_at.strftime('%Y-%m-%d'))
		}
	end
	
	for post in @posts
		xml.url {
			xml.loc(post_url(post))
			xml.changefreq("monthly")
			xml.priority("0.4")
			xml.lastmod(post.updated_at.strftime('%Y-%m-%d'))
		}
	end		
	
}
