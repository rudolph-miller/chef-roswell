# encoding: utf-8
branch = node[:branch]
user = node[:user]
version = node[:version]

remote_file "/tmp/roswell-#{branch}.tar.gz" do
  source "https://github.com/snmsts/roswell/archive/#{branch}.tar.gz"
  notifies :run, "bash[install-roswell]", :immediately
end

bash "install-roswell" do
  user "root"
  cwd "/tmp"
  code <<-EOS
    tar zxvf roswell-#{branch}.tar.gz
    cd roswell-#{branch}
    sh ./bootstrap
    ./configure
    make
    make install
  EOS
  notifies :run, "bash[setup-roswell]", :immediately
end

bash "setup-roswell" do
  user user
  code %(ros setup)
  notifies :run, "bash[install-sbcl]", :immediately
end

bash "install-sbcl" do
  user user
  code %(ros install sbcl/#{version})
end
