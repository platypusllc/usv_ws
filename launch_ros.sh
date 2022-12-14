echo "######################################################################"
echo "######################################################################"
echo "######################################################################"
echo "This should only be run from inside the running docker instance, from the /ws directory, after doing: source install/setup.bash"
echo "DID YOU DO: source install/setup.bash  ?"
echo ""
ros2 launch autonomy_sim_bringup autonomy_sim.launch.py
