require 'murlsh'

describe Murlsh::Setup::YamlOrderedHash do

  subject do
    h = {
      'd' => 4,
      'a' => 1,
      'c' => 3,
      'b' => 2,
      }

    h.extend(Murlsh::Setup::YamlOrderedHash)
  end
  
  its(:to_yaml) { should == <<EOS
--- 
a: 1
b: 2
c: 3
d: 4
EOS
  }

end
