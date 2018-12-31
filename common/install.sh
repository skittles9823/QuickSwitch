#[ ! $MAGISK ] && abort "Rootless installs aren't currently supported"
[ -d $MAGISKTMP/img/lawnstep ] && touch $MAGISKTMP/img/lawnstep/.remove
cp $INSTALLER/common/unityfiles/modid.sh $INSTALLER/common/unityfiles/modid1.sh 
cat $INSTALLER/common/quickstep.sh >> $INSTALLER/common/unityfiles/modid1.sh 
cp $INSTALLER/common/unityfiles/modid1.sh $INSTALLER/common/quickstep.sh
install_script -l $INSTALLER/common/quickstep.sh