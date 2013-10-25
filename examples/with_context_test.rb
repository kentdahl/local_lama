
### Legacy code

module MyConfig
  DEFAULT_COLOR = 'blue'
end


def all_around_the_code
  # ... this kind of thing is all over the place, can't change them all!
  puts " - got: #{MyConfig::DEFAULT_COLOR}"
end

puts "Legacy..."
all_around_the_code  #=> blue

### Using LocalLama to get dynamic constants.

require 'local_lama'

MyConfig.extend LocalLama::DynamicConstants

puts "With overrides:"

MyConfig.with_local_constants DEFAULT_COLOR: "gublaarange" do
  all_around_the_code
end



def update_widget
  name = MyConfig::NAME
  color = MyConfig::COLOR
  str = "<#{color}> #{name} </#{color}>"
  puts " - #{str}"
  str
end

MyConfig.with_local_constants   NAME: 'dave', COLOR: 'red' do
  MyConfig.with_local_constants NAME: 'avi',  COLOR: 'green' do
    update_widget               #=> "<green>avi</green>"
  end
  MyConfig.with_local_constants NAME: 'kent' do
    update_widget               #=> "<red>kent</red>"
  end
  update_widget                 #=> "<red>dave</red>"
end
