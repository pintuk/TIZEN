#!/bin/bash

# Auto Launch Tool
# Author: Pintu Kumar (pintu.k@samsung.com)
# This tool automically launch application and move it to the background


#Redwood
applist_redwood="phone contacts message browser setting clock email music-player gallery myfile voicerecorder camera-app facebook video-player calculator popsync calendar episode keepit smartsearch smemo system-monitor"

#Kiran Lite
#applist="phone contacts message-lite browser setting-lite clock-lite email music-player-lite gallery-lite myfile-lite voicerecorder-lite camera-app-lite video-player-lite calculator taskmgr"
applist="gallery-lite camera-app-lite music-player-lite phone contacts message-lite browser fm-radio-lite clock-lite voicerecorder-lite email calendar-lite myfile-lite gallery-lite video-player-lite dailybriefing-weather-lite calculator setting google-search maps-lite memo srfxzv8GKR.YouTube dropbox ku8GJJH2Mc.Cricket"


#cleanup
#su
#dmesg -C
#echo "" > /var/log/messages
#dmesg -n 7

count=0
num=0
max_cma=0
max_iommu=0
log_file=dmesg.log
auto_log=autolaunch.log

echo "[PINTU]: App Launching ------> STARTED..." > $auto_log
touch $log_file
dmesg > $log_file
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $log_file
while true
do
	num=0
	curr_iommu=0
	curr_cma=0
	dmesg -C
	for i in $applist
	do
		free -tm >> $auto_log
		cat /proc/buddyinfo >> $auto_log
		#This is used for memory Compaction monitoring
		cat /proc/vmstat | grep compact >> $auto_log
		dmesg -C
		curr_cma=`cat /sys/kernel/debug/ion/ion_heap_cma_overlay | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		curr_iommu=`cat /sys/kernel/debug/ion/ion_heap_system | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		if [ $curr_cma -gt $max_cma ]
		then
			max_cma=$curr_cma
		fi
		if [ $curr_iommu -gt $max_iommu ]
		then
			max_iommu=$curr_iommu
		fi
		echo "===================================================" >> $auto_log
		echo "[PINTU] ---> START_TIME: "`date` >> $auto_log
		if [ "$i" = "ku8GJJH2Mc.Cricket" ]
		then
			launch_app $i
			sleep 5
		else
			launch_app com.samsung.$i
		fi
		if [ "$i" = "srfxzv8GKR.YouTube" ]
		then
			launch_app $i
			sleep 5
		fi
		echo "[PINTU] ---> App Launching: "$i >> $auto_log
		echo "[PINTU] ---> FINISH_TIME: "`date` >> $auto_log
		free -tm >> $auto_log
		curr_cma=`cat /sys/kernel/debug/ion/ion_heap_cma_overlay | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		curr_iommu=`cat /sys/kernel/debug/ion/ion_heap_system | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		if [ $curr_cma -gt $max_cma ]
		then
			max_cma=$curr_cma
		fi
		if [ $curr_iommu -gt $max_iommu ]
		then
			max_iommu=$curr_iommu
		fi
		#cat /proc/buddyinfo
		#This is used for memory Compaction monitoring
		cat /proc/vmstat | grep compact >> $auto_log
		cat /proc/zoneinfo | grep nr_free_cma >> $auto_log
		#memps -a
		#./readbuddy.out
		num=`expr $num + 1`
		sleep 15
		if [ "$i" = "camera-app-lite" ]
		then
			/opt/usr/media/keyinput /dev/input/event0 115 #For Camera capture using volume key
			sleep 5
		fi
		#/opt/usr/media/keyinput /dev/input/event2 158
		/opt/usr/media/keyinput /dev/input/event0 139
		curr_cma=`cat /sys/kernel/debug/ion/ion_heap_cma_overlay | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		curr_iommu=`cat /sys/kernel/debug/ion/ion_heap_system | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		if [ $curr_cma -gt $max_cma ]
		then
			max_cma=$curr_cma
		fi
		if [ $curr_iommu -gt $max_iommu ]
		then
			max_iommu=$curr_iommu
		fi
		echo "[PINTU]: MAX DRM_CMA: "$max_cma >> $auto_log
		echo "[PINTU]: MAX DRM_IOMMU: "$max_iommu >> $auto_log
		cat /proc/pagetypeinfo >> $auto_log
		echo "===================================================" >> $auto_log
		echo "[PINTU] ---> START_TIME: `date`" >> $log_file
		dmesg >> $log_file
		echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $log_file
		sleep 5
	done
	count=`expr $count + 1`
	echo ""
	echo "[PINTU]: @@@@@@@@@@@@@ All <$num> App Launching -----> FINISHED, count: <$count> @@@@@@@@@@@@@" >> $auto_log
	echo ""
	/opt/usr/media/keyinput /dev/input/event0 139
	if [ $count -gt 200 ]
	then
		echo "XXXXXXX  [PINTU] - LAUNCHING ------> ENDED - 500 times ! XXXXXXXXX" >> $auto_log
		free -tm >> $auto_log
		cat /proc/buddyinfo >> $auto_log
		cat /proc/vmstat | grep compact >> $auto_log
		cat /proc/zoneinfo | grep nr_free_cma >> $auto_log
		cat /proc/pagetypeinfo >> $auto_log
		memps -a >> $auto_log
		#./readbuddy.out
		curr_cma=`cat /sys/kernel/debug/ion/ion_heap_cma_overlay | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		curr_iommu=`cat /sys/kernel/debug/ion/ion_heap_system | grep drm | awk '{print $3}' | awk -F: '{print $2}'`
		if [ $curr_cma -gt $max_cma ]
		then
			max_cma=$curr_cma
		fi
		if [ $curr_iommu -gt $max_iommu ]
		then
			max_iommu=$curr_iommu
		fi
		echo "[PINTU]: FINAL MAX DRM_CMA: "$max_cma >> $auto_log
		echo "[PINTU]: MAX DRM_IOMMU: "$max_iommu >> $auto_log
		break;
	fi
	sleep 15
done


