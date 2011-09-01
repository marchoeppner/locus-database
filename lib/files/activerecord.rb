#!/usr/bin/ruby

module LocusDB 
  
  class GenomeDb < DBConnection
    set_primary_key 'genome_db_id'
    has_many :genes
    has_many :xref_genome_datasets
    #has_many :datasets, :through => :xref_genome_datasets
    
  end # genome_db
  
  class Gene < DBConnection
    set_primary_key 'id'
    belongs_to :genome_db, :foreign_key => 'genome_db_id'
    has_many :xref_gene_groupings
    #has_many :groupings, :through => :xref_gene_groupings
    
  end # gene
  
  class Grouping < DBConnection
    set_primary_key 'id'
    has_many :xref_gene_groupings
    has_many :xref_dollo_groupings
    #has_many :genes, :through => :xref_gene_groupings
    
    def state_at_node?(node) 				
        node = LocusDB::DolloNode.find_by_node(node) unless node.kind_of?(LocusDB::DolloNode)            
        state = self.xref_dollo_groupings.select{|x| x.dollo_node_id == node.id }.shift.state 				
        if state == "." and node.node.include?("root")
          return "0"
        elsif state == "."
          self.state_at_node?(node.get_parent)
        else
          return state
        end 			
  	end
  	
  	def deepest_node
        nodes = self.xref_dollo_groupings.collect{|x| x.dollo_node}.sort_by{|n| n.id}
        nodes.each do |node|
          return node if self.state_at_node?(node) == "1"
        end
        return nil
    end
    
    def deepest_node_name
        deepest_node = self.deepest_node
        if deepest_node.nil?
          return "Species-specific"
        else
          return deepest_node.description
        end
    end
      
  end # grouping
  
  class XrefDolloGrouping < DBConnection
  
  	#set_primary_keys :dollo_node_id, :grouping_id
  	belongs_to :dollo_node, :foreign_key => "dollo_node_id"
  	belongs_to :grouping, :foreign_key => "grouping_id"
  	
  end
  
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
      		phylip_name = t_o.gsub(/\s/, '_')[0..9].capitalize
          	t_o.gsub!(/\s/ , '_')
          	tree_string.gsub!(/#{t_o}/, "#{phylip_name}")
        end
        return tree_string
    end
    
   	def tree
    	return Bio::Newick.new(self.tree_string).tree
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
    has_many :xref_dollo_groupings
    
    def get_parent
        return nil if self.child_of.nil?
        return LocusDB::DolloNode.find(self.child_of)
    end
  end # dollo_node
  
end # module
