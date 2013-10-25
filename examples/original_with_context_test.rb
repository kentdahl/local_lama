# Courtesy of Dave Thomas and Avi Bryant, with minor modifications...

require 'continuation'

def with_context(params)
  k, name = catch(:context) do 
    yield
    return
  end
  k.call(params[name] || find_in_context(name))
end
def find_in_context(name)
  callcc do |k| 
    throw(:context, [k, name])
  end
end

def update_widget
  name = find_in_context(:name)
  color = find_in_context(:color)
  puts "<#{color}> #{name} </#{color}>"
end

with_context   name: 'dave', color: 'red' do
  with_context name: 'avi',  color: 'green' do
    update_widget               #=> "<green> avi </green>"
  end
  with_context name: 'kent' do
    update_widget               #=> "<red> kent </red>"
  end
  update_widget                 #=> "<red> dave </red>"
end



