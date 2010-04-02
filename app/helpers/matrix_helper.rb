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
      haml_tag("div", :class => "sider")
      haml_tag("div", :class => "header") do
        row do
          cell("")
          cell("")
          cell("Column #")
          cols.size.times {|x| cell("#{x+1}", :class => "num")}
        end
        row do
          cell("")
          cell("")
          cell("Weight")
          cols.each {|sec_req| cell(sec_req.weight || "0", :class => "weight")}
        end
        row do
          cell("Row #")
          cell("Weight")
          cell("Primary / Secondary")
          cols.each {|x| cell(h(x.name))}
        end
      end
      rows.each_with_index do |pri_req, idx|    
        row do
          cell(idx + 1, :class => "num")
          cell(pri_req.weight || "0", :class => "weight")
          cell(h(pri_req.name))
          cols.each do |sec_req|
            cell(:class => "rating") do
              haml_tag("div", rating_for(pri_req, sec_req))
            end
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
    Rating.lookup(pri_req, sec_req).value || "&nbsp;"
  end
end


