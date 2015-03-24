class Chisel
  attr_accessor :paragraph, :header, :stars
  
  def initialize
    @stars = 0
  end
  
  def parse(text)
    stars?(text)
    if @stars > 0
      star_eval(text)
    else
      text
    end
    split_text = splitter(text)
    split_text.map do |line|
      if line.include? "#"
        @header = parse_header(line)
      else
        @paragraph = parse_paragraph(line)
      end
    end
  end
  
  def parse_header(text)
    hash_count = text.chars.count do |char|
      char == "#"
    end
    text.delete!("#").sub!(" ", "")
    front = "<h#{hash_count}>"
    back = "</h#{hash_count}>"
    output_line(front, text, back)
  end
  
  def output_line(front, text, back)
    "#{front}#{text}#{back}"
  end
  
  def parse_paragraph(text)
    front = "<p>\n"
    back = "\n</p>"
    output_line(front, text, back)
  end
  
  def splitter(text)
    text.split(/^\n/).flat_map do |line|
      if line.include?("#")
        line.split("\n")
      else
        line
      end
    end
  end
  
  def stars?(text)
    @stars = text.chars.count do |star|
      star == "*"
    end
  end
  
  def star_eval(text)
    while @stars > 0
      if text.include?("**")
        if text.include?(" **")
          text.sub!("**", "<strong>")
          @stars -= 2
        else
          text.sub!("**", "</strong>")
          @stars -= 2
        end
      else
        if text.include?("\s*")
          text.sub!("*", "<em>")
          @stars -= 1
        else
          text.sub!("*", "</em>")
          @stars -= 1
        end
      end
      
      # else text.include?(" * ")
      #   "unordered list"
    end
    text
  end
  
  
end

parser = Chisel.new

#passes
#puts parser.star_eval("My *emphasized and **stronged** text* is awesome")
puts parser.parse(File.read("./chisel_sample.md"))
