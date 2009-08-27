
module MOLGENIS # :nodoc:
  
  # The model for a given MOLGENIS model
  class MolgenisModel
    # The list of all the entities that make up the model
    attr_accessor :version,:name,:label,:entities, :modules, :description
    
    # Creates an empty model a
    def initialize
      @entities = []
      @modules = []
    end
    
    def all_entities
      all_entities = []
      @entities.each{|entity|
        all_entities << entity
      }
      @modules.each { |module_obj|
        module_obj.entities.each {|entity|
          all_entities << entity
        }
        
      }
      puts all_entities.size
      puts @modules.size
      all_entities
    end
  end  
  
  class ModuleModel
    attr_accessor :name,:label,:entities, :description, :color
    
    def initialize
      @entities = []
    end
  end
  
  #Definition of an Entity in MOLGENIS model
  class EntityModel
    attr_accessor :name, :label, :fields, :abstract,:implements,:extends,:module_name,:color
    
    # Creates an empty entity 
    def initialize
      @fields = []
      @implements = []
    end
    
  end
  
  class FieldModel
    attr_accessor :name,:type,:system,:xref_entity,:xref_field      
  end
end
