include_recipe "build-essential"
include_recipe "curl::libcurl"
include_recipe "package-tar"
include_recipe "package-bzip2"
include_recipe "autoconf"
include_recipe "automake"
include_recipe "zlib"

roswell = node[:roswell]
src_dir = "#{ roswell[:prefix] }/src"
roswell_dir = "#{ src_dir }/roswell-#{ roswell[:branch] }"

directory src_dir do
  action :create
  recursive true
end

tar_extract "https://github.com/snmsts/roswell/archive/#{ roswell[:branch] }.tar.gz" do
  target_dir src_dir
  creates roswell_dir
  notifies :run, "bash[install-roswell]", :immediately
end

bash "install-roswell" do
  cwd roswell_dir
  user roswell[:user]
  code <<-EOS
    PATH=/usr/local/bin:$PATH sh ./bootstrap
    ./configure --prefix #{ roswell[:prefix] }
    make
    sudo make install
    #{ roswell[:prefix] }/bin/ros setup
  EOS
  notifies :run, "bash[install-sbcl]", :immediately
end

bash "install-sbcl" do
  code %(#{ roswell[:prefix] }/bin/ros install #{ roswell[:version] })
  not_if{ roswell[:version].nil? or roswell[:version].empty? }
end
