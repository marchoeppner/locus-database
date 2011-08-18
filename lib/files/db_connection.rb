#!/usr/bin/ruby

DB_ADAPTER = 'postgres'
DB_HOST = 'localhost'
DATABASE = 'locusdb'
DB_USERNAME = 'tools'
DB_PASSWORD = 'analysis'

module LocusDB
  
  include ActiveRecord
  
  class DBConnection < ActiveRecord::Base
    self.abstract_class = true
  
    def self.connect(version="")

      establish_connection(
                            :adapter => DB_ADAPTER,
                            :host => DB_HOST,
                            :database => "#{DATABASE}#{version}",
                            :username => DB_USERNAME,
                            :password => DB_PASSWORD
                            #:port => port
                          )
    end
  
  end
  
end