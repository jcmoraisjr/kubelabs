import jenkins.model.*;

Jenkins.instance.setSlaveAgentPort(50000)
println "--> Agent port defined as :50000"
Jenkins.instance.setNumExecutors(0)
println "--> Number of executors defined as 0"
