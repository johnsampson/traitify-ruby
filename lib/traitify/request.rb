module Traitify
  module Request
    def method_missing(meth, *args, &block)
      if [:get, :post, :put, :delete].include? meth
        request(meth, *args)
      else
        super
      end
    end

    def request(method, path, options = {})
      begin
        conn(url: api_host).send(method) do |request|
          request.url [api_version, path].join
          request.body = options.to_json if options
        end.body
      rescue => e
        puts e.message
        { error: e.message }
      end
    end
  end
end
