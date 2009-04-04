#
# Cookbook Name:: users
# Recipe:: default
#

node[:users].each do |user_obj|
  group user_obj[:username] do
    gid user_obj[:gid]
  end
  
  user user_obj[:username] do
    action :create
    
    uid user_obj[:uid]
    gid user_obj[:gid]
    shell "/bin/bash"
  end

  directory "/data/home/#{user_obj[:username]}" do
    owner user_obj[:uid]
    group user_obj[:gid]
    mode 0755
    recursive true
  end
  
  link "/home/#{user_obj[:username]}" do
    to "/data/home/#{user_obj[:username]}"
  end
  
  execute "chown homedir to user" do
    command "chown -R #{user_obj[:username]}:#{user_obj[:username]} /data/home/#{user_obj[:username]}"
  end
  
  directory "/data/home/#{user_obj[:username]}/.ssh" do
    owner user_obj[:uid]
    group user_obj[:gid]
    mode 0700
  end
  
  template "/data/home/#{user_obj[:username]}/.ssh/authorized_keys" do
    owner user_obj[:uid]
    group user_obj[:gid]
    mode 0600
    source "authorized_keys.erb"
    
    variables :user => user_obj
  end if user_obj[:public_key]
end
