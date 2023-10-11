require_relative '../lib/helpers'

class TestClass
  include Helpers
end

describe Helpers do
  let(:obj) { TestClass.new }
  describe '#prompt' do
    let(:input) { StringIO.new('Hello') }
    let(:output) { StringIO.new }

    before do
      # $stdin = input
      $stdout = output
    end

    after do
      $stdin = STDIN
      $stdout = STDOUT
    end
    it 'prints prompt and reads input' do
      obj.prompt('Say something nice ')

      expect(output.string).to eq 'Say something nice '
      puts
    end
    it 'takes user input and returns it' do
      $stdout = STDOUT
      allow(obj).to receive(:gets).and_return('Hello')
      res = obj.prompt('Say something nice')

      expect(res).to eq('Hello')
    end
  end
end
