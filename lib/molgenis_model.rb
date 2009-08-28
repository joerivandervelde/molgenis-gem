
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
      # all_entities.size
      #puts @modules.size
      all_entities
    end
    
    def field_count
      count = 0;
      all_entities.each do |e|
        e.fields.each do |f| 
          count = count + 1
        end
      end
      count
    end
  end  
  
  class ModuleModel
    attr_accessor :name,:label,:entities, :description, :color
    
    def initialize
      @entities = []
    end
    
    def get_label
      return name if label.nil?
      return label
    end
  end
  
  #Definition of an Entity in MOLGENIS model
  class EntityModel
    attr_accessor :name,:label, :fields, :abstract,:implements,:extends,:module_name,:color,:description
    
    # Creates an empty entity 
    def initialize
      @fields = []
      @implements = []
    end
    
    def get_implemented_fields(model)
      implemented_fields = []
      
      @implements.each do |interface_name|
        #find interface
        entity = nil
        model.all_entities.each do |e|
          if(e.name == interface_name) 
            entity = e 
          end
        end
        entity.fields.each do |e| 
          implemented_fields << e 
        end
      end
      
      implemented_fields
    end
    
  end
  
  class FieldModel
    attr_accessor :name,:label,:type,:system,:xref_entity,:xref_field,:description      
  end
end
