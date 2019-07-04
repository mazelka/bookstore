ActiveAdmin.register Coupon do
  permit_params :name, :discount

  index do
    id_column
    column :name
    column :discount do |coupon|
      Money.new(coupon.discount).format
    end
    actions
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :discount do |coupon|
        Money.new(coupon.discount).format
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :discount do |coupon|
        Money.new(coupon.discount).format
      end
    end
  end
end
