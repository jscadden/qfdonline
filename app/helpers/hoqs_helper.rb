module HoqsHelper

  def primary_requirements_vector(requirements)
    requirements.each do |req|
      haml_tag("div", :class => "row") do
        cell(h(req.name))
      end
    end
  end

  def secondary_requirements_header_vectors(requirements)
    haml_tag("div", :class => "row") do
      cell("Column #")
      - 1.upto(requirements.size) {|x| cell(x)}
    end
  end

  def secondary_requirements_vector(requirements)
    requirements.each do |req|
      haml_tag("div", h(req.name), :class => "cell")
    end
  end
end
