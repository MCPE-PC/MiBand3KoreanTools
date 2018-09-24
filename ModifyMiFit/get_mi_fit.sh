#!/usr/bin/env bash

# 초기화와 마무리를 제외한 모든 중간 과정에 포함합니다.
cd job
FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

MI_FIT_VERSION="${1:-3.5.0}"
MI_FIT_VERSION="${MI_FIT_VERSION//./-}"

if [[ ! -x './pup' ]]; then
	exception 'pup(을)를 찾을 수 없거나 실행 권한이 없습니다. `./get_pup.sh`(을)를 실행한 적이 있는지 확인해주세요.'
fi

(wget -q -O 'original.apk' -U 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.81 Safari/537.36'\
 "https://www.apkmirror.com$(curl -H "Accept: text/html" -L -s\
 "https://www.apkmirror.com/apk/anhui-huami-information-technology-co-ltd/mi-fit/mi-fit-$MI_FIT_VERSION-release/mi-fit-$MI_FIT_VERSION-android-apk-download/download" |\
 ./pup 'a[rel="nofollow"][data-google-vignette="false"] attr{href}')") || exception 'Mi 피트를 다운로드할 수 없습니다.'

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] Mi 피트를 다운로드하였습니다."
