#!/bin/bash

toHexFromStr()
{
	str=$1
	byte1=${str:2:2}
	byte2=${str:4:2}
	byte3=${str:6:2}
	byte4=${str:8:2}

	#printf "$byte1 $byte2 $byte3 $byte4"
	printf "\x$byte4\x$byte3\x$byte2\x$byte1"
	#return $out
}


# toHexFromStr "0x00000005"
# data=$?
# printf $data

cp ${BASE_DIR}/images/u-boot.bin ${BASE_DIR}/../pack/
cp ${BASE_DIR}/images/uImage ${BASE_DIR}/../pack/
cp ${BASE_DIR}/images/rootfs.jffs2 ${BASE_DIR}/../pack/
cd ${BASE_DIR}/../pack/

Init_Maker="0x00000005"
Uboot_File='u-boot.bin'
Kernel_File='uImage'
RootFS_File='rootfs.jffs2'
ENV_File='env.txt'
File_Number=4

echo $RootFS_File
PACK_FILE='nuc977_jffs2_pack.bin'

Uboot_Size=`stat --format=%s $Uboot_File`
Ubootfile_Size=`stat --format=%s $Uboot_File`
Kernel_Size=`stat --format=%s $Kernel_File`
Rootfs_Size=`stat --format=%s $RootFS_File`
ENV_Size=$((0x10000))

Kernelfile_Size=`stat --format=%s $Kernel_File`
Rootfsfile_Size=`stat --format=%s $RootFS_File`

storageSize=$((64*1024))

#FILE_Len=$(((Uboot_Size+storageSize-1)/storageSize*storageSize))
#FILE_Len=$((FILE_Len+(Kernel_Size+storageSize-1)/storageSize*storageSize))
Uboot_Size=$((Uboot_Size+16+8+(51*8)))
#if [ $((Uboot_Size/16*16)) -ne $((Uboot_Size)) ];then
#	Uboot_Size=$(((Uboot_Size/16+1)*16))
#fi
if [ $((Kernel_Size/16*16)) -ne $((Kernel_Size)) ];then
	Kernel_Size=$(((Kernel_Size/16+1)*16))
fi
if [ $((Rootfs_Size/16*16)) -ne $((Rootfs_Size)) ];then
	Rootfs_Size=$(((Rootfs_Size/16+1)*16))
fi
# Uboot_Size=$(((Uboot_Size+storageSize-1)/storageSize*storageSize))
FILE_Len=$(((Uboot_Size+storageSize-1)/storageSize*storageSize))
FILE_Len=$((FILE_Len+(Kernel_Size+storageSize-1)/storageSize*storageSize))
# FILE_Len=$((Uboot_Size+Kernel_Size))
# File_Number=3
# if ! [[ $Rootfs_Size =~ '^[0-9]+$' ]];then
# 	File_Number=2
# 	echo 'File_Number=2'
# else
# 	FILE_Len=$((FILE_Len+(Rootfs_Size+storageSize-1)/storageSize*storageSize))
# fi
FILE_Len=$((FILE_Len+(Rootfs_Size+storageSize-1)/storageSize*storageSize))
FILE_Len=$((FILE_Len+(ENV_Size+storageSize-1)/storageSize*storageSize))

# FILE_Len=$(((FILE_Len+storageSize-1)/storageSize*storageSize))
echo "file length $FILE_Len"

offset=0

toHexFromStr '0x00000005' > $PACK_FILE
toHexFromStr `printf '0x%.8x' $FILE_Len` >> $PACK_FILE
toHexFromStr `printf '0x%.8x' $File_Number` >> $PACK_FILE
toHexFromStr '0xffffffff' >> $PACK_FILE

: $((offset+=16))
echo "Uboot_Size $Uboot_Size"
toHexFromStr `printf '0x%.8x' $Uboot_Size` >> $PACK_FILE
toHexFromStr '0x00000000' >> $PACK_FILE
toHexFromStr '0x00000002' >> $PACK_FILE
toHexFromStr '0xffffffff' >> $PACK_FILE
: $((offset+=16))

printf '\x20' >> $PACK_FILE
printf '\x54' >> $PACK_FILE
printf '\x56' >> $PACK_FILE
printf '\x4E' >> $PACK_FILE
toHexFromStr '0x00e00000' >> $PACK_FILE
toHexFromStr `printf '0x%.8x' $Uboot_Size` >> $PACK_FILE
toHexFromStr '0xffffffff' >> $PACK_FILE
: $((offset+=16))

toHexFromStr '0xaa55aa55' >> $PACK_FILE
toHexFromStr '0x00000032' >> $PACK_FILE
: $((offset+=8))


