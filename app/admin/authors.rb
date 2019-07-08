ActiveAdmin.register Author do
  permit_params :first_name, :last_name, :biography
  actions :all, except: [:show, :destroy]

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    actions defaults: true do |author|
      link_to t('.delete'), author_path(author), method: :delete, data: { confirm: "#{t('.confirm_part1')} #{author.books.count} #{t('.confirm_part2')}" }
    end
  end

  filter :first_name
  filter :last_name
end
