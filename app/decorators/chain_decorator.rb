class ChainDecorator < ApplicationDecorator
  delegate_all

  def self.attributes
    table_columns
  end

  def self.table_columns
    %i[name chain_id chain_type explorer_address explorer_token explorer_tx metamask_rpc ]
  end

end
