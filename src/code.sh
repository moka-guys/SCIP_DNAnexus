#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

#Grab inputs
dx-download-all-inputs --parallel


# make output folders
mkdir -p ~/out ./genome ~/out/all_outputs ~/out/html_reports

# download SCIP docker image 
scip_docker_file_id=project-Gkvkbjj03P8qxxk16qb1yqqQ:file-J6Z33Fj03P8fk7J0BY7Z7PpJ
dx download ${scip_docker_file_id}

ls

scip_docker_image_file=$(dx describe ${scip_docker_file_id} --name)

echo ${scip_docker_image_file}
scip_docker_image_file=${scip_docker_image_file//:/-}
echo ${scip_docker_image_file}

scip_docker_image_name=$(tar xfO "${scip_docker_image_file}" manifest.json | sed -E 's/.*"RepoTags":\["?([^"]*)"?.*/\1/')

docker load < /home/dnanexus/"${scip_docker_image_file}"

echo ${mpileup_hbb}
echo ${mpileup_hbb_name}

filename=${mpileup_hbb_name} 

sample=$(echo ${filename} | grep -o -E 'SCIP[[:alnum:]]+' | tail -n1)


echo $sample 

# Create folder for HTML reports
output_html_dir="/home/dnanexus/out/html_reports/"
mkdir -p "${output_html_dir}"

docker run --name scip -v /home/dnanexus:/home/dnanexus ${scip_docker_image_name} ${output_html_dir} ${sample} ${mpileup_hbb_path} ${mpileup_sced_path} ${mpileup_hbb_155bp_path} ${mpileup_sced_155bp_path}  #> /home/dnanexus/${sample}_Report2.html

# upload outputs
dx-upload-all-outputs --parallel