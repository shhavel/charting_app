class DashboardController < ApplicationController
  def index
    require 'csv'
    data = CSV.read(Rails.root.join('data', 'session_history.csv'), headers: true)

    data.each do |row|
      row['created_on'] = row['created_at'].split(' ').first
    end

    @days = data.map { |row| Date.parse(row['created_on']) }.uniq.sort.map(&:to_s)

    @passing = Hash.new(0)
    @failing = Hash.new(0)

    data.each do |row|
      if row['summary_status'] == 'passed'
        @passing[row['created_on']] += 1
      else
        @failing[row['created_on']] += 1
      end
    end
  end
end
