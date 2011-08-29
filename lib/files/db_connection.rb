#!/usr/bin/ruby

Locus_DB_ADAPTER = 'postgresql'
Locus_DB_HOST = 'localhost'
Locus_DATABASE = 'locus_db'
Locus_DB_USERNAME = 'tools'
Locus_DB_PASSWORD = 'analysis'

module LocusDB
  
  	include ActiveRecord
  
	class DBConnection < ActiveRecord::Base
	  	self.abstract_class = true
  		self.pluralize_table_names = false
    	
    	def self.connect(version="")

      		establish_connection(
                            :adapter => Locus_DB_ADAPTER,
                            :host => Locus_DB_HOST,
                            :database => "#{Locus_DATABASE}_#{version}",
                            :username => Locus_DB_USERNAME,
                            :password => Locus_DB_PASSWORD
                            #:port => port
                          )
    	end
  
  	end
  
end
