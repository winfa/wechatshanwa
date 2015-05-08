class WechatController < ApplicationController
    #before_filter :check_wechat_signature

    def server
        check_wechat_signature
        render :text => params[:echostr]
    end

    def post_server
        xml_body = params[:xml]

        @client_user = xml_body["FromUserName"]
        @server_user = xml_body["ToUserName"]
        msgType = xml_body["MsgType"]

        if (msgType == "text")
            @media_id = Wechatlog.find_by(:logkey=>"question").logvalue
        else
            @media_id = xml_body["MediaId"]

            if Wechatlog.last.logkey == "question"
                Wechatlog.create(:logkey=>"answer",:logvalue=>@media_id)
            else
                Wechatlog.create(:logkey=>"question",:logvalue=>@media_id)
            end
        end
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
