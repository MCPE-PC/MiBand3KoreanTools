#!/usr/bin/env bash

# 초기화와 마무리를 제외한 모든 중간 과정에 포함합니다.
cd job
FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

ARCH="$(arch || uname -m)"
PUP_VERSION="${1:-0.4.0}"

# 아키텍쳐를 감지합니다.
case "$ARCH" in
	'amd64' | 'x86_64' )
		ARCH='amd64'
		;;
	'armel' | 'armhf' )
		ARCH='arm'
		;;
	'i386' | 'x86' )
		ARCH='386'
		;;
	'mips64el' )
		ARCH='mips64le'
		;;
	'ppc64el' )
		ARCH='ppc64le'
		;;
	'arm64' )
		;;
	* )
		exception "$ARCH(은)는 지원하지 않는 아키텍쳐입니다."
		;;
esac

(wget -q -O 'pup.zip' 'https://github.com/ericchiang/pup/releases/download/v'$PUP_VERSION'/pup_v'$PUP_VERSION'_linux_'$ARCH'.zip' &&\
 unzip -q 'pup.zip' && rm 'pup.zip' && chmod +x './pup') || exception 'pup(을)를 다운로드할 수 없습니다.'

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] pup(을)를 다운로드하였습니다."
