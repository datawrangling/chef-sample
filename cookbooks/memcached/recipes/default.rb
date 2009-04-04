#
# Cookbook Name:: cron
# Recipe:: default
#

package "memcached"

template "/etc/memcached.conf" do
  owner "root"
  group "root"
  mode 0644   
  source "memcached.conf.erb"
  action :create
end
