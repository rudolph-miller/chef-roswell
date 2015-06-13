require 'serverspec'

set :backend, :exec

describe command("/usr/local/bin/ros --version") do
    its (:stdout) { should match /roswell/ }
end

describe command("/usr/local/bin/ros list installed sbcl-bin") do
  its (:stdout) { should match /sbcl-bin/ }
end

describe file("/etc/profile.d/roswell.sh") do
  it { should be_file }

  its (:content) { should eq "export PATH=$HOME/.roswell/bin:$PATH\n" }
end
