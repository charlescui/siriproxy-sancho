# -*- encoding: utf-8 -*-
require "siriproxy-sancho/version"

require 'cora'
require 'uuid'
require 'siri_objects'
require "eventmachine"
require "em-http-request"

class SiriProxy::Plugin::Sancho < SiriProxy::Plugin
	def initialize(config)
    end

    def show_fashion_weekend
        # TODO
        # 未来这些数据要来源于数据库或者API
        magzines = %w{140_03fmrw.pdf 140_04-05st.pdf 140_06-07rw.pdf 140_12-13.pdf 140_13.pdf 140_fm.pdf}.map{|path| "http://42.121.89.18/pdf/#{path}"}
        add_views = SiriAddViews.new
        add_views.make_root(last_ref_id)
        answer = SiriAnswer.new("这是最近几期的《时尚周末》", magzines.map{|m| SiriAnswerLine.new(m)})
        add_views.views << SiriAnswerSnippet.new([answer])
        send_object add_views
    end

    listen_for /写字板/i do
        say "请您打开黑板."
        key = UUID.generate.gsub('-','')
        bb_url = "http://42.121.89.18:8000/black_board?key=#{key}"
        mc_url = "http://42.121.89.18:8000/mc/pub"
        say "请打开浏览器访问这个地址:#{mc_url}"
        response = ask "您请讲吧"
        while !(response.gsub(%r{\s},'') =~ /(结束)|(写好)|(完工)/i)
            request = EM::HttpRequest.new(mc_url).post(:body => {:content => response, :key => key}, :timeout => 2)
            response = ask "继续"
        end
        say "记录完毕."
        request_completed
    end

    listen_for /(时尚)|(周末)/i do
        response = ask "您问的是时尚周末吗?"
        if response =~ /(是)|(是的)|(杂志)|(时尚周末)/
            show_fashion_weekend
            request_completed
        else
            say "抱歉，我没有理解您的意思."
            request_completed
        end
    end

    listen_for /时尚周末/i do
        show_fashion_weekend
        request_completed
    end
end