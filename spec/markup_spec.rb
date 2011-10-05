require 'murlsh'

class MarkupMixer < Builder::XmlMarkup
  include ::Murlsh::Markup
end

describe MarkupMixer do

  before do
    @m = MarkupMixer.new
  end

  it 'should correctly render a single javascript tag' do
    @m.javascript 'test.js'
    @m.target!.should ==
      '<script type="text/javascript" src="test.js"></script>'
  end

  it 'should correctly render a list of javascript tags' do
    @m.javascript ['test1.js', 'test2.js']
    @m.target!.should ==
      '<script type="text/javascript" src="test1.js"></script><script type="text/javascript" src="test2.js"></script>'
  end

  it 'should correctly render a single javascript tag with a prefix' do
    @m.javascript 'test.js', :prefix => 'http://static.com/js/'
    @m.target!.should ==
      '<script type="text/javascript" src="http://static.com/js/test.js"></script>'
  end

  it 'should correctly render a list of javascripts tag with a prefix' do
    @m.javascript ['test1.js', 'test2.js'], :prefix => 'js/'
    @m.target!.should ==
      '<script type="text/javascript" src="js/test1.js"></script><script type="text/javascript" src="js/test2.js"></script>'
  end

  it 'should correctly render a murlsh_img tag' do
    @m.murlsh_img :src => 'foo.png', :prefix => 'http://static.com/img/'
    @m.target!.should == '<img src="http://static.com/img/foo.png"/>'
  end

  it 'should correctly render a murlsh_img tag with a single size value' do
    @m.murlsh_img :src => 'foo.png', :size => 32
    [
      /height="32"/,
      /src="foo\.png"/,
      /width="32"/,
    ].each { |r| !@m.target!.should match r }
  end

  it 'should correctly render a murlsh_img tag with two size values' do
    @m.murlsh_img :src => 'foo.png', :size => [100, 200]
    [
      /height="200"/,
      /src="foo\.png"/,
      /width="100"/,
    ].each { |r| !@m.target!.should match r }
  end

  it 'should correctly render a murlsh_img tag with text' do
    @m.murlsh_img :src => 'foo.png', :text => 'test'
    [
      /alt="test"/,
      /src="foo\.png"/,
      /title="test"/,
    ].each { |r| !@m.target!.should match r }
  end

  it 'should correctly render a murlsh_img tag with an href' do
    @m.murlsh_img :href => '/test/', :src => 'foo.png'
    @m.target!.should == '<a href="/test/"><img src="foo.png"/></a>'
  end

  it 'should correctly render meta tags' do
    @m.metas :a => '1', :b => '2', :c => '3'
    [
      '<meta (name="a" content="1"|content="1" name="a")/>',
      '<meta (name="b" content="2"|content="2" name="b")/>',
      '<meta (name="c" content="3"|content="3" name="c")/>',
    ].each { |r| @m.target!.should match(/#{r}/) }
  end

end
