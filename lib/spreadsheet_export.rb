require "spreadsheet"

module SpreadsheetExport
  module Qfd

    def to_xls
      ss = Spreadsheet::Workbook.new

      hoqs.each do |hoq|
        sheet = ss.create_worksheet(:name => hoq.name)
        hoq.export_to_sheet(sheet)
      end

      out = open(File.join(Rails.root, "tmp", filename), "w+")
      ss.write(out.path)
      out.rewind
      return out
    end


    private

    def filename
      ("%s_%s.xls" % [name, user.login]).gsub(/[^\w\.\-]/, "")
    end
  end

  module Hoq

    def export_to_sheet(sheet)
      @worksheet = sheet
      @col_offset = 4
      @row_offset = 4

      header_column_num
      header_column_max_rating
      header_column_weight
      header_column_relative_weight

      header_row_num
      header_row_max_rating
      header_row_relative_weight
      header_row_weight

      header_requirements

      primary_requirements_names
      secondary_requirements_names

      ratings
    end


    private


    def header_column_num
      @worksheet[0,@col_offset] = "Column #"
      secondary_requirements.each do |req|
        col_idx = @col_offset + req.position
        @worksheet[0,col_idx] = req.position
      end
    end

    def header_column_max_rating
      @worksheet[1,@col_offset] = "Max Rating"
      secondary_requirements.each do |req|
        col_idx = @col_offset + req.position
        @worksheet[1,col_idx] = Rating.maximum_as_secondary(req)
      end
    end

    def header_column_weight
      @worksheet[2,@col_offset] = "Weight"
      secondary_requirements.each do |req|
        col_idx = @col_offset + req.position
        @worksheet[2,col_idx] = req.weight
      end
    end

    def header_column_relative_weight
      @worksheet[3,@col_offset] = "Relative Weight"
      secondary_requirements.each do |req|
        col_idx = @col_offset + req.position
        @worksheet[3,col_idx] = req.relative_weight
      end
    end

    def header_row_num
      @worksheet[@row_offset,0] = "Row #"
      primary_requirements.each do |req|
        row_idx = @row_offset + req.position
        @worksheet[row_idx,0] = req.position
      end
    end

    def header_row_max_rating
      @worksheet[@row_offset,1] = "Max Rating"
      primary_requirements.each do |req|
        row_idx = @row_offset + req.position
        @worksheet[row_idx,1] = Rating.maximum_as_primary(req)
      end
    end

    def header_row_relative_weight
      @worksheet[@row_offset,2] = "Relative Weight"
      primary_requirements.each do |req|
        row_idx = @row_offset + req.position
        @worksheet[row_idx,2] = req.relative_weight
      end
    end

    def header_row_weight
      @worksheet[@row_offset,3] = "Weight"
      primary_requirements.each do |req|
        row_idx = @row_offset + req.position
        @worksheet[row_idx,3] = req.weight
      end
    end

    def header_requirements
      @worksheet[@row_offset,@col_offset] = "Primary / Secondary"
    end

    def primary_requirements_names
      primary_requirements.each do |req|
        row_idx = @row_offset + req.position
        @worksheet[row_idx,@col_offset] = req.name
      end
    end

    def secondary_requirements_names
      secondary_requirements.each do |req|
        col_idx = @col_offset + req.position
        @worksheet[@row_offset,col_idx] = req.name
      end
    end

    def ratings
      secondary_requirements.each do |sec_req|
        primary_requirements.each do |pri_req|
          col_idx = @col_offset + sec_req.position
          row_idx = @row_offset + pri_req.position
          rating = Rating.lookup(pri_req, sec_req)
          if rating
            @worksheet[row_idx,col_idx] = rating.value
          end
        end
      end
    end
  end
end
