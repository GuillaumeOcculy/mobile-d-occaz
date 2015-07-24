ActiveAdmin.register Post::Post do

   controller do
      def scoped_collection
        Post::Post.is_for_admin.order_by_date
      end
    end

  index do
    column :id

    column :phone_name
    column :remote_url do |post|
      link_to(post.remote_url, post.remote_url, target: '_blank')
    end
    column :created_at

    actions defaults: false do |post|
      link_to(I18n.t('active_admin.edit'), edit_post_path(post, is_admin: true), target: '_blank', class: "member_link") +
      " " +
      link_to('Valider', validate_admin_post_post_path(post.id), class: "member_link") +
      " " +
      link_to(I18n.t('active_admin.delete'), admin_post_post_path(post.id), method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') }, class: "member_link")
    end

  end

   member_action :validate, method: :get do
    resource.admin_completed!
    redirect_to collection_path
  end

end
