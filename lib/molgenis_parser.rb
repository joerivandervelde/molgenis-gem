require "libxml"

module MOLGENIS
  
  class Parser
    # Returns the model for the given molgenis_model.
    # The method accepts objects of classes File, StringIO and String only.
    # ===Usage
    # foo = ... # stuff to initialize foo here
    # bar = MOLGENIS_MODEL:Parser.new.parse(foo)
    def parse(molgenis_src)
      puts "tests"
      case molgenis_src.class.to_s
        when /^string$/i
        document = LibXML::XML::Parser.string(molgenis_src,:encoding => LibXML::XML::Encoding::UTF_8).parse
        when /^stringio|file$/i
        molgenis_src.rewind
        document = LibXML::XML::Parser.string(molgenis_src.read,:encoding => LibXML::XML::Encoding::UTF_8).parse
      else
        raise "Error parsing file."
      end
      
      root = document.root
      return nil if(root.name != "molgenis")
      
      raise "Doesn't appear to be a MOLGENIS model" if root.name != "molgenis"
      version = root["version"]
      
      create_model(root, version)
    end
    
    def create_model(element, version) # :nodoc:
      model = MolgenisModel.new
      model.name = element.attributes['name']
      puts element.attributes['name'] + model.name
      model.version = version
      model.description = ""
      element.find("description").each { |desc| 
        desc.children.each { |el| 
          model.description = model.description + el.to_s
        }
      }     
      
      color = 0
      parse_entities(element.find("entity"),model, color)
      
      element.find("module").each { |module_xml|
        
        module_obj = ModuleModel.new
        module_attributes = module_xml.attributes
        module_obj.name = module_attributes["name"]
        entities = module_xml.find("entity")
        
        color += 1
        module_obj.color = color
        parse_entities(entities,module_obj,color)
        
        model.modules << module_obj
      }
      
      return model
    end
    
    def parse_entities(entities,module_obj,colorno)
      if entities
        entities.each do |entity_xml|
          entity = EntityModel.new
          entity.module_name = module_obj.name
          entity_attributes = entity_xml.attributes
          entity.name = entity_attributes["name"]
          entity.color = colorno
          
          entity.description =""
          entity_xml.find("description").each { |desc| 
            desc.children.each { |el| 
              entity.description = entity.description + el.to_s
            }
          }    
          
          entity_attributes["implements"].split(",").each { |interface|
            entity.implements << interface
          } if !entity_attributes["implements"].nil?
          entity.extends = entity_attributes["extends"]
          
          entity_xml.find("field").each do |field_xml|
            field = FieldModel.new
            field_attributes = field_xml.attributes
            field.name = field_attributes["name"]
            field.type = field_attributes["type"]
            field.label = field_attributes["label"]
            field.description = field_attributes["description"]
            if(field_attributes["xref_field"])
              split = field_attributes["xref_field"].split(".")
              if(split.size == 2)
                field.xref_entity = split[0]
                field.xref_field = split[1]
              else
                field.xref_field = split[0]
                field.xref_entity = field_attributes["xref_entity"]
              end
            end
            entity.fields << field
          end
          module_obj.entities << entity
        end
      end
    end
  end  
end
