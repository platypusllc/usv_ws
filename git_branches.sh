echo "This script should only be run from your local filesystem, NOT from inside the running docker instance."
echo "Running this script form inside the running docker instance will result in a cryptic git error."
echo ""
echo "Git branche sfor usv_ws"
git branch -a
cd src/autonomy/
echo ""
echo "Git branches for autonomy"
git rev-parse HEAD
git branch -a
cd ../autonomy_interfaces
echo ""
echo "Git branches for autonomy_sim_interfaces"
git rev-parse HEAD
git branch -a
cd ../autonomy_sim_bringup
echo ""
echo "Git branches for autonomy_sim_bringup"
git rev-parse HEAD
git branch -a 
cd ../simusv
echo ""
echo "Git branches for simusv"
git rev-parse HEAD
git branch -a 
