#!/usr/bin/env bash

# 초기화와 마무리를 제외한 모든 중간 과정에 포함합니다.
cd job
FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

KEYSTORE="${1:-../release-key.jks}"

echo -n 'Mi 피트를 서명하려면 60초 내로 Enter를 누르거나 LF를 입력하세요. 서명하지 않으려면 내용을 지우고 Enter를 누르거나 LF를 입력하세요. 60초가 지나면 자동으로 종료됩니다: '
read -e -i 'continue' -t 60
if [[ "$REPLY" == '' ]]; then
	echo
	echo '서명하지 않습니다. 나중에 서명하려는 경우 `'./$FILENAME'`(을)를 입력하세요.'
	exit
fi

type 'java' > /dev/null || exception 'Java(을)를 찾을 수 없습니다. Java 1.8 이상을 설치해주세요.'

if [[ ! -r "$KEYSTORE" ]]; then
	exception "$KEYSTORE(을)를 찾을 수 없습니다."
fi
if [[ ! -x '../../SignApk/apksigner' ]]; then
	exception 'apksigner(을)를 찾을 수 없거나 실행 권한이 없습니다. `chmod +x ../../SignApk/apksigner`(을)를 실행한 다음 다시 진행해주세요.'
fi
if [[ ! -x '../../SignApk/zipalign' ]]; then
	exception 'zipalign(을)를 찾을 수 없거나 실행 권한이 없습니다. `chmod +x ../../SignApk/zipalign`(을)를 실행한 다음 다시 진행해주세요.'
fi

# APK(을)를 정렬합니다.
(../../SignApk/zipalign -v -p 4 modified.apk modified-aligned.apk > /dev/null && rm modified.apk &&\
 mv 'modified-aligned.apk' 'modified.apk') || exception 'APK(을)를 정렬하지 못하였습니다.'

# APK(을)를 서명합니다.
echo '아래에 키스토어 비밀번호를 입력하세요.'
(../../SignApk/apksigner sign --ks $KEYSTORE --out modified-release.apk modified.apk && rm modified.apk &&\
 mv 'modified-release.apk' 'modified.apk' && ../../SignApk/apksigner verify modified.apk) || exception 'APK(을)를 서명하지 못하였습니다.'

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] Mi 피트를 정렬 및 서명하였습니다."
