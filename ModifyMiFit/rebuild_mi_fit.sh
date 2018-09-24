#!/usr/bin/env bash

# 초기화와 마무리를 제외한 모든 중간 과정에 포함합니다.
cd job
FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

FIRMWARE_VERSION="${1:-1.5.0.11}"
# SPACES='            '

type 'java' > /dev/null || exception 'Java(을)를 찾을 수 없습니다. Java 1.8 이상을 설치해주세요.'

if [[ ! -d "../../MiBand3Firmwares/$FIRMWARE_VERSION" ]]; then
	exception "미밴드 3 펌웨어 $FIRMWARE_VERSION(을)를 찾을 수 없거나 디렉터리가 아닙니다. 미밴드 3 도구 모음이 모두 정상적으로 있는지 확인해주세요."
fi
if [[ ! -x apktool ]] || [[ ! -x apktool.jar ]]; then
	exception 'Apktool(을)를 찾을 수 없거나 실행 권한이 없습니다. `./get_apktool.sh`(을)를 실행한 적이 있는지 확인해주세요.'
fi
if [[ ! -x './jq' ]]; then
	exception 'jq(을)를 찾을 수 없거나 실행 권한이 없습니다. `./get_jq.sh`(을)를 실행한 적이 있는지 확인해주세요.'
fi
if [[ ! -r './original.apk' ]]; then
	exception 'Mi 피트를 찾을 수 없거나 읽기 권한이 없습니다. `./get_mi_fit.sh`(을)를 실행한 적이 있는지 확인해주세요.'
fi

# TODO: jq(을)를 사용하여 firmwares.json도 변조합니다. 그렇게 할 경우 미밴드 3 외의 장치의 최신 펌웨어와 동시 사용이 가능합니다.
(./apktool d original.apk -q && rm ./original/assets/Mili_wuhan.* && cp ../../MiBand3Firmwares/$FIRMWARE_VERSION/Mili_wuhan.* './original/assets' &&\
 `# 비정상적입니다. IFS=$'\n' read -r -d '' -a 'FIRMWARES' <<< $(cat "../../MiBand3Firmwares/$FIRMWARE_VERSION/firmwares.json" | ./jq '.wuhan[][]') &&\
 IFS=$'\n' read -r -d '' -a 'FIRMWARES_ORIGIN' <<< $(cat "./original/assets/firmwares.json" | ./jq '.wuhan[][]') &&\
 for INDEX in "${!FIRMWARES_ORIGIN[@]}"; do
 	$FIRMWARES_ORIGIN[$INDEX]="${FIRMWARES_ORIGIN[$INDEX]//./\\\\.}"
 done
 cat './original/assets/firmwares.json' > /dev/null | sed -e\
 "s/$SPACES\"name\": $FIRMWARES_ORIGIN[4],\n$SPACES\"version\": $FIRMWARES_ORIGIN[5]/$SPACES\"name\": $FIRMWARES_ORIGIN[4],\n$SPACES\"version\": $FIRMWARES_ORIGIN[5]/g"\
 > './original/assets/firmwares.json' && cat './original/assets/firmwares.json' > /dev/null  | sed -e\
 "s/$SPACES\"name\": $FIRMWARES_ORIGIN[6],\n$SPACES\"version\": $FIRMWARES_ORIGIN[7]/$SPACES\"name\": $FIRMWARES_ORIGIN[6],\n$SPACES\"version\": $FIRMWARES_ORIGIN[7]/g"\
 > './original/assets/firmwares.json'` rm ./original/assets/firmwares.json &&\
 cp ../../MiBand3Firmwares/$FIRMWARE_VERSION/firmwares.json ./original/assets/firmwares.json && ./apktool b original -q -o modified.apk) || exception '변조 및 다시 빌드하지 못하였습니다.'

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] Mi 피트를 변조 및 다시 빌드하였습니다."
