require 'rails_helper'

RSpec.describe SearchController, :type => :controller do
  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }

    it "renders index view" do
      get :index, search: 'abc'
      expect(response).to render_template :index
    end

    it "sanitizes search string to @search" do
      get :index, search: 'abc<script>'
      expect(assigns(:search)).to eq Riddle::Query.escape('abc<script>')
    end

    it "populates @found array" do
      allow(ThinkingSphinx).to receive(:search).and_return(questions)

      get :index, search: 'abc'
      expect(assigns(:found)).to match_array(questions)
    end

    indices = [:question, :answer, :remark]
    (indices.size + 1).times do |count|
      indices.combination(count) do |targets|
        context "when searching for #{targets.empty? ? 'all' : targets.map { |i| i.to_s.pluralize.humanize }.join(', ')}" do

          it "calls ThinkingSphinx for search #{targets.empty? ? 'everywhere' : 'in' + targets.map { |i| i.to_s.classify }.join(', ')}" do
            if targets.empty?
              expect(ThinkingSphinx).to receive(:search).with("abc", page: nil)
            else
              expect(ThinkingSphinx).to receive(:search).with("abc", classes: targets.map { |i| i.to_s.classify.constantize }, page: nil)
            end
            get :index, targets.map { |i| [i, 1] }.to_h.merge(search: 'abc')
          end
        end
      end
    end

    context "when search string is not specified" do
      it "doesn't call ThinkingSphinx" do
        expect(ThinkingSphinx).not_to receive(:search)

        get :index
        get :index, search: ''
      end
    end
  end
end
