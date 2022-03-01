# metanetworkprocessing

Clone the repo, build the docker image and start a docker contianer

```
git clone git@github.com:jgockley62/metanetworkprocessing.git
docker build -t metanets /Docker/
mkdir /<path_to_working_Direcctory>/error
mkdir /<path_to_working_Direcctory>/out
mkdir /<path_to_working_Direcctory>/temp
docker run -it -d -v "/<path_to_working_Direcctory>/:/root/" --name networks metanets
```

Sample network run code:
```
sudo docker exec -itd networks /bin/sh -c "export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib && export PATH=/usr/lib64/openmpi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib64/openmpi/bin && mpiexec --allow-run-as-root --mca orte_base_help_aggregate 0 --mca btl_base_warn_component_unused 0 -np 1 Rscript /root/Reprocessing_Metnetwork_Analysis/Network_Wrapper.R -u <USER> -p <PASSWORD> -c /root/genie3.yml > /root/log.log"

```
