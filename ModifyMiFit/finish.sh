#!/usr/bin/env bash

# 작업을 수행한 이후에 이 스크립트를 마지막으로 실행하십시오.

FILENAME=`basename "$0"`
function exception {
	echo "$1"
	echo "[$FILENAME] 예기치 못한 오류가 발생하여 종료합니다."
	exit 1
}

if [[ ! -d './dist' ]]; then
	mkdir dist
fi
if [[ -a './dist/output.apk' ]]; then
	NEW_FILENAME="output.old_$RANDOM-$RANDOM.apk"
	echo "기존에 있던 output.apk(을)를 $NEW_FILENAME(으)로 이동합니다."
	mv './dist/output.apk' "./dist/$NEW_FILENAME"
fi

mv './job/modified.apk' './dist/output.apk'
rm -f -r ./job

# 모든 과정이 끝났을 때 반드시 파일의 이름과 함께 안내해야 합니다.
echo "[$FILENAME] job 디렉터리를 정리하고, 변조 및 다시 빌드하고 정렬 및 서명한 Mi 피트를 ./dist/output.apk으로 이동하였습니다."
