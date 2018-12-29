[ ! $MAGISK ] && abort "Rootless installs aren't currently supported"
cp $INSTALLER/common/unityfiles/modid.sh $INSTALLER/common/unityfiles/modid1.sh 
cat $INSTALLER/common/quickstep.sh >> $INSTALLER/common/unityfiles/modid1.sh 
cp $INSTALLER/common/unityfiles/modid1.sh $INSTALLER/common/quickstep.sh
install_script -l $INSTALLER/common/quickstep.sh