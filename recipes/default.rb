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
dot_roswell_dir = "#{ roswell[:user] ? Dir.home(roswell[:user]) : Dir.home(node[:current_user]) }/.roswell"
init_lisp_path = dot_roswell_dir + "/init.lisp" 

directory src_dir do
  action :create
  recursive true
end

directory dot_roswell_dir do
  action :create
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
  user roswell[:user]
  code %(#{ roswell[:prefix] }/bin/ros install #{ roswell[:version] })
  not_if{ roswell[:version].nil? or roswell[:version].empty? }
end

template "/etc/profile.d/roswell.sh" do
  owner roswell[:user]
  group roswell[:user]
  mode 0644
end

template init_lisp_path do
  owner roswell[:user]
  group roswell[:user]
  mode 0644
  not_if { Dir.exists?(dot_roswell_dir) and File.exists?(init_lisp_path) }
end
