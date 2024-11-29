

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "Encryption_Core" "NUM_INSTANCES" "DEVICE_ID"  "C_data_in_BASEADDR" "C_data_in_HIGHADDR" "C_key_in_BASEADDR" "C_key_in_HIGHADDR"
}
