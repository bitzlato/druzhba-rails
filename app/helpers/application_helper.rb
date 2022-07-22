# frozen_string_literal: true

module ApplicationHelper

  def sort_column(column, title)
    return column unless defined? q
    sort_link q, column, title
  end

  def hided_columns
    []
  end

  def back_link(url = nil)
    link_to ('&larr; ' + t('.back')).html_safe, url || root_path
  end
end
