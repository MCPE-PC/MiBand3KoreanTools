#!/usr/bin/env bash

# 초기화와 마무리를 제외한 모든 중간 과정에 포함합니다.
cd job
FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

APKTOOL_VERSION="${1:-2.3.4}"

type 'java' > /dev/null || exception 'Java(을)를 찾을 수 없습니다. Java 1.8 이상을 설치해주세요.'
(wget -q 'https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool' &&\
 wget -q -O 'apktool.jar' "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_$APKTOOL_VERSION.jar" &&\
 chmod +x './apktool' && chmod +x './apktool.jar') || exception 'Apktool(을)를 다운로드할 수 없습니다.'

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] Apktool(을)를 다운로드하였습니다."
