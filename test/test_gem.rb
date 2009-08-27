require "libxml"

require "lib/molgenis_parser.rb"
require "lib/molgenis_model.rb"
require "lib/molgenis_dot.rb"

if __FILE__ == $0

  m = MOLGENIS::MolgenisModel.new
  m.name = "test"
  
  puts m.name

  f = File.new("test/test1.xml","r")
  m2 = MOLGENIS::Parser.new.parse(f.read)
  f.close
  puts "empty" if(m2 == nil)
  puts "twee:"
  puts m2.name
  puts m2.version
  m2.entities.each {|e| puts e.name}
  
  fdot = File.open("test/result1.dot","w")
  fdot.puts "test1"
  
  #puts 'instanciating MolgenisProcessor'
  #pietje = WorkflowProcessors::MolgenisProcessor.new(m2)
  #puts 'instance made'
  #pietje.get_preview_image
  
  puts 'calling Dot.write_dot(fdot,m2)'
  MOLGENIS::Dot.new.write_dot(fdot,m2)
  
  s
  
  puts 'done'
end
