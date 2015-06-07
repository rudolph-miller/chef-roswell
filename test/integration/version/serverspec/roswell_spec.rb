require 'serverspec'

set :backend, :exec

describe command("/usr/local/bin/ros list installed sbcl") do
  its (:stdout) { should match /sbcl/ }
end
