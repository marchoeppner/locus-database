#!/usr/bin/ruby

module LocusDB 
  
  class GenomeDb < DBConnection
    set_primary_key 'id'
    hass_many :genes
    
  end # genome_db
  
  class Gene < DBConnection
    set_primary_key 'id'
    belongs_to :genome_db, :foreign_key => 'genome_db_id'
    has_many :xref_gene_groupings
    has_many :groupings, :through => :xref_gene_groupings
    
  end # gene
  
  class Grouping < DBConnection
    set_primary_key 'id'
    has_many :xref_gene_groupings
    has_many :genes, :through => :xref_gene_groupings
    
  end # grouping
  
  class XrefGeneGrouping < DBConnection
    set_primary_keys :gene_id, :grouping_id
    belongs_to :gene, :foreign_key => 'gene_id'
    belongs_to :grouping, :foreign_key => 'grouping_id'
    
  end # xref_gene_grouping
  
  class Dataset < DBConnection
    set_primary_key 'id'
    has_many :groupings
    has_many :genomic_align_blocks
    has_many :dollo_nodes
    
  end # dataset
  
  class GenomicAlignBlock < DBConnection
    set_primary_key 'genomic_align_block_id'
    belongs_to :dataset, :foreign_key => "dataset_id",
    has_many :groupings 
     
  end # genomic_align_block
  
  class DolloNode < DBConnection
    set_primary_keys :dollo_id, :dataset_id
    
  end # dollo_node
  
end # module