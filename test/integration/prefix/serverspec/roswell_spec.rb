require 'serverspec'

set :backend, :exec

describe command("/opt/local/bin/ros --version") do
    its (:stdout) { should match /roswell/ }
end
