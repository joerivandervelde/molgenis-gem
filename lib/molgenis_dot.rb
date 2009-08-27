require "erb"


module MOLGENIS
  class Dot
    def write_dot(stream, model)
    b = binding 
    template = %q{
    digraph G {
    compound = true
    fontname = "Bitstream Vera Sans"
    fontsize = 8
    page = "12f,12f"
    pagedir="TB"
    rankdir="BT"
    clusterrank = "local"
    bgcolor = "white"  

        node [
            fontname = "Arial"
            fontsize = 8
            shape = "record"
            color = "#808080"
            style="filled"
            fillcolor = "white"
        ]

        edge [
                fontname = "Bitstream Vera Sans"
                fontsize = 8
        ]
        
    subgraph cluster_legend {
        rankdir ="LR";
        label = "module legend"
        color = "white"
        fillcolor = white
        rankType = "same"
        <% model.modules.each { |m| %>
        "<%= m.name %>"
        [
                  style = "filled"
                  colorscheme= "pastel19"
                  fillcolor = "<%= m.color %>"
                  fontname = "Arial"
                  fontcolor = "black"
                  color = "black"
                  label = "{<%= m.name %>}" 
        ]
        <% } %>
        
        node [
              style = "invis"
              width = 0
        ]
        "spook_legend"
    }       
    
    subgraph cluster_main {  
        rankdir ="TB";
        pagedir="TB" 
        
      <% model.all_entities.each { |entity| %>
      "<%= entity.name %>"
           [      
                style = "filled"
                colorscheme=pastel19
                fillcolor = "<%=entity.color%>"
                <%if entity.abstract %>
                fontname = "Arial-Italic"
                fontcolor = "dimgrey"
                color = "dimgrey"
                <% else %>
                fontname = "Arial"
                fontcolor = "black"
                color = "black"
                <% end %>
                label = "{<% if entity.abstract %>Interface:<% end %><%= entity.name %><% entity.implements.each do |interface| %>\nimplements <%=interface%><% end %>|<% entity.fields.each do |f| %><% if !f.system %><%=f.name%> : <%=f.type %><% if (f.type=="xref" || f.type=="mref") %>(<%= f.xref_entity %>.<%=f.xref_field %>)<%end%>\l<%end%><%end%>}"
            ]    
      <% } %>
      
  
      
  /*interface relationships*/
          edge [
                  arrowhead = "empty"
                  color = "black"
          ]
  <% model.all_entities.each do |entity|  %>
        <% if entity.extends %>
         "<%= entity.name %>" -> "<%= entity.extends %>"
        <%end %>
  <% end %>    
      
  /*one to many 'xref' foreign key relationships*/
          edge [
                  arrowhead = "open"
                  taillabel = "*"
          ]
          
  <% model.all_entities.each do |entity|  %>
        <% entity.fields.each do |f| %>
           <% if f.type == "xref" %>
          "<%= entity.name %>" -> "<%= f.xref_entity%>"
       <% end %>
    <% end %>
  <% end %>
  
  /*one to many 'mref' foreign key relationships*/
          edge [
               arrowhead = "open"
               arrowtail = "open"
               color = "black"
               taillabel = "*"
               arrowsize = 0.6
               rank = "same"
          ]
          
  <% model.all_entities.each do |entity|  %>
        <% entity.fields.each do |f| %>
           <% if f.type == "mref" %>
          "<%= entity.name %>" -> "<%= f.xref_entity%>"
       <% end %>
    <% end %>
  <% end %>
  
          node [
              style = "invis"
              width = 0
          ]
          "spook_main" 
      }
      
      edge [style = "invis"]
      "spook_legend" -> "spook_main"
    }
    }.gsub(/^  /, '')
    imagedot = ERB.new(template, 0, "%<>")
    stream.puts imagedot.result(b)
    stream.flush
    end
  end
end