# 1
toHexFromStr '0xB0000220' >> $PACK_FILE
toHexFromStr '0x01000000' >> $PACK_FILE
: $((offset+=8))
# 2
toHexFromStr '0xB0000264' >> $PACK_FILE
toHexFromStr '0xC0000018' >> $PACK_FILE
: $((offset+=8))
# 3
toHexFromStr '0xB0000220' >> $PACK_FILE
toHexFromStr '0x01000018' >> $PACK_FILE
: $((offset+=8))
# 4
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 5
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 6
toHexFromStr '0xB0001808' >> $PACK_FILE
toHexFromStr '0x00008030' >> $PACK_FILE
: $((offset+=8))
# 7
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 8
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 9
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 10
toHexFromStr '0xB0001800' >> $PACK_FILE
toHexFromStr '0x00030476' >> $PACK_FILE
: $((offset+=8))
# 11
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 12
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x00000021' >> $PACK_FILE
: $((offset+=8))
# 13
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 14
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x00000023' >> $PACK_FILE
: $((offset+=8))
# 15
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 16
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 17
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 18
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x00000027' >> $PACK_FILE
: $((offset+=8))
# 19
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 20
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 21
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 22
toHexFromStr '0xB0001820' >> $PACK_FILE
toHexFromStr '0x00000000' >> $PACK_FILE
: $((offset+=8))
# 23
toHexFromStr '0xB0001824' >> $PACK_FILE
toHexFromStr '0x00000000' >> $PACK_FILE
: $((offset+=8))
# 24
toHexFromStr '0xB000181C' >> $PACK_FILE
toHexFromStr '0x00004000' >> $PACK_FILE
: $((offset+=8))
# 25
toHexFromStr '0xB0001818' >> $PACK_FILE
toHexFromStr '0x00000332' >> $PACK_FILE
: $((offset+=8))
# 26
toHexFromStr '0xB0001810' >> $PACK_FILE
toHexFromStr '0x00000006' >> $PACK_FILE
: $((offset+=8))
# 27
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x00000027' >> $PACK_FILE
: $((offset+=8))
# 28
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 29
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 30
toHexFromStr '0x55AA55AA' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 31
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x0000002B' >> $PACK_FILE
: $((offset+=8))
# 32
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x0000002B' >> $PACK_FILE
: $((offset+=8))
# 33
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x0000002B' >> $PACK_FILE
: $((offset+=8))
# 34
toHexFromStr '0xB0001818' >> $PACK_FILE
toHexFromStr '0x00000232' >> $PACK_FILE
: $((offset+=8))
# 35
toHexFromStr '0xB000181C' >> $PACK_FILE
toHexFromStr '0x00004781' >> $PACK_FILE
: $((offset+=8))
# 36
toHexFromStr '0xB000181C' >> $PACK_FILE
toHexFromStr '0x00004401' >> $PACK_FILE
: $((offset+=8))
# 37
toHexFromStr '0xB0001804' >> $PACK_FILE
toHexFromStr '0x00000020' >> $PACK_FILE
: $((offset+=8))
# 38
toHexFromStr '0xB0001834' >> $PACK_FILE
toHexFromStr '0x00888820' >> $PACK_FILE
: $((offset+=8))
# 39
toHexFromStr '0xB0000218' >> $PACK_FILE
toHexFromStr '0x00000008' >> $PACK_FILE
: $((offset+=8))
# 40
toHexFromStr '0xB80030A0' >> $PACK_FILE
toHexFromStr '0x00007FFF' >> $PACK_FILE
: $((offset+=8))
# 41
toHexFromStr '0xB80030E0' >> $PACK_FILE
toHexFromStr '0x0000FF00' >> $PACK_FILE
: $((offset+=8))
# 42
toHexFromStr '0xB8003120' >> $PACK_FILE
toHexFromStr '0x0000FFFC' >> $PACK_FILE
: $((offset+=8))
# 43
toHexFromStr '0xB8003160' >> $PACK_FILE
toHexFromStr '0x0000F800' >> $PACK_FILE
: $((offset+=8))
# 44
toHexFromStr '0xB80031A0' >> $PACK_FILE
toHexFromStr '0x0000803C' >> $PACK_FILE
: $((offset+=8))
# 45
toHexFromStr '0xB80031E0' >> $PACK_FILE
toHexFromStr '0x0000FF7C' >> $PACK_FILE
: $((offset+=8))
# 46
toHexFromStr '0xB8003220' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
: $((offset+=8))
# 47
toHexFromStr '0xB000022C' >> $PACK_FILE
toHexFromStr '0x00000100' >> $PACK_FILE
: $((offset+=8))
# 48
toHexFromStr '0xB000022C' >> $PACK_FILE
toHexFromStr '0x00000100' >> $PACK_FILE
: $((offset+=8))
# 49
toHexFromStr '0xB000022C' >> $PACK_FILE
toHexFromStr '0x00000100' >> $PACK_FILE
: $((offset+=8))
# 50
toHexFromStr '0xB000022C' >> $PACK_FILE
toHexFromStr '0x00000100' >> $PACK_FILE
: $((offset+=8))

