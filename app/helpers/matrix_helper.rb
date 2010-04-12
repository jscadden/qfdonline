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

  def matrix(cols, rows, is_first, &block)
    haml_tag("div", :class => "matrix") do
      haml_tag("div", :class => "sider")
      haml_tag("div", :class => "sider")
      haml_tag("div", :class => "sider")
      haml_tag("div", :class => "header") do
        row do
          cell("")
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
          cell("")
          cell("Max Rating")
          cols.each {|sec_req| cell(Rating.maximum_as_secondary(sec_req) || "", :class => "maximum")}
        end
        row do
          cell("")
          cell("")
          cell("")
          cell("")
          cell("Weight")
          cols.each {|sec_req| cell(number_to_weight(sec_req.weight), :class => "weight")}
        end
        row do 
          cell("")
          cell("")
          cell("")
          cell("")
          cell("Relative Weight")
          cols.each {|sec_req| cell(number_to_relative_weight(sec_req.relative_weight), :class => "weight")}
        end
      end
      row do
        cell("Row #")
        cell("Max Rating")
        cell("Relative Weight")
        cell("Weight", :class => "header")
        cell("Primary / Secondary", :class => "header")
        cols.each {|sec_req| name_for(sec_req)}
      end
      rows.each_with_index do |pri_req, idx|    
        row do
          cell(idx + 1, :class => "num")
          cell(Rating.maximum_as_primary(pri_req) || "", :class => "maximum")
          cell(number_to_relative_weight(pri_req.relative_weight), 
               :class => "weight")
          weight_for(pri_req)
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

    if rating.nil?
      rating = Rating.new(:primary_requirement => pri_req,
                          :secondary_requirement => sec_req)
    end

    cell(:class => "rating") do
      concat(inner_rating_for(rating))
    end
  end

  def name_for(req)
    cell(:class => "name") do
      concat(inner_name_for(req))
    end
  end

  def weight_for(req)
    classes = ["weight",]
    if req.primary_hoq.first?
      classes << "first_hoq"
    else
      classes << "header"
    end

    cell(:class => classes.join(" ")) do
      concat(inner_weight_for(req))
    end
  end

end


