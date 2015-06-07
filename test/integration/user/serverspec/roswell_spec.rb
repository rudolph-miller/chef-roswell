require 'serverspec'

set :backend, :exec

describe file("/home/kitchen/.roswell") do
  it { should be_directory }
end
