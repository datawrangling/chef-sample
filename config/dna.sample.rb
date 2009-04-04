require 'rubygems'
require 'json'

dna = {
  :user => "corey",
  :mysql_root_pass => "replace_me!",
  
  :users =>  [
    {
      :username => "corey",
      :public_key => "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA64su5eJdKxaoHKDZ7VTowobuLHSbv36OuJKbX0RDI1/MmsTchq3YYjtvFzAF749CZDu/yoHWDURPZbC65cEnNezB7qvG0s45LaLJkU8pJr1DBgJ11vLBoREHPYT3OaxKeXXBhwGSV2BT+CfSXuMTJvY6Ys6zdxRljhzBbh/XHU8= corey@whitehouse.gov",
      :gid => 1000,
      :uid => 1000,
      :sudo => true
    }
  ],
  
  :applications => [
    {
      :name => "sample",
      :ports => "3000,3001"
    }
  ],
  
  :gems => ["rake", "thin"],
  
  :ebs_volumes => [
    {
      :device => "sdq1",
      :path => "/data"
    },
    {
      :device => "sdq2",
      :path => "/db"
    }
  ],
  
  :recipes => [
    "users",
    "ec2-ebs",
    "mysql",
    "git",
    "gems",
    "logrotate",
    "nginx",
    "memcached",
    "cron",
    "rack_apps"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)