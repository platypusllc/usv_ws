echo "This script should only be run from your local filesystem, NOT from inside the running docker instance."
echo "Running this script form inside the running docker instance will result in a cryptic git error."
cd src/autonomy/
echo "Pulling for autonomy"
git pull
cd ../autonomy_interfaces
echo "Pulling for autonomy_sim_interfaces"
cd ../autonomy_sim_bringup
echo "Pulling for autonomy_sim_bringup"
git pull
