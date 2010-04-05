module MatrixHelper

  def cell(content_or_options_with_block=nil, options={}, &block)
    if block_given?
      if content_or_options_with_block.is_a?(Hash)
        options = content_or_options_with_block 
      else
        options = {}
      end

      merge_class_into_options(options, "cell")
      haml_tag("div", capture_haml(&block), options)
    else
      merge_class_into_options(options, "cell")
      haml_tag("div", 
               content_or_options_with_block, options)
    end
  end

  def row(content_or_options_with_block=nil, options={}, &block)
    if block_given?
      if content_or_options_with_block.is_a?(Hash)
        options = content_or_options_with_block 
      else
        options = {}
      end

      merge_class_into_options(options, "row")
      haml_tag("div", capture_haml(&block), options)
    else
      merge_class_into_options(options, "row")
      haml_tag("div", content_or_options_with_block, options)
    end
  end

  def matrix(cols, rows, &block)
    haml_tag("div", :class => "matrix") do
      haml_tag("div", :class => "sider")
      haml_tag("div", :class => "sider")
      haml_tag("div", :class => "header") do
        row do
          cell("")
          cell("")
          cell("")
          cell("Column #")
          cols.size.times {|x| cell("#{x+1}", :class => "num")}
        end
        row do
          cell("")
          cell("")
          cell("")
          cell("Weight")
          cols.each {|sec_req| cell(sec_req.weight || "0", :class => "weight")}
        end
        row do 
          cell("")
          cell("")
          cell("")
          cell("Relative Weight")
          cols.each {|sec_req| cell(number_to_percentage(sec_req.relative_weight), :class => "weight")}
        end
      end
      row do
        cell("Row #")
        cell("Relative Weight")
        cell("Weight", :class => "header")
        cell("Primary / Secondary", :class => "header")
        cols.each {|sec_req| name_for(sec_req)}
      end
      rows.each_with_index do |pri_req, idx|    
        row do
          cell(idx + 1, :class => "num")
          cell(number_to_percentage(pri_req.relative_weight), :class => "weight")
          cell(pri_req.weight || "0", :class => "weight")
          name_for(pri_req)
          cols.each do |sec_req|
            rating_for(pri_req, sec_req)
          end
        end
      end
    end
  end


  private

  def merge_class_into_options(options, class_name)
    if options.include?(:class)
      options[:class] = class_name + " #{options[:class]}"
    else
      options[:class] = class_name 
    end
  end

  def rating_for(pri_req, sec_req)
    rating = Rating.lookup(pri_req, sec_req)
    
    if rating && rating.value
      value = rating.value
    else
      value = "&nbsp;"
    end

    cell(:class => "rating", :id => rating ? "#{rating.id}" : "") do
      concat(inner_rating_for(pri_req, sec_req, value))
    end
  end

  def name_for(req)
    cell(:class => "name") do
      concat(inner_name_for(req))
    end
  end

end


