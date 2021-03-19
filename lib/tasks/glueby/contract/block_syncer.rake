module Glueby
  module Contract
    module Task
      module BlockSyncer

        def sync_block
          latest_block_num = Glueby::Internal::RPC.client.getblockcount
          saved_block = Glueby::Internal::Wallet::AR::SystemInformation.find_by(info_key: "synced_block_number")
          (saved_block.info_value.to_i..latest_block_num).each do |i|
            begin
              ::ActiveRecord::Base.transaction do
                block_hash = Glueby::Internal::RPC.client.getblockhash(i)
                import_block(block_hash)
                saved_block.update(info_value: i.to_s)
                puts "success in synchronization (block count=#{i.to_s})"
              end
            rescue => e
              puts "failed in synchronization (block count=#{saved_block.info_value}, reason=#{e.message})"
            end
          end
        end 

      end
    end
  end
end

namespace :glueby do
  namespace :contract do
    namespace :block_syncer do
      include Glueby::Contract::Task::Timestamp
      include Glueby::Contract::Task::BlockSyncer

      desc 'sync block into database'
      task :start, [] => [:environment] do |_, _|
        Glueby::Contract::Task::Timestamp.create
        Glueby::Contract::Task::Timestamp.confirm
        Glueby::Contract::Task::BlockSyncer.sync_block
      end

    end
  end
end