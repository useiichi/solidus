class CreateAdjustmentPromotionCodeAssociation < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_adjustments, :promotion_code_id, :integer
    add_index :spree_adjustments, :promotion_code_id
  end
end
