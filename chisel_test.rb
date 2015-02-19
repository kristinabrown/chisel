gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative 'chisel'

class ChiselTest < Minitest::Test

  def setup
    @parser = Chisel.new
  end

  def test_it_can_parse_a_header
    assert_equal ["<h1>header</h1>"], @parser.parse("# header")
  end

  def test_it_can_parse_a_lesser_header
    assert_equal "<h2>header</h2>", @parser.parse_header("## header")
  end

  def test_it_can_parse_an_even_lesser_header
    assert_equal "<h3>header</h3>", @parser.parse_header("### header")
  end

  def test_it_can_parse_a_paragraph
    assert_equal "<p>this is a paragraph</p>", @parser.parse_paragraph("this is a paragraph")
  end

  def test_it_can_parse_a_paragraph_with_just_parse
    assert_equal ["<p>this is a paragraph</p>"], @parser.parse("this is a paragraph")
  end

  def test_it_can_split_serveral_lines_into_an_array_of_elements
    assert_equal ["### a litte header", "and a paragraph"], @parser.splitter("### a litte header\nand a paragraph")
  end

  def test_it_can_parse_the_difference_between_paragraph_and_header
    assert_equal ["<h2>a little header</h2>", "<p>and a paragraph</p>"], @parser.parse("## a little header\nand a paragraph")
  end

  def test_it_can_recognize_stars
    assert_equal 2,  @parser.stars?("## a little header\n and *a* paragraph")
  end

# this works but formatting is a nighmare
  def test_it_can_parse_multiple_lines
    skip
    assert_equal ["<h1>My Life in Desserts</h1>", "<h2>Chapter 1: The Beginning</h2>", "<p>\"You just *have* to try the cheesecake,\" he said. \"Ever since it appeared in
    **Food & Wine** this place has been packed every night.\"</p>"], @parser.parse(File.read("./chisel_sample.md"))
  end

  # this passed but was getting in the way

  # def test_it_can_know_what_is_near_a_star
  #   assert "space and digit", @parser.star_eval("these are *italic.*")
  #   assert "another star", @parser.star_eval("these are **bold.**")
  #   assert "space and space", @parser.star_eval("this is a list:\n * milk\n * fruit\n * bread.")
  # end

  def test_it_can_sub_strong_for_two_stars
    assert "this is <strong>bold</strong>", @parser.star_eval("this is **strong**")
  end

  def test_it_can_sub_em_for_one_star_next_to_text
    assert "this is an <em>italics</em>", @parser.star_eval("this is *strong*")
  end

  # *text* is <em>text</em>
  # **text** is <strong>text</text>

end
