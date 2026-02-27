#!/bin/awk -f
# Apply fixed "BogoMIPS" & Memory in dmesg
BEGIN{
	# dmesg cpu
	regex_dmesg_cpu1="[0-9.]+ BogoMIPS"
	regex_dmesg_cpu2="5116L"
	# dmesg mem
	regex_dmesg_mem1="Memory:.*total"
	regex_dmesg_mem2="Memory:.*highmem"
	regex_dmesg_lowmem="    lowmem  :"
	# top
	regex_top="Mem:.*cached"
	# free mem
	regex_free_mem="Mem:[0-9 \t]+"
	# free buffer
	regex_free_buffer="-\/\\+ buffers:[0-9 \t]+"
	# /proc/cpuinfo
	regex_cpuinfo="BogoMIPS[ \t:]+[0-9.]"
	# /proc/cmdline
	regex_cmdline="mem=[0-9]+M"
	# /proc/meminfo
	regex_arr_meminfo[0]="MemTotal:[ 0-9]+kB"
	regex_arr_meminfo[1]="MemFree:[ 0-9]+kB"
	regex_arr_meminfo[2]="Buffers:[ 0-9]+kB"
	regex_arr_meminfo[3]="[^a-zA-Z]Cached:[ 0-9]+kB"
	regex_arr_meminfo[4]="SwapCached:[ 0-9]+kB"
	regex_arr_meminfo[5]="Active:[ 0-9]+kB"
	regex_arr_meminfo[6]="Inactive:[ 0-9]+kB"
	regex_arr_meminfo[7]="Active\\(anon\\):[ 0-9]+kB"
	regex_arr_meminfo[8]="Inactive\\(anon\\):[ 0-9]+kB"
	regex_arr_meminfo[9]="Active\\(file\\):[ 0-9]+kB"
	regex_arr_meminfo[10]="Inactive\\(file\\):[ 0-9]+kB"
	regex_arr_meminfo[11]="Unevictable:[ 0-9]+kB"
	regex_arr_meminfo[12]="Mlocked:[ 0-9]+kB"
	regex_arr_meminfo[13]="SwapTotal:[ 0-9]+kB"
	regex_arr_meminfo[14]="SwapFree:[ 0-9]+kB"
	regex_arr_meminfo[15]="Dirty:[ 0-9]+kB"
	regex_arr_meminfo[16]="Writeback:[ 0-9]+kB"
	regex_arr_meminfo[17]="AnonPages:[ 0-9]+kB"
	regex_arr_meminfo[18]="Mapped:[ 0-9]+kB"
	regex_arr_meminfo[19]="Shmem:[ 0-9]+kB"
	regex_arr_meminfo[20]="Slab:[ 0-9]+kB"
	regex_arr_meminfo[21]="SReclaimable:[ 0-9]+kB"
	regex_arr_meminfo[22]="SUnreclaim:[ 0-9]+kB"
	regex_arr_meminfo[23]="KernelStack:[ 0-9]+kB"
	regex_arr_meminfo[24]="PageTables:[ 0-9]+kB"
	regex_arr_meminfo[25]="NFS_Unstable:[ 0-9]+kB"
	regex_arr_meminfo[26]="Bounce:[ 0-9]+kB"
	regex_arr_meminfo[27]="WritebackTmp:[ 0-9]+kB"
	regex_arr_meminfo[28]="CommitLimit:[ 0-9]+kB"
	regex_arr_meminfo[29]="Committed_AS:[ 0-9]+kB"
	regex_arr_meminfo[30]="VmallocTotal:[ 0-9]+kB"
	regex_arr_meminfo[31]="VmallocUsed:[ 0-9]+kB"
	regex_arr_meminfo[32]="VmallocChunk:[ 0-9]+kB"
}
{
	line = $0;
	FS = "[^0-9]+";
	if(match(line, regex_dmesg_cpu1)) {
		var_bef = substr(line, 1, RSTART-1);
		var_aft = substr(line, RSTART+RLENGTH);
		var_pat = substr(line, RSTART, RLENGTH-9);
		printf("%s%.2f BogoMIPS%s\n", var_bef, 1325.46, var_aft);
	}
	else if(match(line, regex_dmesg_cpu2)) {
		var_bef = substr(line, 1, RSTART-1);
		var_aft = substr(line, RSTART+RLENGTH);
		printf("%s5116H%s\n", var_bef, var_aft);
	}
	else if(match(line, regex_dmesg_mem1)) {
		var_bef = substr(line, 1, RSTART-1);
		printf("%sMemory: 119MB = 119MB total\n", var_bef);
	}
	else if(match(line, regex_dmesg_mem2)) {
		var_bef = substr(line, 1, RSTART-1);
		printf("%sMemory: 115768k/115768k available, 6088k reserved, 0K highmem\n", var_bef);
	}
	else if(match(line, regex_dmesg_lowmem)) {
		var_bef = substr(line, 1, RSTART-1);
		printf("%s    lowmem  : 0xc0000000 - 0xc7700000   ( 119 MB)\n", var_bef);
	}
	else if(match(line, regex_top)) {
		var_bef = substr(line, 1, RSTART-1);
		printf("%sMem: %dK used, %dK free, %dK shrd, %dK buff, %dK cached\n",
		       var_bef, $2*2, $3*2, $4*2, $5*2, $6*2);
	}
	else if(match(line, regex_free_mem)) {
		var_bef = substr(line, 1, RSTART-1);
		printf("%sMem: %13d%13d%13d%13d%13d\n",
		       var_bef, $2*2, $3*2, $4*2, $5*2, $6*2);
	}
	else if(match(line, regex_free_buffer)) {
		var_bef = substr(line, 1, RSTART-1);
		printf("%s-/+ buffers: %18d%13d\n",
		       var_bef, $2*2, $3*2);
	}
	else if(match(line, regex_cpuinfo)) {
		var_bef = substr(line, 1, RSTART-1);
		FS = "[ \t]+"
		printf("%sBogoMIPS        : %.2f\n",
		       var_bef, 1325.46);
	}
	else if(match(line, regex_cmdline)) {
		var_bef = substr(line, 1, RSTART-1);
		var_aft = substr(line, RSTART+RLENGTH);
		printf("%smem=119M%s\n",
		       var_bef, var_aft);
	}
	else {
		printed = 0;
		for (var_x in regex_arr_meminfo) {
			if(match(line, regex_arr_meminfo[var_x])) {
				FS = " "
				var_bef = substr(line, 1, RSTART-1);
				var_fmt = var_bef"%"length($1)"s%"24-length($1)"d kB\n";
				$2 = $2*2;
				printf(""var_fmt"", $1, $2);
				printed = 1;
			}
		}
		if (0 == printed)
			print line;
	}
}

