require 'pry'                                # => true
class Chisel
  attr_accessor :paragraph, :header, :stars  # => nil

  def initialize
    @stars = 0    # => 0
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
        @header
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
    front = "<p>"
    back = "</p>"
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
    @stars = 6
    while @stars >= 0
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

parser = Chisel.new  # => #<Chisel:0x007fd3040649e0 @stars=0>

# puts parser.stars?("this is a **bold** word and *italics* word")
 puts parser.star_eval("this is a **bold** word and *italics* word")
puts parser.parse(File.read("./chisel_sample.md"))  # ~> Errno::ENOENT: No such file or directory @ rb_sysopen - ./chisel_sample.md

# ~> Errno::ENOENT
# ~> No such file or directory @ rb_sysopen - ./chisel_sample.md
# ~>
# ~> /Users/kristinabrown/homework/chisel/chisel.rb:96:in `read'
# ~> /Users/kristinabrown/homework/chisel/chisel.rb:96:in `<main>'
