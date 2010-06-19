module Sinatra
  class NoTemplateError < StandardError; end
  
  module Hat
    # Tells Sinatra what to do next.
    class Response
      attr_reader :maker
      
      delegate :model, :resource_path, :to => :maker
      
      def initialize(maker, request)
        @maker = maker
        @request = request
      end
      
      # Now uses haml by default
      def render(action, options={})
        begin
          options.each { |sym, value| @request.send(sym, value) }
          @request.haml "#{maker.prefix}/#{action}.html".to_sym
        rescue Errno::ENOENT
          no_template! "Can't find #{File.expand_path(File.join(views, action.to_s))}.html.haml"
        end
      end
      
      # Scaffolded rendering
      # This will attempt to load the template file from:
      # 1. Location where it should be (views/projects/index.html.haml)
      # 2. User-specific scaffolds (views/scaffold/index.html.haml)
      # 3. Default scaffolds (sinatras-hat/scaffold/index.html.haml)
      def render_with_scaffold(action, options={}, locals = {})     
        begin
          
          options.each { |sym, value| @request.send(sym, value) }
          file = "#{maker.prefix}/#{action}.html"
          @request.haml file.to_sym, options, locals
          
        rescue Errno::ENOENT
          begin
            file = "scaffold/#{action}.html"
            @request.haml file.to_sym, options, locals
          rescue Errno::ENOENT
            begin
              file = "#{action}.html"
              @request.haml file.to_sym, { :views => File.expand_path(File.join("#{File.dirname(__FILE__)}/scaffold")) }, locals
            rescue Errno::ENOENT
              no_template! "Can't find #{file.to_s} in any of the view paths"
            end
          end
        end
      end
      
      def redirect(*args)
        @request.redirect url_for(*args)
      end
      
      def url_for(resource, *args)
        case resource
        when String then resource
        when Symbol then resource_path(Maker.actions[resource][:path], *args)
        else maker_for(resource).resource_path('/:id', resource)
        end
      end
      
      private
      
      def no_template!(msg)
        raise NoTemplateError.new(msg)
      end
      
      def views
        @views ||= begin
          if views_dir = @request.options.views
            File.join(views_dir, maker.prefix)
          else
            no_template! "Make sure you set the :views option!"
          end
        end
      end
      
      def maker_for(record)
        resource = record.is_a?(model.klass) ? maker : maker.parents.detect { |m| record.is_a?(m.model.klass) }
        resource || maker
      end
    end
  end
end
