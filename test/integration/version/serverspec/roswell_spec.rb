require 'serverspec'

set :backend, :exec

describe command("/usr/local/bin/ros list installed sbcl") do
  its (:stdout) { should match /sbcl/ }

  its (:stdout) { should match /1.2.10/ }
end
