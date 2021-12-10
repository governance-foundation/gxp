
docker run -it --rm -v ${PWD}:/build/source -v ${HOME}/.m2:/build/.m2 --net=host aemdesign/centos-java-buildpack:jdk8 /bin/bash --login -c 'mvn dependency:get -Dmaven.repo.local=/build/.m2/repository -DrepoUrl=https://repo1.maven.org/maven2 -Dartifact=io.prometheus.jmx:jmx_prometheus_javaagent:LATEST -Ddest=/build/source/jmx_prometheus_javaagent.jar'


