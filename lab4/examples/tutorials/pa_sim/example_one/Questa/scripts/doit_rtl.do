##############################################################################
# Source:    doit_rtl.do
# File:      Tcl script for runing all three RTO PA simulating with Questa
# Remarks:   Mentor Low Power tutorial
##############################################################################
onbreak {resume}
if {[batch_mode]} {
    onerror {quit -f}
}

echo "#"
echo "# NOTE: Starting PA simulaiton ..."
echo "#"
vsim work.top_opt \
     +nowarnTSCALE \
     +nowarnTFMPC \
     +notimingchecks \
     -pa \
     -pa_highlight \
     -covergae \
     -msgmode both -displaymsgmode both \
     -l rtl.log \
     -wlf rtl.wlf

# run simulation
do ./Questa/scripts/sim.do
