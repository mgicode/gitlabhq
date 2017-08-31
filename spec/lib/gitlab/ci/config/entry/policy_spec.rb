require 'spec_helper'

describe Gitlab::Ci::Config::Entry::Policy do
  let(:entry) { described_class.new(config) }

  context 'when using simplified policy' do
    describe 'validations' do
      context 'when entry config value is valid' do
        context 'when config is a branch or tag name' do
          let(:config) { %w[master feature/branch] }

          describe '#valid?' do
            it 'is valid' do
              expect(entry).to be_valid
            end
          end

          describe '#value' do
            it 'returns key value' do
              expect(entry.value).to eq config
            end
          end
        end

        context 'when config is a regexp' do
          let(:config) { ['/^issue-.*$/'] }

          describe '#valid?' do
            it 'is valid' do
              expect(entry).to be_valid
            end
          end
        end

        context 'when config is a special keyword' do
          let(:config) { %w[tags triggers branches] }

          describe '#valid?' do
            it 'is valid' do
              expect(entry).to be_valid
            end
          end
        end
      end

      context 'when entry value is not valid' do
        let(:config) { [1] }

        describe '#errors' do
          it 'saves errors' do
            expect(entry.errors)
              .to include /policy config should be an array of strings or regexps/
          end
        end
      end
    end
  end

  context 'when policy strategy does not match' do
    let(:config) { 'string strategy' }

    it 'returns information about errors' do
      expect(entry.errors)
        .to include /has to be either an array of conditions or a hash/
    end
  end

  describe '.default' do
    it 'does not have a default value' do
      expect(described_class.default).to be_nil
    end
  end
end