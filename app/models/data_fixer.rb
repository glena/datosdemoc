class DataFixer
  def self.fix_title_and_description

    datas = DataCollection.all

    datas.each do |data|

      data.name = ActionView::Base.full_sanitizer.sanitize(data.name).squeeze
      data.description = ActionView::Base.full_sanitizer.sanitize(data.description)
      data.save

    end

  end
end