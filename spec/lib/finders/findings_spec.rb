require 'spec_helper'
require 'dummy_finding'

describe CMSScanner::Finders::Findings do
  subject(:findings) { described_class.new }
  let(:finding)      { CMSScanner::DummyFinding }

  describe '#<<' do
    after { expect(findings).to eq @expected }

    context 'when no findings already in' do
      it 'adds it' do
        findings << finding.new('empty-test')
        @expected = [finding.new('empty-test')]
      end
    end

    context 'when findings already in' do
      let(:confirmed) { finding.new('confirmed') }

      before { findings << nil << nil << finding.new('test') << confirmed }

      it 'adds a confirmed result correctly and ignore the nil values' do
        confirmed_dup = confirmed.dup
        confirmed_dup.confidence = 100

        findings << finding.new('test2')
        findings << confirmed_dup

        confirmed.confirmed_by = confirmed_dup

        @expected = [] << finding.new('test') << confirmed << finding.new('test2')
      end
    end
  end
end
