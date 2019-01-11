[ -d $MAGISKTMP/img/lawnstep ] && touch $MAGISKTMP/img/lawnstep/remove
SWITCHDIR=/data/user_de/0/xyz.paphonb.quickstepswitcher/files
[ -d $SWITCHDIR ] && touch $SWITCHDIR/lastChange
cp -f $INSTALLER/common/unityfiles/modid.sh $INSTALLER/common/unityfiles/quickswitch.sh
sed -i -e "/# CUSTOM USER SCRIPT/ r $INSTALLER/common/quickstep.sh" -e '/# CUSTOM USER SCRIPT/d' $INSTALLER/common/unityfiles/quickstep.sh
mv -f $INSTALLER/common/unityfiles/quickstep.sh $INSTALLER/common/quickstep.sh
install_script -l $INSTALLER/common/quickstep.sh