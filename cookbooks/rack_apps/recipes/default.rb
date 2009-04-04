#
# Cookbook Name:: rack_apps
# Recipe:: default
#

include_recipe "nginx"
include_recipe "memcached"

node[:applications].each do |app|
  directory "/data/apps/#{app[:name]}/shared/config//" do
    owner node[:user]
    group node[:user]
    mode 0755
    action :create
    recursive true
  end
  
  # Nginx Setup
  # -----------
  template "#{node[:nginx_dir]}/apps/#{app[:name]}.conf" do
    owner node[:user]
    group node[:user]
    mode 0644
    source "app.conf.erb"
    variables(
      :app_name => app[:name],
      :ports => app[:ports].kind_of?(String) ? app[:ports].split(/\s*,\s*/) : [app[:ports]],
      :http_bind_port => app[:bind_port] || 80,
      :server_names => app[:server_names]
    )
  end
  
  template "#{node[:nginx_dir]}/apps/#{app[:name]}-custom.conf" do
    owner node[:user]
    group node[:user]
    mode 0644
    source "app.custom.erb"
  end
  
  # Memcached setup
  # ---------------
  template "/data/apps/#{app[:name]}/shared/config/memcached.yml" do
    owner node[:user]
    group node[:user]
    mode 0644
    source "memcached.yml.erb"    
    action :create
    
    variables(:app => app) 
  end
  
  # Mysql setup
  # -----------
  db_user_attrs = {:user => node[:user], :password => node[:user_pass], :database => "#{app[:name]}_production"}
  
  template "/data/apps/#{app[:name]}/shared/config/database.yml" do
    owner node[:user]
    group node[:user]
    mode 0655
    source "database.yml.erb"
    variables(db_user_attrs)
    action :create_if_missing
  end
  
  # Create empty db
  template "/tmp/empty-#{app[:name]}-db.sql" do
    owner 'root'
    group 'root'
    mode 0644
    source "empty-db.sql.erb"
    variables(db_user_attrs)
  end
  
  execute "create-empty-db-for-#{app}" do
    command "mysql -u root -p'#{node[:mysql_root_pass]}' < /tmp/empty-#{app[:name]}-db.sql"
  end
end if node[:applications]

service "nginx" do
  action [ :restart ]
end