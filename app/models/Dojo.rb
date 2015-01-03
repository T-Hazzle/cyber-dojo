
# See cyber-dojo-model.pdf

class Dojo

  def initialize(path)
    path += '/' unless path.end_with?('/')
    @path = path
  end

  attr_reader :path

  def languages
    @languages ||= Languages.new
  end

  def exercises
    @exercises ||= Exercises.new
  end

  def katas
    katas_path = path
    # see test/languages/one_language_checker.rb
    katas_path += 'test/cyberdojo/' if ENV['CYBERDOJO_TEST_ROOT_DIR']
    katas_path += 'katas/'
    Katas.new(self, katas_path)
  end

end
