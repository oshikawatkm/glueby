
require 'active_record'

RSpec.describe 'Glueby::AR::SystemInformation', active_record: true do

  describe '#synced_block_number' do
    describe '#valid' do
      subject { Glueby::AR::SystemInformation.count }
      it { expect(subject).to be 1 }
    end

    describe '#invalid' do
      context 'info_key is unique' do 
        subject do
          Glueby::AR::SystemInformation.create(
            info_key: 'synced_block_number',
            info_value: '1'
          )
        end
        it { expect {subject}.to raise_error ActiveRecord::RecordNotUnique }
      end
    end
  end

  describe '.synced_block_height' do
    subject { Glueby::AR::SystemInformation.synced_block_height }

    it { expect(subject).to be 1 }
  end

end