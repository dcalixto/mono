require 'rails/generators/base'
require 'rails/generators/active_record'

module Mono
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def inject_mono_into_application_controller
        inject_into_class(
          "app/controllers/application_controller.rb",
          ApplicationController,

          "
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  #protect_from_forgery with: :exception
  respond_to :html, :json


  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user


  def signed_in?
    current_user.present?
  end

  helper_method :signed_in?

  def authenticate_user!
    unless signed_in?
      redirect_to login_url, notice: 'Not authorized' 
    end
  end


  helper_method :authenticate_user!\n")

      end

      def create_or_inject_mono_into_user_model
        if File.exist? "app/models/user.rb"
          inject_into_file(
            "app/models/user.rb",

            "
    has_secure_password

  validates_uniqueness_of :email

  validates :username, :presence => true, :uniqueness => true, :length => { :in => 1..20 }
  validates_length_of :password, :in => 6..20, :on => :create


has_many :posts

  before_create { generate_token(:auth_token) }


  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def self.authenticate(username_or_email='', password='')
    if user = User.find_by_email(username_or_email)
    else
      user = User.find_by_username(username_or_email)
    end
    if user && user.match_password(password)
      return user
    else
      return false
    end
  end



def match_password(password='')
  :password_digest
end \n",

            after: "class User < #{models_inherit_from}\n",

          )

      else
        @inherit_from = models_inherit_from
        template("user.rb.erb", "app/models/user.rb")
        end
      end

      def create_mono_migration
        if users_table_exists?
          create_add_columns_migration
        else
          copy_migration 'create_users.rb'
        end
      end



      private

      def create_add_columns_migration
        if migration_needed?
          config = {
            new_columns: new_columns,
            new_indexes: new_indexes
          }

          copy_migration('add_mono_to_users.rb', config)
        end
      end

      def copy_migration(migration_name, config = {})
        unless migration_exists?(migration_name)
          migration_template(
            "db/migrate/#{migration_name}",
            "db/migrate/#{migration_name}",
            config.merge(migration_version: migration_version),
          )
        end
      end

      def migration_needed?
        new_columns.any? || new_indexes.any?
      end

      def new_columns
        @new_columns ||= {

          email: 't.string :email, null: false',
          name:  't.string :name, limit: 200, null: false',
          username:  't.string :username, limit: 200, null: false',
          password_digest: 't.string :password_digest, limit: 128 null: false',
          auth_token: 't.string :auth_token, limit: 128',


          avatar: 't.string :avatar',
          bio: 't.text :bio',
          slug:  't.string :slug',

          phone:  't.string :phone, limit: 128',
          facebook:  't.string :facebook',
          twitter:  't.string :twitter',
          instagram:  't.string :instagram',
          website:  't.string :website',

          latitude:  't.float :latitude',
          logitude: 't.float :logitude',

          ip_address: 't.string :ip_address',
          login_at: 't.datetime :login_at',



          password_reset_token: 't.string :password_reset_token, limit: 128',
          password_reset_sent_at: 't.datetime :password_reset_sent_at',
          confirmation_token: 't.string :confirmation_token, limit: 128'




        }.reject { |column| existing_users_columns.include?(column.to_s) }
      end

      def new_indexes
        @new_indexes ||= {
          index_users_on_email: 'add_index :users, :email unique: true',
          index_users_on_usermail: 'add_index :users, :username unique: true',
          index_users_on_slug: 'add_index :users, :slug'
        }.reject { |index| existing_users_indexes.include?(index.to_s) }
      end

      def migration_exists?(name)
        existing_migrations.include?(name)
      end

      def existing_migrations
        @existing_migrations ||= Dir.glob("db/migrate/*.rb").map do |file|
          migration_name_without_timestamp(file)
        end
      end



      def users_table_exists?
        if ActiveRecord::Base.connection.respond_to?(:data_source_exists?)
          ActiveRecord::Base.connection.data_source_exists?(:users)
        else
          ActiveRecord::Base.connection.table_exists?(:users)
        end
      end

      def existing_users_columns
        ActiveRecord::Base.connection.columns(:users).map(&:name)
      end

      def existing_users_indexes
        ActiveRecord::Base.connection.indexes(:users).map(&:name)
      end

      # for generating a timestamp when using `create_migration`
      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      def migration_version
        if Rails.version >= "5.0.0"
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end

      def models_inherit_from
        if Rails.version >= "5.0.0"
          "ApplicationRecord"
        else
          "ActiveRecord::Base"
        end
      end
    end
  end
end
