module Salt
  class Post < Page
    attr_accessor :slug, :date, :categories, :year, :month, :day, :markdown

    def initialize(path)
      super

      parts = File.basename(path, File.extname(path)).match(/(\d{4})-(\d{2})-(\d{2})-(.+)/)

      @slug = parts[4]
      @date = Time.mktime(parts[1], parts[2], parts[3])

      @filename = 'index'
      @layout = 'post'
      @categories ||= []

      @year = @date.strftime('%Y')
      @month = @date.strftime('%m')
      @day = @date.strftime('%d')
    end

    def type
      :post
    end

    def contents
      site = Salt::Site.instance

      unless site.settings[:use_markdown]
        @contents
      else
        @markdown ||= site.markdown_renderer.render(@contents)
      end
    end

    def output_path(site, parent_path)
      File.join(parent_path, self.year, self.month, self.day, @slug)
    end
  end
end