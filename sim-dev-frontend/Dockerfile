FROM ancine/rh_eap6

ARG SRC_GIT_REPO=http://gitlab.ancine.gov.br/
ARG SRC_GIT_BRANCH=develop

ENV SSO_AUTH_SERVER_URL http://sso.ancine.gov.br:8180/auth  
ENV KIE_SERVER_URL http://localhost:8080/kie-server/services/rest/server
ENV MODALIDADE_INCENTIVOS_URL http://10.1.125.96/sanfom-servicos/modalidadeIncentivo

ENV SRC_BUILD_DIR=/opt/jboss/src
ENV SRC_OUTPUT_DIR=$JBOSS_HOME/standalone/deployments

ENV H2_WAR_URL=https://www.dropbox.com/sh/c13togkkp9fq80f/AADODuQyNlTXK6H6LKc9IgZDa/h2console.war?dl=1
ENV KIE_SERVER_WAR_URL=https://repository.jboss.org/nexus/content/groups/public-jboss/org/kie/server/kie-server/6.5.0.Final/kie-server-6.5.0.Final-ee6.war
ENV SANFOM_SERVICOS_EAR_URL=https://www.dropbox.com/sh/c13togkkp9fq80f/AADUrgSq-g4ZZ7Oa-3A1tLQ4a/sanfom-servicos.ear?dl=1

COPY support/start.sh support/create-sim-kieserver-container.sh /opt/jboss/
USER root
RUN yum install -y git \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && curl -sSL http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz | tar xzf - -C /usr/share \
    && mv /usr/share/apache-maven-3.2.5 /usr/share/maven \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    && mkdir /opt/jboss/.m2 \
    && mkdir -p /opt/jboss/data /opt/jboss/src  \
    && chmod +x /opt/jboss/start.sh \
    && chmod +x /opt/jboss/create-sim-kieserver-container.sh \
    && chown -R jboss:jboss /opt/jboss/src /opt/jboss/.m2

USER jboss
RUN  curl -J -L $H2_WAR_URL -o $JBOSS_HOME/standalone/deployments/h2console.war \
  && curl -J -L $KIE_SERVER_WAR_URL -o $JBOSS_HOME/standalone/deployments/kie-server.war \
  && curl -J -L $SANFOM_SERVICOS_EAR_URL -o $JBOSS_HOME/standalone/deployments/sanfom-servicos.ear 

RUN git clone --depth 1 $SRC_GIT_REPO/sin-bpm.git --single-branch -b $SRC_GIT_BRANCH $SRC_BUILD_DIR/sin-bpm ; \
    git clone --depth 1 $SRC_GIT_REPO/ancine-api.git -b $SRC_GIT_BRANCH $SRC_BUILD_DIR/ancine-api ; \
    git clone --depth 1 $SRC_GIT_REPO/sin.git -b $SRC_GIT_BRANCH $SRC_BUILD_DIR/sin ; \
    rm -rf $SRC_GIT_BRANCH $SRC_BUILD_DIR/sin-bpm/.git ; \
    rm -rf $SRC_GIT_BRANCH $SRC_BUILD_DIR/ancine-api/.git ; \
    rm -rf $SRC_GIT_BRANCH $SRC_BUILD_DIR/sin/.git ; \
    exit 0

EXPOSE 8080 9990

VOLUME /opt/jboss/src
VOLUME /opt/jboss/jboss/standalone/logs
VOLUME /opt/jboss/data

CMD ["/opt/jboss/start.sh"]
