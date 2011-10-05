require 'tempfile'

require 'murlsh'

describe Murlsh do

  describe :cat_files do

    context 'when all files are there' do

      before do
        @f1 = Tempfile.new('f1')
        (1..2).each { |i| @f1.write "#{i}\n" }
        @f1.close

        @f2 = Tempfile.new('f2')
        (1..3).each { |i| @f2.write "#{i}\n" }
        @f2.close
      end

      after do
        @f1.unlink
        @f2.unlink
      end

      it 'should cat the files together and return the result' do
        Murlsh::Setup.cat_files([@f1.path, @f2.path]).should == <<eos
1
2
1
2
3
eos
      end

    end

    context 'when one or more files are missing' do

      it 'should raise no such file or directory' do
        lambda { Murlsh::Setup.cat_files(
          ['does_not_exist']) }.should raise_error(Errno::ENOENT)
      end

    end

  end

end
