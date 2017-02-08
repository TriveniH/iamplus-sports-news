module XMLparser
	def XMLparser.make_api_request_generic_for_sportdirect(url, action, domain, route)
		response_back = nil
		ZipkinTracer::TraceClient.local_component_span( "External API Call to #{ self }" ) do | ztc |
			api_request_time = Benchmark.realtime do
	 			request = APIRequest.new( :generic, domain )
				puts "url::"+ url.to_s
				response = request.for( :get, url, '')
				response_back =  process_xml_response response.body.to_s
			end
		end
		return response_back
	end

	def XMLparser.process_xml_response_for_articleIds response

		doc = Nokogiri::XML(response)
		doc.remove_namespaces!
		title_list = []
		entries = doc.xpath('//entry')
		entries.each do |entry|
			title = entry.xpath('title').text.to_s
			title_list << title
		end
		puts "title_list::"+ title_list.to_s
		title_list
	end

	def XMLparser.process_xml_response_for_detailed_article response
		if response == nil || response.length == 0
			return nil
		end
		doc = Nokogiri::XML(response)
		doc.remove_namespaces!
		puts "doc::"+ doc.to_s
		articles = doc.xpath('//article')
		preview_list = articles.map do |article|

			articleId = article.xpath('id').text.to_s
			articleId = articleId.split(':')[1]

			title = article.xpath('title').text.to_s
			title.delete!("\n")
			source = article.xpath('source').text.to_s
			source.delete!("\n")
			author = article.xpath('author').text.to_s
			author.delete!("\n")
			date = article.xpath('date').text.to_s
			synopsis = article.xpath('synopsis').text.to_s
			synopsis.delete!("\n")
			content = process_html_article_content article.xpath('body').text

			competition = article.xpath('//competition')
			competitionId = competition.xpath('id').text.to_s
			competitionId = competitionId.split(':')[1]

			startDate = competition.xpath('start-date').text.to_s
			puts "articleId = "+articleId
			puts "title = "+title
			puts "source = "+source
			puts "author = "+author
			puts "synopsis:"+ synopsis
			puts "date = "+date
			puts "competitionId = "+competitionId
			puts "startDate = "+startDate
			puts "content = "+ content

			{
				competition_id: competitionId,
				article_id: articleId,
				title: title,
				source: source,
				author: author,
				competition_date: startDate,
				published_date: date,
				synopsis: synopsis,
				body: content,
			}
		end
		puts "preview_list::"+ preview_list.to_s
		preview_list.to_json

	end

	def XMLparser.process_html_article_content content
		Nokogiri::HTML(content).text
	end
end