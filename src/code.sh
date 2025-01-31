#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail

#Grab inputs
dx-download-all-inputs --parallel


# make output folders
mkdir -p ~/out ./genome ~/out/all_outputs ~/out/html_report

# download SCIP docker image 
scip_docker_file_id=project-Gkvkbjj03P8qxxk16qb1yqqQ:file-GyKVgY803P8QP9BV0jYX4zY6
dx download ${scip_docker_file_id}

ls

# file seglh-scip:3bcb945-dirty.tar.gz

# gzip -t seglh-scip:3bcb945-dirty.tar.gz
# mv seglh-scip:3bcb945-dirty.tar.gz seglh-scip-3bcb945-dirty.tar.gz
# tar -tf seglh-scip-3bcb945-dirty.tar.gz




# tar -tf seglh-scip:3bcb945-dirty.tar.gz


scip_docker_image_file=$(dx describe ${scip_docker_file_id} --name)

echo ${scip_docker_image_file}
scip_docker_image_file=${scip_docker_image_file//:/-}
echo ${scip_docker_image_file}

scip_docker_image_name=$(tar xfO "${scip_docker_image_file}" manifest.json | sed -E 's/.*"RepoTags":\["?([^"]*)"?.*/\1/')

docker load < /home/dnanexus/"${scip_docker_image_file}"

echo ${mpileup_hbb}
#echo ${mpileup_hbb_path}
echo ${mpileup_hbb_name}

filename=${mpileup_hbb_name} #"SCIP060818_01_SCIP208_Nonacus_S1_sorted_HBB.mpileup"

sample=$(echo ${filename} | grep -o -E 'SCIP[0-9]+' | tail -n1)


echo $sample 

# load docker image
#docker load < /home/dnanexus/"${scip_docker_image_file}"
#docker run -v /home/dnanexus:/home/dnanexus --rm ${fh_docker_image_name} ~/out/PRS_output/PRS_output/${vcf_name}.vcf > ~/out/PRS_output/PRS_output/$samplename.txt

output_html_file_path="/home/dnanexus/out/html_report/${sample}_Report.html"

#docker run --name scip -v /home/dnanexus:/home/dnanexus ${scip_docker_image_name} ${output_html_file_path} "${sample}" ${mpileup_hbb_path} ${mpileup_sced_path} #> /home/dnanexus/${sample}_Report2.html

docker run --name scip -v /home/dnanexus:/home/dnanexus ${scip_docker_image_name} ${output_html_file_path} ${mpileup_hbb_path} ${mpileup_sced_path} #> /home/dnanexus/${sample}_Report2.html


#output_RData_dir="/home/dnanexus/out/RData/exomedepth_output/${bedfile_prefix}"
#output_RData_file="${output_RData_dir}/${bedfile_prefix}_readCount.RData"
#docker run -v /home/dnanexus:/home/dnanexus ${DOCKERIMAGENAME} readCount.R $output_RData_file $reference_fasta $bedfile_path ${bam_list[@]} $normals_RData_path



# docker exec scip ls /

# docker cp scip:/code . 
# docker cp scip:/code/* .
# ls /home/dnanexus
# ls

# mv /home/dnanexus/${sample}_Report.html ~/out/all_outputs

# docker run -v /home/dnanexus:/home/dnanexus --rm \
#   ${scip_docker_image_name} \
#   /home/dnanexus/out/html_report/${sample}_Report.html
#   /home/dnanexus/${samplesheet_path} \
#   /home/dnanexus/${mpileup_hbb_path} \
#   /home/dnanexus/${mpileup_sced_path} \


# ls /home/dnanexus


# upload outputs
dx-upload-all-outputs --parallel