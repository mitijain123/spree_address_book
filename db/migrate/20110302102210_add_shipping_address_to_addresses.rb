class AddShippingAddressToAddresses < ActiveRecord::Migration
  def self.up
    change_table addresses_table_name do |t|
      t.bollean :is_shipping_add, {:default => false}
    end
  end

  def self.down
    change_table addresses_table_name do |t|
      t.remove :is_shipping_add
    end
  end

  def self.addresses_table_name
    table_exists?('addresses') ? :addresses : :spree_addresses
  end
end