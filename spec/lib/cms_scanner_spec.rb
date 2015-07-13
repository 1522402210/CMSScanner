require 'spec_helper'

module CMSScanner
  module Controller
    # Failure class for testing
    class SpecFailure < Base
      def before_scan
        fail 'error spotted'
      end
    end
  end
end

describe CMSScanner do
  let(:target_url) { 'http://wp.lab/' }

  before do
    scanner = CMSScanner::Scan.new
    scanner.controllers.first.class.parsed_options = { url: target_url }
  end

  describe 'typhoeus_on_complete' do
    before { CMSScanner.total_requests = 0 }

    # TODO: find a way to test the cached requests which should not be counted
    it 'returns the expected number of requests' do
      stub_request(:get, /.*/)

      CMSScanner::Browser.get(target_url)

      expect(CMSScanner.total_requests).to eql 1
    end
  end

  describe '#app_name' do
    it 'returns the excpected string' do
      expect(CMSScanner.app_name).to eql 'cms_scanner'
    end
  end
end

describe CMSScanner::Scan do
  subject(:scanner)    { described_class.new }
  let(:controller)     { CMSScanner::Controller }

  describe '#new, #controllers' do
    its(:controllers) { should eq([controller::Core.new]) }
  end

  describe '#run' do
    after do
      scanner.run

      if defined?(run_error)
        expect(scanner.run_error).to be_a run_error.class
        expect(scanner.run_error.message).to eql run_error.message
      end
    end

    it 'runs the controlllers and calls the formatter#beautify' do
      hydra = CMSScanner::Browser.instance.hydra

      expect(scanner.controllers).to receive(:run).ordered
      expect(hydra).to receive(:abort).ordered
      expect(scanner.formatter).to receive(:beautify).ordered
    end

    # Maybe there is a way to give the parser the raw ARGV to parse, instead
    # of use the expect on the results
    context 'when no required option supplied' do
      let(:run_error) { OptParseValidator::NoRequiredOption.new('The option url is required') }

      it 'calls the formatter to display the usage view' do
        expect(scanner.controllers.option_parser)
          .to receive(:results)
          .and_raise(run_error.class, run_error.message)

        expect(scanner.formatter).to receive(:output)
          .with('@usage', msg: run_error.message)
      end
    end

    context 'when an error is raised during the #run' do
      let(:run_error) { RuntimeError.new('error spotted') }

      it 'aborts the scan with the associated output' do
        scanner.controllers[0] = controller::SpecFailure.new

        expect(scanner.controllers.option_parser).to receive(:results).and_return({})

        expect(scanner.formatter).to receive(:output)
          .with('@scan_aborted', hash_including(reason: run_error.message, trace: anything, verbose: nil))
      end
    end
  end

  describe '#datastore' do
    its(:datastore) { should eq({}) }
  end

  describe '#exit_hook' do
    # No idea how to test that, maybe with another at_exit hook ? oO
    xit
  end
end
