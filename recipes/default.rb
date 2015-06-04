include_recipe "curl::libcurl"
include_recipe "autoconf"
include_recipe "automake"

roswell = node[:roswell]
branch = roswell[:branch]
version = roswell[:version]

remote_file "/tmp/roswell-#{branch}.tar.gz" do
  source "https://github.com/snmsts/roswell/archive/#{branch}.tar.gz"
  notifies :run, "bash[install-roswell]", :immediately
end

bash "install-roswell" do
  cwd "/tmp"
  code <<-EOS
    tar zxvf roswell-#{branch}.tar.gz
    cd roswell-#{branch}
    PATH=/usr/local/bin:$PATH sh ./bootstrap
    ./configure
    make
    sudo make install
  EOS
  notifies :run, "bash[setup-roswell]", :immediately
end

bash "setup-roswell" do
  code %(ros setup)
  notifies :run, "bash[install-sbcl]", :immediately
end

bash "install-sbcl" do
  code %(ros install sbcl/#{version})
end
