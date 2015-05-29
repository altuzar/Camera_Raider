ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :name
  menu :priority => 2

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :roles do |r|
      r.roles.map { |role| role.name }.join(", ")
    end
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :email
      f.input :password, :hint => "Not Required if not changing the password"  , :required => false
      f.input :password_confirmation
      f.input :roles, as: :select, multiple: true, collection: Role.all
    end
    f.actions
  end

  controller do
    def create
      @user = User.new(permitted_params[:user])
      add_roles(@user)
      create!
    end

    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      add_roles(resource)
      update!
      # super
    end

    private

      def add_roles(resource)
        resource.roles = []
        params[:user][:role_ids].each { |r| resource.roles.push(Role.find(r)) unless r.blank? }
      end

  end

  show do
    attributes_table do
      row :name
      row :email
      row :roles do |r|
        r.roles.map { |role| role.name }.join(", ")
      end
      row :encrypted_password
      row :reset_password_token
      row :reset_password_sent_at
      row :remember_created_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :confirmation_token
      row :confirmed_at
      row :confirmation_sent_at
      row :unconfirmed_email
      row :invitation_token
      row :invitation_created_at
      row :invitation_sent_at
      row :invitation_accepted_at
      row :invitation_limit
      row :invited_by
      row :invitation_token
      row :invited_by_id
    end
  end

end
