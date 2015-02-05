class SearchController < ApplicationController
  skip_authorization_check

  def index
    @search = Riddle::Query.escape params["search"] if params["search"]

    if @search && @search != ''
      search_target = []
      search_target << Question if "1" == params["question"]
      search_target << Answer if "1" == params["answer"]
      search_target << Remark if "1" == params["remark"]

      @found = if search_target.empty?
                 ThinkingSphinx.search @search, page: params[:page]
               else
                 ThinkingSphinx.search @search, classes: search_target, page: params[:page]
               end
    end
  end
end
