#!/usr/bin/env bash 
. ntmkstdlib.sh
USECOLOR=1
InitLib

## Env initialisation: 

declare -r home_dir=$(pwd)
declare -r config_file="${home_dir}/config"
declare -r sources_dir="$(pwd)/sources"
declare -r work_dir="$(pwd)/work"
declare -r installed_kernel="${home_dir}/work/kernel/kernel_installed"
declare -r installed_glibc="${home_dir}/work/glibc/glibc_installed"
declare -r num_cores=$(getconf _NPROCESSORS_ONLN)
declare -r kernel_config="${home_dir}/kernel.config"



# Cleaning and ensuring work environment is ready for building
Start() {
	WriteInfo "Clean starts" 
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
		wget -c -P sources ${target_url}
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
	cd "${work_dir}/kernel"
	rm -rf ${installed_kerneL}
	mkdir -p  "${installed_kernel}"
	#parsing config file for options 
	use_user_local_config=$(get_value_from_conf USE_PREDEFINED_KERNEL_CONGIG)
	#Starting to work
	cd $(ls -d linux-*)
	WriteInfo "Running make mrproper"
	echo $num_job
	make mrproper -j $num_job
	WriteInfo "Installing kernel.config to source directory"
	cp ${kernel_config} .config
	sed -i "s/.*CONFIG_DEFAULT_HOSTNAME.*/CONFIG_DEFAULT_HOSTNAME=\"Citoyx - Corefreq\"/" .config
	sed -i "s/.*CONFIG_OVERLAY_FS.*/CONFIG_OVERLAY_FS=y/" .config
	sed -i "s/.*\\(CONFIG_KERNEL_.*\\)=y/\\#\\ \\1 is not set/" .config
	sed -i "s/.*CONFIG_KERNEL_XZ.*/CONFIG_KERNEL_XZ=y/" .config
	sed -i "s/.*CONFIG_KERNEL_XZ.*/CONFIG_KERNEL_XZ=y/" .config
	sed -i "s/^CONFIG_DEBUG_KERNEL.*/\\# CONFIG_DEBUG_KERNEL is not set/" .config
	sed -i "s/.*CONFIG_EFI_STUB.*/CONFIG_EFI_STUB=y/" .config
	echo "CONFIG_EFI_MIXED=y" >> .config
	WriteInfo "Building kernel"
	make CFLAGS="$cflags" bzImage -j $num_jobs
	cp arch/x86/boot/bzImage ${installed_kernel}/kernel
	WriteInfo "Generating Kernel headers"
	make INSTALL_HDR_PATH=${installed_kernel} headers_install -j $num_jobs
}




############ MAIN ############
Start

# Global compilation parameter

cflags=$(get_value_from_conf CFLAGS)
job_factor=$(get_value_from_conf JOB_FACTOR)
num_job=$((num_cores * job_factor))


WriteInfo "Step 1 Getting the kernel and extracting"
download_archive_and_extract KERNEL_SOURCE_URL kernel
status=$?
WriteInfo "Step 1 finished, kernel Sources retrieved and extracted" 


WriteInfo "Step 2 let's build the kernel" 

#[[ $status -eq  0 ]] && build_kernel || ExitScript  1 "unable to download and install kernel source tree, exiting!!!" 

WriteInfo "Step 2 kernel build" 

WriteInfo " Step 3 Getting Glibc" 
download_archive_and_extract GLIBC_SOURCE glibc
WriteInfo "Step 3 finished"