echo $((offset/16*16)) 
echo $((offset))

while [ $((offset/16*16)) -ne $((offset)) ]
do
	toHexFromStr '0x00000000' >> $PACK_FILE
	: $((offset+=4))
done

# : $((offset+=16))

dd if=$Uboot_File of=$PACK_FILE bs=1 count=$Ubootfile_Size seek=$offset

: $((offset+=Ubootfile_Size))
echo "Uboot $offset"

toHexFromStr `printf '0x%.8x' $ENV_Size` >> $PACK_FILE
toHexFromStr '0x00080000' >> $PACK_FILE
toHexFromStr '0x00000001' >> $PACK_FILE
toHexFromStr '0xffffffff' >> $PACK_FILE
: $((offset+=16))

env_data="baudrate=115200"
curenv_size=${#env_data}
env_data=$env_data'\x00'
(( curenv_size++ ))

bootcmd="bootcmd=sf probe 0 18000000; sf read 0x7FC0 0x200000 `printf '0x%.8x' $Kernel_Size`; bootm 0x7fc0"
(( curenv_size+=${#bootcmd} ))
env_data=$env_data$bootcmd
env_data=$env_data'\x00'
(( curenv_size++ ))

env_data=$env_data"bootdelay=0"
env_data=$env_data'\x00'
(( curenv_size+=12 ))

env_data=$env_data"ethact=emac"
env_data=$env_data'\x00'
(( curenv_size+=12 ))

env_data=$env_data"ethaddr=00:00:00:11:66:88"
env_data=$env_data'\x00'
(( curenv_size+=26 ))

env_data=$env_data"stderr=serial"
env_data=$env_data'\x00'
(( curenv_size+=14 ))

env_data=$env_data"stdin=serial"
env_data=$env_data'\x00'
(( curenv_size+=13 ))

env_data=$env_data"stdout=serial"
env_data=$env_data'\x00'
(( curenv_size+=14 ))

echo "curenv_size $curenv_size"
# echo -n -e $env_data
echo -n -e $env_data > "env.bat"


while [ $((curenv_size)) -ne $((ENV_Size-4)) ]
do
	printf '\x00' >> "env.bat"
	curenv_size=$((curenv_size+1))
	# echo "curenv_size $curenv_size"
done
# echo ${#env_data}

# crc32=`cksum env.bat | awk '{print $1}'`
crc32=`./crc32 env.bat`
echo $crc32
toHexFromStr `printf '0x%.8x' $crc32` >> $PACK_FILE
: $((offset+=4))

dd if="env.bat" of=$PACK_FILE bs=1 count=$((ENV_Size-4)) seek=$offset

: $((offset+=(ENV_Size-4)))

echo "Kernel_Size $Kernelfile_Size $Kernel_Size"
toHexFromStr `printf '0x%.8x' $Kernel_Size` >> $PACK_FILE
toHexFromStr '0x00200000' >> $PACK_FILE
toHexFromStr '0x00000000' >> $PACK_FILE
toHexFromStr '0xffffffff' >> $PACK_FILE
: $((offset+=16))
dd if=$Kernel_File of=$PACK_FILE bs=1 count=$Kernelfile_Size seek=$offset

: $((offset+=Kernelfile_Size))
while [ $((offset/16*16)) -ne $((offset)) ]
do
	toHexFromStr '0x00000000' >> $PACK_FILE
	: $((offset+=4))
done
echo "Kernel $offset"

echo $RootFS_File $Rootfsfile_Size $Rootfs_Size
# if [[ $Rootfs_Size =~ '^[0-9]+$' ]];then
toHexFromStr `printf '0x%.8x' $Rootfs_Size` >> $PACK_FILE
toHexFromStr '0x00800000' >> $PACK_FILE
toHexFromStr '0x00000000' >> $PACK_FILE
toHexFromStr '0xffffffff' >> $PACK_FILE
: $((offset+=16))
dd if=$RootFS_File of=$PACK_FILE bs=1 count=$Rootfsfile_Size seek=$offset
: $((offset+=Rootfsfile_Size))
while [ $((offset)) -ne $((FILE_Len)) ]
do
	toHexFromStr '0x00000000' >> $PACK_FILE
	: $((offset+=4))
	# echo "Rootfsfile_Size+++++"
done
# fi
