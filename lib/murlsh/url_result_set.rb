module Murlsh

  class UrlResultSet

    def initialize(query, page, per_page, filters={})
      @query, @page, @per_page, @filters = query, page, per_page, filters
      @order = 'time DESC'
    end

    def search_conditions
      @search_conditions ||= SearchConditions.new(query).conditions
    end

    def conditions
      @conditions ||= if filters[:content_type]
        result = if filters[:content_type].is_a?(String)
          ['content_type = ?', filters[:content_type]]
        else
          ['content_type IN (?)', filters[:content_type]]
        end

        unless search_conditions.empty?
          result[0] << " AND (#{search_conditions[0]})"
          result.push(*search_conditions[1..-1])
        end
        result
      else
        search_conditions
      end
    end

    def total_entries
      @total_entries ||= Url.count(:conditions => conditions)
    end

    def total_pages
      @total_pages ||= [(total_entries / per_page.to_f).ceil, 1].max
    end

    def offset; @offset ||= (page - 1) * per_page; end

    def results
      Url.all(:conditions => conditions, :order => order,
        :limit => per_page, :offset => offset)
    end

    def prev_page
      unless instance_variable_defined?(:@prev_page)
        @prev_page = page - 1  if (2..total_pages) === page
      end
      @prev_page
    end

    def next_page
      unless instance_variable_defined?(:@next_page)
        @next_page = page + 1  if page < total_pages
      end
      @next_page
    end

    attr_reader :query
    attr_reader :page
    attr_reader :per_page
    attr_reader :filters
    attr_reader :order
  end

end
