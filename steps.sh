# setup local cluster
crc setup

# start local cluster
crc start

# configure oc command
eval $(crc oc-env)

# login as developer
oc login -u developer https://api.crc.testing:6443

# Create a new project
oc new-project tour-of-heroes

# Deploy resources in a project
oc create -f tour-of-heroes/ --recursive
oc status

oc logs deploy/tour-of-heroes-web

oc get pod -l app=tour-of-heroes-web -o yaml | oc adm policy scc-subject-review -f -
# https://docs.openshift.com/container-platform/4.11/authentication/managing-security-context-constraints.html

# Login as kubeadmin
oc login -u kubeadmin -p TqRBE-MqwJe-NkVFJ-3ZeBK https://api.crc.testing:6443

# Create service account
oc create sa tour-of-heroes-sa
# Add anyuid security context
oc adm policy add-scc-to-user anyuid -z tour-of-heroes-sa
# Assign sa to the deployment
oc set sa deploy tour-of-heroes-web tour-of-heroes-sa

oc get pods

# Services
oc get services

# Expose services
oc expose service tour-of-heroes-web -l route=external --name=tour-of-heroes-web
oc expose service tour-of-heroes-api -l route=external --name=tour-of-heroes-api

# See routes
oc get routes

curl http://tour-of-heroes-web-tour-of-heroes.apps-crc.testing
curl http://tour-of-heroes-api-tour-of-heroes.apps-crc.testing/api/hero

# Access web console
crc console

# Delete project
oc delete project tour-of-heroes

# stop cluster
crc stop

# delete cluster
crc delete
