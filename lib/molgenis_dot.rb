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
    overlap = "false"
    splines = "false"
    layers = "1:2"
    outputorder="edgesfirst"
    

        node [
            fontname = "Arial"
            fontsize = 8
            shape = "record"
            color = "#808080"
            style="filled"
            fillcolor = "white"
            layer = "2" 
        ]

        edge [
                fontname = "Bitstream Vera Sans"
                fontsize = 8
                layer = "1"
        ]
    <% if model.modules.size > 0 %>    
    subgraph cluster_legend {
        rankdir ="LR";
        label = "module legend"
        color = "white"
        fillcolor = "white"
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
    <% end %>
    
    subgraph cluster_main {  
        rankdir ="TB";
        pagedir="TB" 
        fillcolor = "white"
        
      <% model.all_entities.each { |entity| %>
      "<%= entity.name %>"
           [      
                style = "filled"
                <% if entity.color == 0 %>
                fillcolor="lemonchiffon1"
                <% else %>
                colorscheme=pastel19
                fillcolor = "<%=entity.color%>"
                <% end %>
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
                  color = "grey"
          ]
  <% model.all_entities.each do |entity|  %>
        <% if entity.implements %>
           <% entity.implements.each do |interface| %>
             "<%= entity.name %>" -> "<%= interface %>"
            <%end%>
        <%end %>
  <% end %> 
      
  /*extends relationships*/
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
      <% if model.modules.size > 0%>"spook_legend" -> "spook_main"<% end %>
    }
    }.gsub(/^  /, '')
    imagedot = ERB.new(template, 0, "%<>")
    stream.puts imagedot.result(b)
    stream.flush
    end
  end
end