require 'serverspec'

set :backend, :exec

describe file("/usr/local/src/roswell-master") do
  it { should be_directory }
end
