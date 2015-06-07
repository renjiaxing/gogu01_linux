# class Wxxinge
#   def push_single_account(req_params={})
#     conn = Faraday.new(:url => 'http://openapi.xg.qq.com') do |faraday|
#       faraday.request :url_encoded # form-encode POST params
#       faraday.response :logger # log requests to STDOUT
#       faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
#     end
#     req_params.merge!({
#                           access_id:2200120344,
#                           timestamp:Time.now.to_i,
#                           environment:2  #生产环境用1
#                       })
#     p=req_params
#     # p.merge!({message: message, message_type: message_type, account: account, access_id: access_id, timestamp: Time.now.to_i, environment: environment}
#     params_string = p.sort.map { |h| h.join('=') }.join
#     sign = Digest::MD5.hexdigest("POSTopenapi.xg.qq.com/v2/push/single_account#{params_string}72371c5e43c99b8a4a845ff995bef03c")
#     p.merge!({sign: sign})
#
#     result=conn.post do |req|
#       req.url '/v2/push/single_account'
#       req.body = p
#     end
#
#     p result
#   end
# end