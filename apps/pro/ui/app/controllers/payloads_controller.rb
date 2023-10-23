# 
# The PayloadsController serves JSON information about the payloads
# back to the client-side javascript code.
#

class PayloadsController < ApplicationController

  # Static payload data is fetched over RPC and cached for this amount of time
  CACHE_EXPIRATION = 2.hours

  def index
    serve_json("payloads_json") do
      Pro::Client.get.module_details('payload')['modules'].values.to_json
    end
  end

  def encoders
    serve_json('encoders_json') do
      Pro::Client.get.module_details('encoder')['modules'].values.to_json
    end
  end

  def formats
    serve_json('formats_json') { Pro::Client.get.payload_formats.to_json }
  end

  private

  def serve_json(name, &blk)
    json = Rails.cache.fetch(name, expires_in: CACHE_EXPIRATION, &blk)
    respond_to do |format|
      format.json { render plain: json }
    end
  end

end
