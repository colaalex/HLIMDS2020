set_global_assignment -entity "pll_for_sdram_1" -library "lib_pll_for_sdram_1" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_for_sdram_1" -library "lib_pll_for_sdram_1" -name IP_TOOL_VERSION "17.1"
set_global_assignment -entity "pll_for_sdram_1" -library "lib_pll_for_sdram_1" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_for_sdram_1" -name SPD_FILE [file join $::quartus(sip_path) "pll_for_sdram_1.spd"]

set_global_assignment -library "lib_pll_for_sdram_1" -name MISC_FILE [file join $::quartus(sip_path) "pll_for_sdram_1_sim/pll_for_sdram_1.vo"]
