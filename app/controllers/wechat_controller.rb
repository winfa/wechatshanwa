class WechatController < ApplicationController
    #before_filter :check_wechat_signature

    def server
        check_wechat_signature
        render :text => params[:echostr]
    end

    def post_server
        #binding.pry
        #xml_file.css("//ToUserName")[0].content
        #check_wechat_signature

        # Wechatlog.create(:logkey=>"visiting",:logvalue=>DateTime.now.to_i)
        # Wechatlog.create(:logkey=>"params",:logvalue=>params.to_s)

        # Wechatlog.create(:logkey=>"params_xml",:logvalue=>params[:xml])
        # Wechatlog.create(:logkey=>"params_xml",:logvalue=>params["xml"])

        # xml_body = request.body.read
        # Wechatlog.create(:logkey=>"request.body.read",:logvalue=>xml_body.to_s)
        # xml = Nokogiri::XML(xml_body)
        # Wechatlog.create(:logkey=>"save after xml",:logvalue=>"after xml")
        # @content = xml.css("//MediaId")[0].content
        # Wechatlog.create(:logkey=>"content",:logvalue=>@content)

        # @client_user = xml.css("//FromUserName")[0].content
        # Wechatlog.create(:logkey=>"content",:logvalue=>@client_user)
        # @server_user = xml.css("//ToUserName")[0].content
        # Wechatlog.create(:logkey=>"content",:logvalue=>@server_user)

        xml_body = params[:xml]
        Wechatlog.create(:logkey=>"xml_body",:logvalue=>xml_body)
        @content = xml_body["MediaId"]
        Wechatlog.create(:logkey=>"content",:logvalue=>@content)
        @client_user = xml_body["FromUserName"]
        Wechatlog.create(:logkey=>"client_user",:logvalue=>@client_user)
        @server_user = xml_body["ToUserName"]
        Wechatlog.create(:logkey=>"server_user",:logvalue=>@server_user)

    end

    def show_log
        render :json => Wechatlog.all
    end

    def delete_log
        Wechatlog.all.delete_all
        render :text => "deleted"
    end

    private
    def check_wechat_signature
        Wechatlog.create(:logkey=>"check",:logvalue=> DateTime.now)
        array = ["weixin", params[:timestamp], params[:nonce]].sort
        render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
    end
end
