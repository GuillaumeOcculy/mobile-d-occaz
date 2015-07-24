ActiveAdmin.register Phone::Phone do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
  permit_params do
  	Phone::Phone.new.attributes.to_a.flatten.compact
  end

  form do |f|
  	
  	f.inputs

  	f.inputs do
	  	f.input :colors, as: :check_boxes
	  	f.input :memories, as: :check_boxes
  	end

  	f.actions
  end
  
end
