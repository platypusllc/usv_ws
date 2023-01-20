echo "This script should only be run from your local filesystem, NOT from inside the running docker instance."
echo "Running this script form inside the running docker instance will result in a cryptic git error."
cd src/autonomy/
echo "##############################"
echo "Status for autonomy"
git status
cd ../autonomy_interfaces
echo "##############################"
echo "Status for autonomy_sim_interfaces"
git status
cd ../autonomy_sim_bringup
echo "##############################"
echo "Status for autonomy_sim_bringup"
git status
cd ../simusv
echo "##############################"
echo "Status for simusv"
git status
