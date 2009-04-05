require 'rubygems'
require 'json'

dna = {
  :user => "mr_you",
  :mysql_root_pass => "REPLACE_ME!",
  
  :users =>  [
    {
      :username => "mr_you",
      :password => "REPLACE_ME!",
      :authorized_keys => "ssh-rsa A+CfSXuMTJvY6Ys6zdxRljhzBbh/XHU8= Corey@system-refresh.local",
      :gid => 1000,
      :uid => 1000,
      :sudo => true
    },
    {
      :username => "mr_app",
      :password => "REPLACE_ME!",
      :authorized_keys => ["ssh-rsa AA+CfSXuMTJvY6Ys6zdxRljhzBbh/XHU8= Corey@system-refresh.local", "ssh-rsa AyoHWDURPJFDk8dfjDKFjd8ds8+/XHUZ= jon@moo.com"],
      :gid => 1001,
      :uid => 1001,
      :sudo => true
    },
  ],
  
  :applications => [
    {
      :name => "sample",
      :ports => [3000, 3001],
      :user => "mr_app",
      :group => "mr_app",
    }
  ],
  
  :gems => [
    "rake", 
    {:name => "mysql", :version => "2.7"}, # Rails craves this
    "thin"
  ],
  
  :ebs_volumes => [
    {:device => "sdq1", :path => "/data"},
    {:device => "sdq2", :path => "/db"}
  ],
  
  :cronjobs => [
    {:name => "pointless",
     :minute => 30,
     :hour => 4,
     :day => nil,
     :month => nil,
     :weekday => nil,
     :user => "root",
     :command => "date > /data/wow_a_cron_example.txt"
    }
  ],
  
  :recipes => [
    "users",
    "openssh",
    "ec2-ebs",
    "mysql",
    "git",
    "logrotate",
    "nginx",
    "memcached",
    "cron",
    "gems",
    "rack_apps"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)