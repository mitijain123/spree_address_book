class AddShippingAddressToAddresses < ActiveRecord::Migration
  def self.up
    change_table addresses_table_name do |t|
      t.bollean :shipping_address, {:default => true}
    end
  end

  def self.down
    change_table addresses_table_name do |t|
      t.remove :shipping_address
    end
  end

  def self.addresses_table_name
    table_exists?('addresses') ? :addresses : :spree_addresses
  end
end