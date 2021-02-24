#!/binPbash

if true; then
    for user in `seq 1 200`; do 
        oc delete -n opendatahub --wait=false pvc jupyterhub-nb-user${user}-pvc
        oc delete -n opendatahub --wait=false pod jupyterhub-nb-user${user}
        oc delete -n opendatahub --wait=false cm jupyterhub-singleuser-profile-user${user}
        oc delete -n opendatahub --wait=false namespace workshop-user${user}
    done
fi