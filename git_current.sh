echo "This script should only be run from your local filesystem, NOT from inside the running docker instance."
echo "Running this script form inside the running docker instance will result in a cryptic git error."
cd src/autonomy/
echo "--------------------------------------------------"
echo "Current commit for autonomy"
git rev-parse HEAD
git log --name-status HEAD^..HEAD
git rev-parse --abbrev-ref HEAD
cd ../autonomy_interfaces
echo "--------------------------------------------------"
echo "Current commit for autonomy_sim_interfaces"
git rev-parse HEAD
git log --name-status HEAD^..HEAD
git rev-parse --abbrev-ref HEAD
cd ../autonomy_sim_bringup
echo "--------------------------------------------------"
echo "Current commit for autonomy_sim_bringup"
git rev-parse HEAD
git log --name-status HEAD^..HEAD
git rev-parse --abbrev-ref HEAD
cd ../simusv
echo "--------------------------------------------------"
echo "Current commit for simusv"
git rev-parse HEAD
git log --name-status HEAD^..HEAD
git rev-parse --abbrev-ref HEAD


