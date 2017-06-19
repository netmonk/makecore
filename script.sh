#!/usr/bin/env bash 
. ntmkstdlib.sh
USECOLOR=1
InitLib

## Env initialisation: 

home_dir=$(pwd)
config_file="${home_dir}/config"
sources_dir="$(pwd)/sources"
installed_kernel="${home_dir}/work/kernel/kernel_installed"
num_cores=$(getconf _NPROCESSORS_ONLN)



# Cleaning and ensuring work environment is ready for building
Start() {
	WriteInfo "Clean starts:" 
	rm -rf work
	mkdir work 
	mkdir -p sources
	WriteInfo "clean ends" 
}

get_value_from_conf(){
	[[ ! ${1} ]] && (WriteWarn "No pattern provided, unable to get value from null"; return 0)
	value=$(grep -i ^"$1" ${config_file} |cut -f2 -d'=')
	echo "${value}"
	return 0
}
# Downloading function
download_archive_and_extract() {
	[[ ! ${1} ]] &&(WriteWarn "No target provided, unable to download"; return 0 )

	target_url=$(get_value_from_conf "$1")
	archive_name="${target_url##*/}"
	archive_path="${sources_dir}/${archive_name}"
	use_local_source=$(get_value_from_conf USE_LOCAL_SOURCE)
	extract_dir="${home_dir}/work/${2}"
	
	if [ "$use_local_source" = "true" -a ! -f ${archive_path}  ]; then 
		WriteInfo "Source is not present, preparing to download it anyway" 
		use_local_source="false"
	fi 
	if [ ! "$use_local_source" = "true" ] ; then 
		WriteInfo "Start Downloading ${target_url}" 
		wget -c -P sources $target_url
	else 
		WriteInfo "Using local source ${archive_path}"
	fi 

	WriteInfo "Removing ${extract_dir}"
        rm -rf ${extract_dir}
	WriteInfo "Creating ${extract_dir}"
	mkdir -p ${extract_dir} 
	WriteInfo "Untaring ${archive_path} into ${extract_dir}"
	tar -xf ${archive_path} -C ${extract_dir}
	return 0
}

build_kernel() {
	echo "toto"
	
}




############ MAIN ############
Start

WriteInfo "Step 1 Getting the kernel and extracting"
dl=$(download_archive_and_extract KERNEL_SOURCE_URL kernel)
WriteInfo "Step 1 finished, kernel Sources retrieved and extracted" 

WriteInfo "Step 2 let's build the kernel" 
[[ ${dl} == 0  ]] && build_kernel || ExistScript  1 "unable to download and install kernel source tree, exiting!!!" 
WriteInfo "Step 2 kernel build" 

