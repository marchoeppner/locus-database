#!/usr/bin/ruby

module LocusDB 
  
  class GenomeDb < DBConnection
    set_primary_key 'genome_db_id'
    has_many :genes
    has_many :xref_genome_datasets
    has_many :datasets, :through => :xref_genome_datasets
    
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
    has_many :xref_genome_datasets
    
    
    def genome_dbs
    	return self.xref_genome_datasets.collect{|x| x.genome_db }
    end
    
    def output_phylip
    	tree_string = self.tree_string
        tree_organisms = self.tree.leaves.collect{|t| t.name.strip }
        tree_organisms.each do |t_o|
          phylip_name = t_o.gsub(/\s/, '_').phylip_name
          t_o = t_o.gsub(/\s/ , '_')
          tree_string.gsub!(/#{t_o}/, "#{phylip_name}")
        end
        return tree_string
   
    end
    
    
  end # dataset
  
  class XrefGenomeDataset < DBConnection
  	set_primary_keys :genome_db_id, :dataset_id
  	belongs_to :genome_db, :foreign_key => "genome_db_id"
  	belongs_to :dataset_id, :foreign_key => "dataset_id"
  end
  
  class GenomicAlignBlock < DBConnection
    set_primary_key 'genomic_align_block_id'
    belongs_to :dataset, :foreign_key => "dataset_id"
    has_many :groupings 
     
  end # genomic_align_block
  
  class DolloNode < DBConnection
    set_primary_keys :dollo_id, :dataset_id
    
  end # dollo_node
  
end # module
