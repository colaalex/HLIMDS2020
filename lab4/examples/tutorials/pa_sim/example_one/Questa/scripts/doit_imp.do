##############################################################################
# Source:    doit_imp.do
# File:      Tcl script for runing third RTL and GLS PA simulations
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
     -coverage \
     +IMPLEMENT \
     -assertcover \
     -msgmode both -displaymsgmode both \
     -l rtl.log \
     -wlf rtl.wlf

# run simulation
do ./Questa/scripts/sim.do
