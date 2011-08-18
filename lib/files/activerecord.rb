#!/usr/bin/ruby

require 'activerecord'

module LocusDb 
  
  class GenomeDb < DBConnection
    
  end # genome_db
  
  class Gene < DBConnection
    
  end # gene
  
  class Grouping < DBConnection
    
  end # grouping
  
  class XrefGeneGrouping < DBConnection
    
  end # xref_gene_grouping
  
  class Dataset < DBConnection
    
  end # dataset
  
  class GenomicAlignBlock < DBConnection
    
  end # genomic_align_block
  
  class DolloNode < DBConnection
    
  end # dollo_node
  
end # module