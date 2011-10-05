require 'active_record'

module Murlsh

  # Build responses for HTTP requests.
  class UrlServer < Server

    # Respond to a GET request. Return a page of urls based on the query
    # string parameters.
    def get(req)
      page = [req['p'].to_i, 1].max
      per_page = req['pp'] ? req['pp'].to_i :
        config.fetch('num_posts_page', 25)

      content_type = 'text/html; charset=utf-8'
      result_set = Murlsh::UrlResultSet.new(req['q'], page, per_page)

      body = Murlsh::UrlBody.new(config, req, result_set, content_type)

      resp = build_response
      resp.write(body.build)
      resp['Content-Type'] = content_type

      resp
    end

    # Respond to a POST request. Add the new url and return json.
    def post(req)
      if user = auth_from_req(req)
        mu = Murlsh::Url.new do |u|
          u.url = req['url']
          u.email = user[:email]
          u.name = user[:name]

          # optional parameters
          unless req['thumbnail'].to_s.empty?
              u.thumbnail_url = req['thumbnail']
          end

          u.time = if req['time']
            Time.at(req['time'].to_f).utc
          else
            Time.now.utc
          end

          unless req['title'].to_s.empty?
            u.title = req['title']
            u.user_supplied_title = true
          end

          u.via = req['via']  unless req['via'].to_s.empty?
        end

        begin
          # validate before add_pre plugins have run and also after (in save!)
          raise ActiveRecord::RecordInvalid.new(mu)  unless mu.valid?
          Murlsh::Plugin.hooks('add_pre') { |p| p.run mu, config }
          mu.save!
          Murlsh::Plugin.hooks('add_post') { |p| p.run mu, config }
          response_body, response_code = [mu], 200
        rescue ActiveRecord::RecordInvalid => error
          response_body = {
            'url' => error.record,
            'errors' => error.record.errors,
            }
          response_code = 500
        end
      else
        response_body, response_code = '', 403
      end

      build_response response_body.to_json, response_code,
        'Content-Type' => 'application/json'
    end

    # Delete a url.
    def delete(req)
      response_body, response_code = '', 403

      url_id = req.path[%r{/url/(\d+)$}, 1]
      begin
        url = Murlsh::Url.find(url_id)
        if user = auth_from_req(req)
          if url[:email] == user[:email] or url[:name] == user[:name]
            url.destroy
            response_body, response_code = url.to_json, 200
          end
        end
      rescue ActiveRecord::RecordNotFound
        response_code = 404
      end

      build_response response_body, response_code,
        'Content-Type' => 'application/json'
    end

    # Authorize a user from a request.
    def auth_from_req(req)
      secret = req['auth']
 
      secret.to_s.empty? ? nil : Murlsh::Auth.new(
        config.fetch('auth_file')).auth(secret)
    end

  end

end
