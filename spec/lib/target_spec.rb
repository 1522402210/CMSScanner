require 'spec_helper'

describe CMSScanner::Target do
  subject(:target) { described_class.new(url, opts) }
  let(:url)        { 'http://e.org' }
  let(:opts)       { { scope: nil } }

  describe '#domain' do
    its(:domain) { should eq PublicSuffix.parse('e.org') }
  end

  describe '#scope' do
    let(:default_scope) { [PublicSuffix.parse('e.org')] }

    context 'when none supplied' do
      its(:scope) { should eq default_scope }
    end

    context 'when scope provided' do
      let(:opts) { super().merge(scope: [PublicSuffix.parse('*.e.org')]) }

      its(:scope) { should eq default_scope << opts[:scope].first }
    end
  end

  describe '#in_scope?' do
    context 'when default scope (target domain)' do
      [nil, '', 'http://out-of-scope.com', '//jquery.com/j.js'].each do |url|
        it "returns false for #{url}" do
          expect(target.in_scope?(url)).to eql false
        end
      end

      %w(https://e.org/file.txt http://e.org/ /relative).each do |url|
        it "returns true for #{url}" do
          expect(target.in_scope?(url)).to eql true
        end
      end
    end

    context 'when custom scope' do
      let(:opts) { { scope: ['*.e.org'] } }

      [nil, '', 'http://out-of-scope.com', '//jquery.com/j.js'].each do |url|
        it "returns false for #{url}" do
          expect(target.in_scope?(url)).to eql false
        end
      end

      %w(https://cdn.e.org/file.txt http://www.e.org/).each do |url|
        it "returns true for #{url}" do
          expect(target.in_scope?(url)).to eql true
        end
      end
    end
  end

  describe '#interesting_files' do
    before do
      expect(CMSScanner::Finders::InterestingFiles).to receive(:find).and_return(stubbed)
    end

    context 'when no findings' do
      let(:stubbed) { [] }

      its(:interesting_files) { should eq stubbed }
    end

    context 'when findings' do
      let(:stubbed) { ['yolo'] }

      it 'allows findings to be added with <<' do
        expect(target.interesting_files).to eq stubbed

        target.interesting_files << 'other-finding'

        expect(target.interesting_files).to eq(stubbed << 'other-finding')
      end
    end
  end
end
